import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  orderConfirmed,
  orderCancelled,
  reviewPosted,
  serviceAddedToFavorites,
  bookingConfirmed,
  bookingCancelled,
  paymentReceived,
  serviceCompleted,
}

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reference to notifications collection
  CollectionReference get notificationsCollection =>
      _firestore.collection('notifications');

  // Public getter for current user
  User? get currentUser => _auth.currentUser;

  /// Create a new notification
  Future<String> createNotification({
    required NotificationType type,
    required String title,
    required String message,
    String? relatedId, // Booking ID, Service ID, etc.
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final notificationData = {
        'userId': user.uid,
        'type': type.name,
        'title': title,
        'message': message,
        'relatedId': relatedId,
        'extraData': extraData ?? {},
        'isRead': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final docRef = await notificationsCollection.add(notificationData);
      print('🔔 Notification created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating notification: $e');
      rethrow;
    }
  }

  /// Get all notifications for current user
  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query =
          await notificationsCollection
              .where('userId', isEqualTo: user.uid)
              .orderBy('createdAt', descending: true)
              .get();

      final notifications =
          query.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();

      print('📊 Total notifications found: ${notifications.length}');
      return notifications;
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      // If it's an index error, try without ordering
      if (e.toString().contains('requires an index')) {
        print('🔄 Trying to fetch notifications without ordering...');
        final fallbackUser = _auth.currentUser;
        if (fallbackUser != null) {
          final query =
              await notificationsCollection
                  .where('userId', isEqualTo: fallbackUser.uid)
                  .get();

          return query.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();
        }
      }
      rethrow;
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await notificationsCollection.doc(notificationId).update({
        'isRead': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      print('📖 Notification marked as read: $notificationId');
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      rethrow;
    }
  }

  /// Mark all notifications as read for current user
  Future<void> markAllAsRead() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query =
          await notificationsCollection
              .where('userId', isEqualTo: user.uid)
              .where('isRead', isEqualTo: false)
              .get();

      final batch = _firestore.batch();
      for (var doc in query.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      await batch.commit();
      print('📖 All notifications marked as read');
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      rethrow;
    }
  }

  /// Get unread count for current user
  Future<int> getUnreadCount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query =
          await notificationsCollection
              .where('userId', isEqualTo: user.uid)
              .where('isRead', isEqualTo: false)
              .get();

      return query.docs.length;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await notificationsCollection.doc(notificationId).delete();
      print('🗑️ Notification deleted: $notificationId');
    } catch (e) {
      print('❌ Error deleting notification: $e');
      rethrow;
    }
  }

  /// Clear all notifications for current user
  Future<void> clearAllNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final query =
          await notificationsCollection
              .where('userId', isEqualTo: user.uid)
              .get();

      final batch = _firestore.batch();
      for (var doc in query.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('🗑️ All notifications cleared');
    } catch (e) {
      print('❌ Error clearing all notifications: $e');
      rethrow;
    }
  }

  /// Helper method to create booking-related notifications
  Future<void> createBookingNotification({
    required NotificationType type,
    required String bookingId,
    required String serviceTitle,
    required String userName,
  }) async {
    String title;
    String message;

    switch (type) {
      case NotificationType.bookingConfirmed:
        title = 'Booking Confirmed';
        message = 'Your booking for "$serviceTitle" has been confirmed.';
        break;
      case NotificationType.bookingCancelled:
        title = 'Booking Cancelled';
        message = 'Your booking for "$serviceTitle" has been cancelled.';
        break;
      case NotificationType.serviceCompleted:
        title = 'Service Completed';
        message =
            'Your service "$serviceTitle" has been completed successfully.';
        break;
      case NotificationType.paymentReceived:
        title = 'Payment Received';
        message = 'Payment for your booking "$serviceTitle" has been received.';
        break;
      default:
        title = 'Booking Update';
        message = 'Your booking "$serviceTitle" has been updated.';
        break;
    }

    await createNotification(
      type: type,
      title: title,
      message: message,
      relatedId: bookingId,
      extraData: {'serviceTitle': serviceTitle, 'userName': userName},
    );
  }

  /// Helper method to create service-related notifications
  Future<void> createServiceNotification({
    required NotificationType type,
    required String serviceId,
    required String serviceTitle,
  }) async {
    String title;
    String message;

    switch (type) {
      case NotificationType.serviceAddedToFavorites:
        title = 'Added to Favorites';
        message = '"$serviceTitle" has been added to your favorites.';
        break;
      case NotificationType.reviewPosted:
        title = 'Review Posted';
        message =
            'Your review for "$serviceTitle" has been posted successfully.';
        break;
      default:
        title = 'Service Update';
        message = 'There is an update regarding "$serviceTitle".';
        break;
    }

    await createNotification(
      type: type,
      title: title,
      message: message,
      relatedId: serviceId,
      extraData: {'serviceTitle': serviceTitle},
    );
  }

  /// Get notification icon and colors based on type
  static Map<String, dynamic> getNotificationStyle(NotificationType type) {
    switch (type) {
      case NotificationType.orderConfirmed:
      case NotificationType.bookingConfirmed:
        return {
          'icon': Icons.check_circle,
          'iconColor': Colors.green,
          'iconBgColor': const Color(0xFFB8E6C3),
        };
      case NotificationType.orderCancelled:
      case NotificationType.bookingCancelled:
        return {
          'icon': Icons.cancel,
          'iconColor': Colors.red,
          'iconBgColor': const Color(0xFFFFB3B3),
        };
      case NotificationType.reviewPosted:
        return {
          'icon': Icons.star,
          'iconColor': Colors.orange,
          'iconBgColor': const Color(0xFFFFE8B3),
        };
      case NotificationType.serviceAddedToFavorites:
        return {
          'icon': Icons.favorite,
          'iconColor': Colors.pink,
          'iconBgColor': const Color(0xFFFFD9E6),
        };
      case NotificationType.paymentReceived:
        return {
          'icon': Icons.credit_card,
          'iconColor': Colors.teal,
          'iconBgColor': const Color(0xFFB3E5E0),
        };
      case NotificationType.serviceCompleted:
        return {
          'icon': Icons.task_alt,
          'iconColor': Colors.blue,
          'iconBgColor': const Color(0xFFB3D9FF),
        };
    }
  }
}
