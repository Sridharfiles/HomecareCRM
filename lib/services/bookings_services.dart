import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reference to bookings collection
  CollectionReference get bookingsCollection =>
      _firestore.collection('bookings');

  // Reference to bookings_payments collection for payment linkage
  CollectionReference get bookingsPaymentsCollection =>
      _firestore.collection('bookings_payments');

  // Public getter for current user
  User? get currentUser => _auth.currentUser;

  /// Create a new booking with service details
  Future<String> createBooking({
    required ServiceModel service,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required int selectedHours,
    required String paymentMethod,
    required double cost,
    required String paymentId,
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? upiId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Format time as string
      final hour =
          selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
      final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
      final minute = selectedTime.minute.toString().padLeft(2, '0');
      final formattedTime = '$hour:$minute $period';

      // Create booking document (only booking details, no payment info)
      final bookingData = {
        // User Information
        'userId': user.uid,
        'userEmail': user.email,
        'userName': user.displayName ?? 'Unknown',

        // Booking Details (Core Information)
        'selectedDate': selectedDate,
        'selectedTime': formattedTime,
        'selectedHours': selectedHours,
        'serviceTitle': service.title,
        'servicePrice': service.price,

        // Status and timestamps
        'bookingStatus': 'pending',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Add booking to Firestore
      DocumentReference docRef = await bookingsCollection.add(bookingData);
      final bookingId = docRef.id;

      // Create booking_payment record linking booking with payment details
      final bookingPaymentData = <String, dynamic>{
        'bookingId': bookingId,
        'paymentId': paymentId,
        'userId': user.uid,
        'paymentMethod': paymentMethod, // 'paypal', 'cash', or 'upi'
        'cost': cost, // Total cost of service
        'currency': paymentMethod == 'upi' ? 'INR' : 'USD',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Add payment method specific details to booking_payment
      if (paymentMethod == 'paypal') {
        if (cardHolderName != null)
          bookingPaymentData['cardHolderName'] = cardHolderName;
        if (cardNumber != null) bookingPaymentData['cardNumber'] = cardNumber;
        if (expiryDate != null) bookingPaymentData['expiryDate'] = expiryDate;
        if (cvv != null) bookingPaymentData['cvv'] = cvv;
      } else if (paymentMethod == 'upi') {
        if (upiId != null) bookingPaymentData['upiId'] = upiId;
      }

      // Add booking_payment record to Firestore
      await bookingsPaymentsCollection.add(bookingPaymentData);

      return bookingId; // Return booking ID
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  /// Get all bookings for current user
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query =
          await bookingsCollection
              .where('userId', isEqualTo: user.uid)
              .orderBy('createdAt', descending: true)
              .get();

      return query.docs
          .map(
            (doc) => {
              'bookingId': doc.id,
              ...doc.data() as Map<String, dynamic>,
            },
          )
          .toList();
    } catch (e) {
      print('Error fetching user bookings: $e');
      rethrow;
    }
  }

  /// Get booking by ID
  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    try {
      final doc = await bookingsCollection.doc(bookingId).get();
      if (!doc.exists) {
        return null;
      }

      return {'bookingId': doc.id, ...doc.data() as Map<String, dynamic>};
    } catch (e) {
      print('Error fetching booking: $e');
      rethrow;
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      await bookingsCollection.doc(bookingId).update({
        'bookingStatus': newStatus,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  /// Update booking with additional information
  Future<void> updateBooking(
    String bookingId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = Timestamp.now();
      await bookingsCollection.doc(bookingId).update(updates);
    } catch (e) {
      print('Error updating booking: $e');
      rethrow;
    }
  }

  /// Delete booking (only if status is pending)
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final booking = await getBookingById(bookingId);
      if (booking == null) {
        throw Exception('Booking not found');
      }

      // Allow cancellation only for pending bookings
      if (booking['bookingStatus'] != 'pending') {
        throw Exception('Only pending bookings can be cancelled');
      }

      await bookingsCollection.doc(bookingId).update({
        'bookingStatus': 'cancelled',
        'updatedAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      rethrow;
    }
  }

  /// Stream of user bookings (real-time updates)
  Stream<List<Map<String, dynamic>>> getUserBookingsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return bookingsCollection
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => {
                      'bookingId': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    },
                  )
                  .toList(),
        );
  }

  /// Get booking statistics for current user
  Future<Map<String, int>> getBookingStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final bookings =
          await bookingsCollection.where('userId', isEqualTo: user.uid).get();

      int totalBookings = bookings.docs.length;
      int pendingBookings = 0;
      int confirmedBookings = 0;
      int completedBookings = 0;
      int cancelledBookings = 0;

      for (var doc in bookings.docs) {
        final status = doc['bookingStatus'] as String?;
        switch (status) {
          case 'pending':
            pendingBookings++;
            break;
          case 'confirmed':
            confirmedBookings++;
            break;
          case 'completed':
            completedBookings++;
            break;
          case 'cancelled':
            cancelledBookings++;
            break;
        }
      }

      return {
        'total': totalBookings,
        'pending': pendingBookings,
        'confirmed': confirmedBookings,
        'completed': completedBookings,
        'cancelled': cancelledBookings,
      };
    } catch (e) {
      print('Error fetching booking statistics: $e');
      rethrow;
    }
  }
}
