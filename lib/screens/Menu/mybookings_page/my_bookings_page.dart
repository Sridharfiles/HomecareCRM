import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/Menu/mybookings_page/tracking_page.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with TickerProviderStateMixin {
  late AnimationController _activeBookingsController;
  late AnimationController _completedBookingsController;
  late AnimationController _cancelledBookingsController;

  @override
  void initState() {
    super.initState();

    _activeBookingsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _completedBookingsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cancelledBookingsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start animations with staggered timing
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _activeBookingsController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _completedBookingsController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _cancelledBookingsController.forward();
  }

  @override
  void dispose() {
    _activeBookingsController.dispose();
    _completedBookingsController.dispose();
    _cancelledBookingsController.dispose();
    super.dispose();
  }

  // Sample booking data - using services from home page
  final List<Map<String, dynamic>> activeBookings = const [
    {
      'image': 'assets/images/image1.jpg',
      'title': 'Professional Home Care Service',
      'date': 'May 23',
      'time': '4:30 PM',
      'status': 'Active',
      'price': '\$20/hr',
    },
    {
      'image': 'assets/images/image2.jpg',
      'title': 'Companion Care',
      'date': 'May 24',
      'time': '10:00 AM',
      'status': 'Active',
      'price': '\$25/hr',
    },
    {
      'image': 'assets/images/image3.jpg',
      'title': 'Family Caregiver Support',
      'date': 'May 25',
      'time': '2:00 PM',
      'status': 'Active',
      'price': '\$18.50/hr',
    },
    {
      'image': 'assets/images/image4.jpg',
      'title': 'Geriatric Caregiver',
      'date': 'May 26',
      'time': '9:00 AM',
      'status': 'Active',
      'price': '\$22/hr',
    },
    {
      'image': 'assets/images/image5.jpg',
      'title': 'Home Health Aide',
      'date': 'May 27',
      'time': '11:30 AM',
      'status': 'Active',
      'price': '\$24/hr',
    },
  ];

  final List<Map<String, dynamic>> completedBookings = const [
    {
      'image': 'assets/images/image6.jpg',
      'title': 'Respite Care',
      'date': 'May 20',
      'time': '3:00 PM',
      'status': 'Completed',
      'price': '\$21/hr',
    },
    {
      'image': 'assets/images/image1.jpg',
      'title': 'Professional Home Care Service',
      'date': 'May 19',
      'time': '11:00 AM',
      'status': 'Completed',
      'price': '\$20/hr',
    },
    {
      'image': 'assets/images/image2.jpg',
      'title': 'Companion Care',
      'date': 'May 18',
      'time': '1:00 PM',
      'status': 'Completed',
      'price': '\$25/hr',
    },
    {
      'image': 'assets/images/image3.jpg',
      'title': 'Family Caregiver Support',
      'date': 'May 17',
      'time': '2:30 PM',
      'status': 'Completed',
      'price': '\$18.50/hr',
    },
    {
      'image': 'assets/images/image4.jpg',
      'title': 'Geriatric Caregiver',
      'date': 'May 16',
      'time': '4:00 PM',
      'status': 'Completed',
      'price': '\$22/hr',
    },
  ];

  final List<Map<String, dynamic>> cancelledBookings = const [
    {
      'image': 'assets/images/image5.jpg',
      'title': 'Home Health Aide',
      'date': 'May 15',
      'time': '9:00 AM',
      'status': 'Cancelled',
      'price': '\$24/hr',
    },
    {
      'image': 'assets/images/image6.jpg',
      'title': 'Respite Care',
      'date': 'May 14',
      'time': '4:00 PM',
      'status': 'Cancelled',
      'price': '\$21/hr',
    },
    {
      'image': 'assets/images/image1.jpg',
      'title': 'Professional Home Care Service',
      'date': 'May 13',
      'time': '10:30 AM',
      'status': 'Cancelled',
      'price': '\$20/hr',
    },
    {
      'image': 'assets/images/image2.jpg',
      'title': 'Companion Care',
      'date': 'May 12',
      'time': '3:30 PM',
      'status': 'Cancelled',
      'price': '\$25/hr',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A84FF),
        elevation: 4,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0A84FF),
              size: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Active Bookings Section - slides in from left to right
            _buildAnimatedBookingSection(
              title: 'Active Bookings',
              bookings: activeBookings,
              isActive: true,
              controller: _activeBookingsController,
              slideFromLeft: true,
            ),

            // Completed Bookings Section - slides in from right to left
            _buildAnimatedBookingSection(
              title: 'Completed Bookings',
              bookings: completedBookings,
              isActive: false,
              controller: _completedBookingsController,
              slideFromLeft: false,
            ),

            // Cancelled Bookings Section - slides in from left to right
            _buildAnimatedBookingSection(
              title: 'Cancelled Bookings',
              bookings: cancelledBookings,
              isActive: false,
              isCancelled: true,
              controller: _cancelledBookingsController,
              slideFromLeft: true,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBookingSection({
    required String title,
    required List<Map<String, dynamic>> bookings,
    required bool isActive,
    bool isCancelled = false,
    required AnimationController controller,
    required bool slideFromLeft,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(slideFromLeft ? -1.0 : 1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
          child: FadeTransition(
            opacity: controller,
            child: _buildBookingSection(
              title: title,
              bookings: bookings,
              isActive: isActive,
              isCancelled: isCancelled,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingSection({
    required String title,
    required List<Map<String, dynamic>> bookings,
    required bool isActive,
    bool isCancelled = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle see all functionality
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFFFF9800),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Scrollable Cards
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingCard(
                  context: context,
                  booking: booking,
                  isActive: isActive,
                  isCancelled: isCancelled,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required BuildContext context,
    required Map<String, dynamic> booking,
    required bool isActive,
    bool isCancelled = false,
  }) {
    return Container(
      width: 290,
      height: 155,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Image
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                booking['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.image, size: 24, color: Colors.grey[400]),
                  );
                },
              ),
            ),
          ),

          // Right side - Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    booking['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Date & Time
                  Text(
                    '${booking['date']}, ${booking['time']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isCancelled ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 1),

                  // Status
                  Text(
                    booking['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color:
                          isCancelled
                              ? Colors.grey[400]
                              : isActive
                              ? Colors.green
                              : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 1),

                  // Price
                  Text(
                    booking['price'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0A84FF),
                    ),
                  ),

                  const Spacer(),

                  // Buttons - Show for all booking types
                  Row(
                    children: [
                      // Cancel Button
                      SizedBox(
                        width: 90,
                        height: 28,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Booking cancelled'),
                                backgroundColor: Colors.grey,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0A84FF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF0A84FF),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Track Button
                      SizedBox(
                        width: 90,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TrackingScreen(
                                      caregiverName: 'John Doe',
                                      serviceType: booking['title'],
                                      appointmentDateTime:
                                          '${booking['date']} at ${booking['time']}',
                                      paymentMethod: 'Credit Card',
                                      totalAmount: booking['price'],
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A84FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          child: const Text(
                            'Track',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
