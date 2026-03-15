import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Payment Gateway Configuration
  static const String MERCHANT_UPI_ID = 'sridharkumaresan4-1@okicici';
  static const double BASE_PRICE = 0.0; // in rupees (INR) - Subtotal is 0 for UPI testing
  static const double DELIVERY_FEE = 1.0; // Fixed delivery fee for testing (in INR for UPI)

  // UPI Transaction Limits (per bank/app - in Rupees)
  // These are typical limits. Actual limits may vary by bank
  static const Map<String, double> UPI_BANK_LIMITS = {
    'ICICI': 100000.0,  // ₹1,00,000
    'HDFC': 100000.0,
    'SBI': 100000.0,
    'Axis': 100000.0,
    'GOOGLE_PAY': 100000.0,
    'PHONEPE': 100000.0,
    'BHIM': 100000.0,
    'AMAZON_PAY': 50000.0,  // Amazon Pay typically has lower limits
  };
  
  static const double DEFAULT_UPI_LIMIT = 100000.0;
  static const double RECOMMENDED_RETRY_AMOUNT = 50000.0;

  // References to collections
  CollectionReference get paymentsCollection =>
      _firestore.collection('payments');

  CollectionReference get bookingPaymentsCollection =>
      _firestore.collection('booking_payments');

  /// Calculate total amount for the service
  double calculateTotalAmount({
    required double servicePrice,
    required int selectedHours,
    double couponDiscount = 0.0,
  }) {
    final subtotal = servicePrice * selectedHours;
    final total = subtotal - couponDiscount + DELIVERY_FEE;
    return total;
  }

  /// Process Real UPI Payment - Creates payment record after UPI transaction
  Future<Map<String, dynamic>> processUPIPayment({
    String? userUpiId,
    required double amount,
    required String bookingId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create payment record in Firestore
      final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
      final paymentData = {
        'userId': user.uid,
        'userEmail': user.email,
        'bookingId': bookingId,
        'paymentMethod': 'upi',
        'merchantUpiId': MERCHANT_UPI_ID,
        'amount': amount,
        'currency': 'INR',
        'status': 'completed',
        'transactionId': transactionId,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Save payment record to Firestore
      final docRef = await paymentsCollection.add(paymentData);

      return {
        'success': true,
        'paymentId': docRef.id,
        'message': 'Payment completed successfully',
        'amount': amount,
        'merchantUpiId': MERCHANT_UPI_ID,
        'transactionId': transactionId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error processing payment: ${e.toString()}',
      };
    }
  }

  /// Validate UPI amount against bank limits
  /// Returns validation result with detailed error message if amount exceeds limit
  Map<String, dynamic> validateUPIAmount(double amount) {
    // Check if amount exceeds default UPI limit
    if (amount > DEFAULT_UPI_LIMIT) {
      return {
        'isValid': false,
        'errorType': 'AMOUNT_EXCEEDS_LIMIT',
        'message': 'Payment amount ₹$amount exceeds maximum UPI limit of ₹$DEFAULT_UPI_LIMIT.\n\n'
            'Solutions:\n'
            '1. Contact your bank to increase your UPI limit\n'
            '2. Split payment into multiple transactions\n'
            '3. Use an alternative payment method (PayPal/Credit Card)',
        'maxLimit': DEFAULT_UPI_LIMIT,
        'recommendedAmount': RECOMMENDED_RETRY_AMOUNT,
      };
    }
    
    // Warn if amount is close to limit (above 80% of limit)
    if (amount > DEFAULT_UPI_LIMIT * 0.8) {
      return {
        'isValid': true,
        'isWarning': true,
        'warning': 'Payment amount ₹$amount is close to your UPI transaction limit.\n'
            'If payment fails, try a smaller amount or use alternative payment method.',
        'maxLimit': DEFAULT_UPI_LIMIT,
      };
    }
    
    return {
      'isValid': true,
      'isWarning': false,
    };
  }

  /// Initiate actual UPI transaction using url_launcher with UPI deep links
  /// Now includes amount validation and better error reporting
  Future<Map<String, dynamic>> initiateUpiPayment({
    required String amount,
    String? userUpiId,
  }) async {
    try {
      final amountDouble = double.parse(amount);
      
      // Validate amount against UPI limits
      final validation = validateUPIAmount(amountDouble);
      if (!validation['isValid']) {
        return {
          'success': false,
          'errorType': validation['errorType'],
          'message': validation['message'],
          'maxLimit': validation['maxLimit'],
        };
      }

      // Build UPI URL with validated amount
      final txnRef = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
      final upiUrl = Uri.parse(
        'upi://pay?pa=$MERCHANT_UPI_ID'
        '&pn=HomecareCRM'
        '&mc=5960'
        '&am=$amount'
        '&cu=INR'
        '&tn=ServicePayment'
        '&tr=$txnRef',
      );

      // Launch UPI app directly
      try {
        final launched = await launchUrl(
          upiUrl,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          return {
            'success': false,
            'errorType': 'NO_UPI_APP',
            'message': 'No UPI app found on your device.\n\n'
                'Please install:\n'
                '• Google Pay\n'
                '• PhonePe\n'
                '• BHIM\n'
                '• Amazon Pay\n'
                '• Your bank\'s UPI app',
          };
        }

        // Return warning if amount was close to limit
        if (validation['isWarning'] == true) {
          return {
            'success': true,
            'warning': validation['warning'],
            'transactionRef': txnRef,
          };
        }

        return {
          'success': true,
          'transactionRef': txnRef,
        };
      } catch (launchError) {
        print('Launch error: $launchError');
        return {
          'success': false,
          'errorType': 'LAUNCH_FAILED',
          'message': 'Failed to launch UPI app: ${launchError.toString()}\n\n'
              'Try installing a UPI payment app (Google Pay, PhonePe, etc.)',
        };
      }
    } catch (e) {
      print('UPI Error: $e');
      return {
        'success': false,
        'errorType': 'UNKNOWN_ERROR',
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Process PayPal Payment
  Future<Map<String, dynamic>> processPayPalPayment({
    required String cardHolderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
    required String bookingId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Validate card details
      if (!_isValidCardNumber(cardNumber)) {
        throw Exception('Invalid card number');
      }

      if (!_isValidExpiry(expiryDate)) {
        throw Exception('Invalid expiry date');
      }

      if (!_isValidCVV(cvv)) {
        throw Exception('Invalid CVV');
      }

      // Create payment record
      final paymentData = {
        'userId': user.uid,
        'userEmail': user.email,
        'bookingId': bookingId,
        'paymentMethod': 'paypal',
        'cardHolderName': cardHolderName,
        'cardNumber': _maskCardNumber(cardNumber),
        'expiryDate': expiryDate,
        'cvv': _maskCVV(cvv),
        'amount': amount,
        'currency': 'USD',
        'status': 'completed',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Save payment record to Firestore
      final docRef = await paymentsCollection.add(paymentData);

      return {
        'success': true,
        'paymentId': docRef.id,
        'message': 'Payment completed successfully',
        'amount': amount,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error processing payment: ${e.toString()}',
      };
    }
  }

  /// Process Cash on Delivery
  Future<Map<String, dynamic>> processCashPayment({
    required double amount,
    required String bookingId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create payment record for cash
      final paymentData = {
        'userId': user.uid,
        'userEmail': user.email,
        'bookingId': bookingId,
        'paymentMethod': 'cash',
        'amount': amount,
        'currency': 'INR',
        'status': 'completed',
        'paymentType': 'cash_on_delivery',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Save payment record to Firestore
      final docRef = await paymentsCollection.add(paymentData);

      return {
        'success': true,
        'paymentId': docRef.id,
        'message': 'Payment completed successfully',
        'amount': amount,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error processing payment: ${e.toString()}',
      };
    }
  }

  /// Update payment status
  Future<void> updatePaymentStatus(
    String paymentId,
    String newStatus,
  ) async {
    try {
      await paymentsCollection.doc(paymentId).update({
        'status': newStatus,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating payment status: $e');
      rethrow;
    }
  }

  /// Get payment by ID
  Future<Map<String, dynamic>?> getPaymentById(String paymentId) async {
    try {
      final doc = await paymentsCollection.doc(paymentId).get();
      if (!doc.exists) {
        return null;
      }

      return {
        'paymentId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    } catch (e) {
      print('Error fetching payment: $e');
      rethrow;
    }
  }

  /// Get all payments for current user
  Future<List<Map<String, dynamic>>> getUserPayments() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query = await paymentsCollection
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => {
            'paymentId': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
          .toList();
    } catch (e) {
      print('Error fetching user payments: $e');
      rethrow;
    }
  }

  // Validation Methods
  bool _isValidCardNumber(String cardNumber) {
    final cleanedNumber = cardNumber.replaceAll(' ', '');
    return cleanedNumber.length >= 13 && cleanedNumber.length <= 19;
  }

  bool _isValidExpiry(String expiry) {
    final regex = RegExp(r'^(0[1-9]|1[0-2])\d{2}$');
    if (!regex.hasMatch(expiry)) {
      return false;
    }

    final month = int.parse(expiry.substring(0, 2));
    final year = int.parse(expiry.substring(2));
    final now = DateTime.now();

    if (year < now.year % 100) {
      return false;
    }

    if (year == now.year % 100 && month < now.month) {
      return false;
    }

    return true;
  }

  bool _isValidCVV(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4;
  }

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return '****';
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  String _maskCVV(String cvv) {
    return '***';
  }

  /// Generate UPI Deep Link for payment
  String generateUPIDeepLink({
    required String userUpiId,
    required double amount,
    required String transactionId,
  }) {
    final upiUrl =
        'upi://pay?pa=$MERCHANT_UPI_ID&pn=HomecareCRM&amount=$amount&tn=Payment%20for%20booking%20$transactionId&tr=$transactionId';
    return upiUrl;
  }

  /// Create booking payment record linking booking with payment details
  /// This method creates a new collection entry that matches bookingId with payment details
  Future<void> createBookingPayment({
    required String bookingId,
    required String paymentMethod,
    required double amount,
    String? userUpiId,
    String? cardLast4,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final bookingPaymentData = {
        'bookingId': bookingId,
        'userId': user.uid,
        'paymentMethod': paymentMethod,
        'amount': amount,
        'currency': _getCurrencyForPaymentMethod(paymentMethod),
        'status': 'completed',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Add payment method specific details
      if (paymentMethod == 'upi' && userUpiId != null) {
        bookingPaymentData['paymentDetails'] = {
          'method': 'upi',
          'userUpiId': userUpiId,
          'merchantUpiId': MERCHANT_UPI_ID,
        };
      } else if (paymentMethod == 'paypal' && cardLast4 != null) {
        bookingPaymentData['paymentDetails'] = {
          'method': 'paypal',
          'cardLast4': cardLast4,
        };
      } else if (paymentMethod == 'cash') {
        bookingPaymentData['paymentDetails'] = {
          'method': 'cash_on_delivery',
        };
      }

      // Store in booking_payments collection
      await bookingPaymentsCollection.doc(bookingId).set(bookingPaymentData);

      print('✅ Booking payment record created for booking: $bookingId');
    } catch (e) {
      print('Error creating booking payment record: $e');
      rethrow;
    }
  }

  /// Get booking payment details by booking ID
  Future<Map<String, dynamic>?> getBookingPayment(String bookingId) async {
    try {
      final doc = await bookingPaymentsCollection.doc(bookingId).get();
      if (!doc.exists) {
        return null;
      }

      return {
        'bookingId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    } catch (e) {
      print('Error fetching booking payment: $e');
      rethrow;
    }
  }

  /// Get all booking payments for current user
  Future<List<Map<String, dynamic>>> getUserBookingPayments() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query = await bookingPaymentsCollection
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => {
            'bookingId': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
          .toList();
    } catch (e) {
      print('Error fetching user booking payments: $e');
      rethrow;
    }
  }

  /// Update booking payment status
  Future<void> updateBookingPaymentStatus(
    String bookingId,
    String newStatus,
  ) async {
    try {
      await bookingPaymentsCollection.doc(bookingId).update({
        'status': newStatus,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating booking payment status: $e');
      rethrow;
    }
  }

  /// Helper method to get currency based on payment method
  String _getCurrencyForPaymentMethod(String paymentMethod) {
    if (paymentMethod == 'upi' || paymentMethod == 'cash') {
      return 'INR';
    } else if (paymentMethod == 'paypal') {
      return 'USD';
    }
    return 'INR';
  }
}

