import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int unreadCount = 2;
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      icon: Icons.check_circle,
      iconColor: Colors.green,
      iconBgColor: const Color(0xFFB8E6C3),
      title: 'Order Confirmed',
      message: 'Your order #12345 has been confirmed.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      id: '2',
      icon: Icons.local_shipping,
      iconColor: Colors.blue,
      iconBgColor: const Color(0xFFB3D9FF),
      title: 'Order Shipped',
      message: 'Your order #12345 has been shipped.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      id: '3',
      icon: Icons.delivery_dining,
      iconColor: Colors.orange,
      iconBgColor: const Color(0xFFFFD9A3),
      title: 'Out for Delivery',
      message: 'Your order #12345 is out for delivery.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: '4',
      icon: Icons.home,
      iconColor: Colors.purple,
      iconBgColor: const Color(0xFFE0C6F5),
      title: 'Order Delivered',
      message: 'Your order #12345 has been delivered.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationItem(
      id: '5',
      icon: Icons.cancel,
      iconColor: Colors.red,
      iconBgColor: const Color(0xFFFFB3B3),
      title: 'Order Cancelled',
      message: 'Your order #12345 has been cancelled.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    NotificationItem(
      id: '6',
      icon: Icons.credit_card,
      iconColor: Colors.teal,
      iconBgColor: const Color(0xFFB3E5E0),
      title: 'Payment Received',
      message: 'Your payment for order #12345 has been received.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationItem(
      id: '7',
      icon: Icons.refresh,
      iconColor: Colors.orange,
      iconBgColor: const Color(0xFFFFE8B3),
      title: 'Order Update',
      message: 'Your order #12345 has been updated.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    NotificationItem(
      id: '8',
      icon: Icons.support_agent,
      iconColor: Colors.brown,
      iconBgColor: const Color(0xFFD9C4B0),
      title: 'Customer Support',
      message: 'Customer support has responded to your query.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
    ),
    NotificationItem(
      id: '9',
      icon: Icons.notifications,
      iconColor: Colors.blue,
      iconBgColor: const Color(0xFFC6D9F5),
      title: 'New Promotion',
      message: 'Check out our new promotion on fresh produce!',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    NotificationItem(
      id: '10',
      icon: Icons.star,
      iconColor: Colors.orange,
      iconBgColor: const Color(0xFFFFE8B3),
      title: 'Rate Us',
      message: 'Please rate your recent purchase experience.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 9)),
    ),
    NotificationItem(
      id: '11',
      icon: Icons.shopping_cart,
      iconColor: Colors.green,
      iconBgColor: const Color(0xFFC6F5D9),
      title: 'Cart Reminder',
      message: 'You have items in your cart. Don\'t forget to checkout!',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    NotificationItem(
      id: '12',
      icon: Icons.new_releases,
      iconColor: Colors.blue,
      iconBgColor: const Color(0xFFB3D9FF),
      title: 'New Arrivals',
      message: 'Check out the new arrivals in our store.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 11)),
    ),
    NotificationItem(
      id: '13',
      icon: Icons.error,
      iconColor: Colors.red,
      iconBgColor: const Color(0xFFFFB3B3),
      title: 'Payment Failed',
      message: 'Your payment for order #12345 failed. Please try again.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    NotificationItem(
      id: '14',
      icon: Icons.card_giftcard,
      iconColor: Colors.purple,
      iconBgColor: const Color(0xFFE0C6F5),
      title: 'Gift Card Added',
      message: 'A new gift card has been added to your account.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 13)),
    ),
    NotificationItem(
      id: '15',
      icon: Icons.store,
      iconColor: Colors.orange,
      iconBgColor: const Color(0xFFFFD9A3),
      title: 'Store Update',
      message: 'Our store timings have been updated.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 14)),
    ),
    NotificationItem(
      id: '16',
      icon: Icons.feedback,
      iconColor: Colors.teal,
      iconBgColor: const Color(0xFFB3E5E0),
      title: 'Feedback Request',
      message: 'We would love to hear your feedback on our service.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 15)),
    ),
    NotificationItem(
      id: '17',
      icon: Icons.local_offer,
      iconColor: Colors.yellow,
      iconBgColor: const Color(0xFFFFF9B3),
      title: 'Special Offer',
      message: 'Don\'t miss our special offer on organic produce!',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 16)),
    ),
    NotificationItem(
      id: '18',
      icon: Icons.warning,
      iconColor: Colors.brown,
      iconBgColor: const Color(0xFFD9C4B0),
      title: 'Stock Alert',
      message: 'An item in your wishlist is back in stock.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 17)),
    ),
    NotificationItem(
      id: '19',
      icon: Icons.verified,
      iconColor: Colors.blue,
      iconBgColor: const Color(0xFFC6D9F5),
      title: 'Account Verified',
      message: 'Your account has been successfully verified.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    NotificationItem(
      id: '20',
      icon: Icons.schedule,
      iconColor: Colors.orange,
      iconBgColor: const Color(0xFFFFE8B3),
      title: 'Delivery Rescheduled',
      message: 'Your delivery for order #12345 has been rescheduled.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 19)),
    ),
  ];

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
      unreadCount = 0;
    });
  }

  void toggleReadStatus(String id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n.id == id);
      notification.isRead = !notification.isRead;
      unreadCount = notifications.where((n) => !n.isRead).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.orange),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unreadCount New',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: markAllAsRead,
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => toggleReadStatus(notification.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notification.iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: notification.isRead ? Colors.transparent : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  bool isRead;
  final DateTime timestamp;

  NotificationItem({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.timestamp,
  });
}