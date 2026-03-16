import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/Menu/mybookings_page/tracking_page.dart';
import 'package:homecarecrm/services/bookings_services.dart';

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

  List<Map<String, dynamic>> activeBookings = [];
  List<Map<String, dynamic>> completedBookings = [];
  List<Map<String, dynamic>> cancelledBookings = [];
  bool isLoading = true;
  final BookingService _bookingService = BookingService();

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

    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      print('🔄 Loading bookings...');
      setState(() {
        isLoading = true;
      });

      final allBookings = await _bookingService.getUserBookings();
      print('📊 Total bookings found: ${allBookings.length}');

      // Filter out test bookings and print each booking for debugging
      final realBookings =
          allBookings.where((booking) {
            final serviceTitle =
                (booking['serviceTitle'] ?? booking['title'] ?? '')
                    .toString()
                    .toLowerCase();
            final isTestBooking = serviceTitle.contains('test');
            if (!isTestBooking) {
              print(
                '📋 Real Booking: ${booking['serviceTitle']} - Status: ${booking['bookingStatus']}',
              );
            } else {
              print(
                '🧪 Test Booking (filtered): ${booking['serviceTitle']} - Status: ${booking['bookingStatus']}',
              );
            }
            return !isTestBooking;
          }).toList();

      // Filter bookings by status (client-side filtering to avoid index issues)
      final active =
          realBookings
              .where(
                (booking) =>
                    booking['bookingStatus'] == 'pending' ||
                    booking['bookingStatus'] == 'confirmed',
              )
              .toList();
      final completed =
          realBookings
              .where((booking) => booking['bookingStatus'] == 'completed')
              .toList();
      final cancelled =
          realBookings
              .where((booking) => booking['bookingStatus'] == 'cancelled')
              .toList();

      print('✅ Active bookings: ${active.length}');
      print('✅ Completed bookings: ${completed.length}');
      print('❌ Cancelled bookings: ${cancelled.length}');

      setState(() {
        activeBookings = active;
        completedBookings = completed;
        cancelledBookings = cancelled;
        isLoading = false;
      });

      // Start animations after data is loaded
      _startAnimations();
    } catch (e) {
      print('❌ Error loading bookings: $e');

      // If it's an index error, try to load without ordering
      if (e.toString().contains('requires an index')) {
        print('🔄 Trying to load bookings without ordering...');
        try {
          final user = _bookingService.currentUser;
          if (user == null) {
            throw Exception('User not authenticated');
          }

          final query =
              await _bookingService.bookingsCollection
                  .where('userId', isEqualTo: user.uid)
                  .get();

          final allBookings =
              query.docs
                  .map(
                    (doc) => {
                      'bookingId': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    },
                  )
                  .toList();

          final active =
              allBookings
                  .where(
                    (booking) =>
                        booking['bookingStatus'] == 'pending' ||
                        booking['bookingStatus'] == 'confirmed',
                  )
                  .toList();
          final completed =
              allBookings
                  .where((booking) => booking['bookingStatus'] == 'completed')
                  .toList();
          final cancelled =
              allBookings
                  .where((booking) => booking['bookingStatus'] == 'cancelled')
                  .toList();

          setState(() {
            activeBookings = active;
            completedBookings = completed;
            cancelledBookings = cancelled;
            isLoading = false;
          });

          _startAnimations();
        } catch (fallbackError) {
          print('❌ Fallback also failed: $fallbackError');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
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
        actions: [],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A84FF)),
                ),
              )
              : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Active Bookings Section - slides in from left to right
                    if (activeBookings.isNotEmpty)
                      _buildAnimatedBookingSection(
                        title: 'Active Bookings',
                        bookings: activeBookings,
                        isActive: true,
                        controller: _activeBookingsController,
                        slideFromLeft: true,
                      ),

                    // Completed Bookings Section - slides in from right to left
                    if (completedBookings.isNotEmpty)
                      _buildAnimatedBookingSection(
                        title: 'Completed Bookings',
                        bookings: completedBookings,
                        isActive: false,
                        controller: _completedBookingsController,
                        slideFromLeft: false,
                      ),

                    // Cancelled Bookings Section - slides in from left to right
                    if (cancelledBookings.isNotEmpty)
                      _buildAnimatedBookingSection(
                        title: 'Cancelled Bookings',
                        bookings: cancelledBookings,
                        isActive: false,
                        isCancelled: true,
                        controller: _cancelledBookingsController,
                        slideFromLeft: true,
                      ),

                    // Empty state if no bookings
                    if (activeBookings.isEmpty &&
                        completedBookings.isEmpty &&
                        cancelledBookings.isEmpty)
                      _buildEmptyState(),

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Vertical Bookings List - No height constraints
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildBookingCard(
                  context: context,
                  booking: booking,
                  isActive: isActive,
                  isCancelled: isCancelled,
                ),
              );
            },
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
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    booking['serviceTitle'] ?? booking['title'] ?? 'Service',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCancelled
                            ? Colors.grey[100]
                            : isActive
                            ? Colors.green[50]
                            : Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking['bookingStatus'] ?? booking['status'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          isCancelled
                              ? Colors.grey[600]
                              : isActive
                              ? Colors.green[700]
                              : Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date & Time
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${booking['selectedDate'] ?? booking['date'] ?? 'Date'}, ${booking['selectedTime'] ?? booking['time'] ?? 'Time'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isCancelled ? Colors.grey[400] : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Price
            Text(
              booking['servicePrice'] ?? booking['price'] ?? '\$0',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A84FF),
              ),
            ),

            const SizedBox(height: 12),

            // Buttons - Full width row
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      try {
                        final bookingId = booking['bookingId'] ?? '';
                        if (bookingId.isNotEmpty) {
                          await _bookingService.cancelBooking(bookingId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Booking cancelled'),
                              backgroundColor: Colors.grey,
                            ),
                          );
                          _loadBookings();
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error cancelling booking: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0A84FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF0A84FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Track Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TrackingScreen(
                                caregiverName:
                                    booking['userName'] ?? 'Caregiver',
                                serviceType:
                                    booking['serviceTitle'] ??
                                    booking['title'] ??
                                    'Service',
                                appointmentDateTime:
                                    '${booking['selectedDate'] ?? booking['date'] ?? 'Date'} at ${booking['selectedTime'] ?? booking['time'] ?? 'Time'}',
                                paymentMethod: 'Credit Card',
                                totalAmount:
                                    booking['servicePrice'] ??
                                    booking['price'] ??
                                    '\$0',
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A84FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Track',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booked services will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
            label: const Text('Browse Services'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A84FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
