import 'package:flutter/material.dart';
import '../Menu/mybookings_page/tracking_page.dart';
import '../home_page/service_card.dart';
import '../../services/bookings_services.dart';

class ServiceConfirmationScreen extends StatefulWidget {
  final ServiceModel service;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int selectedHours;
  final String paymentMethod;
  final double cost;
  final String paymentId;
  final String? cardHolderName;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? upiId;

  const ServiceConfirmationScreen({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedHours,
    required this.paymentMethod,
    required this.cost,
    required this.paymentId,
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.upiId,
  });

  @override
  State<ServiceConfirmationScreen> createState() =>
      _ServiceConfirmationScreenState();
}

class _ServiceConfirmationScreenState extends State<ServiceConfirmationScreen> {
  final BookingService _bookingService = BookingService();
  bool _isCreatingBooking = false;
  String? _bookingId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _createBooking();
  }

  Future<void> _createBooking() async {
    setState(() {
      _isCreatingBooking = true;
      _errorMessage = null;
    });

    try {
      final bookingId = await _bookingService.createBooking(
        service: widget.service,
        selectedDate: widget.selectedDate,
        selectedTime: widget.selectedTime,
        selectedHours: widget.selectedHours,
        paymentMethod: widget.paymentMethod,
        cost: widget.cost,
        paymentId: widget.paymentId,
        cardHolderName: widget.cardHolderName,
        cardNumber: widget.cardNumber,
        expiryDate: widget.expiryDate,
        cvv: widget.cvv,
        upiId: widget.upiId,
      );

      setState(() {
        _bookingId = bookingId;
        _isCreatingBooking = false;
      });

      print('Booking created successfully with ID: $bookingId');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create booking: ${e.toString()}';
        _isCreatingBooking = false;
      });

      print('Error creating booking: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Error creating booking'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Service Confirmation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isCreatingBooking
          ? const Center(
            child: CircularProgressIndicator(),
          )
          : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _errorMessage ?? 'An error occurred',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Original content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Booking Confirmation Header
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF4CAF50),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'Booking Confirmed',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF4CAF50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Service Details Section
                                  _buildSectionTitle('Service Details'),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                    'Appointment Date & Time:',
                                    '${_formatDate(widget.selectedDate)} - ${_formatTime(widget.selectedTime)}',
                                  ),
                                  _buildDetailRow(
                                    'Service Type:',
                                    widget.service.title,
                                  ),
                                  _buildDetailRow(
                                    'Duration:',
                                    '${widget.selectedHours} hour${widget.selectedHours > 1 ? 's' : ''}',
                                  ),

                                  const SizedBox(height: 24),

                                  // Payment Method Highlight
                                  _buildSectionTitle('Payment Method'),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Paid via ${_getPaymentMethodDisplay(widget.paymentMethod)}',
                                      style: const TextStyle(
                                        color: Color(0xFFFF9800),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Service Cost Breakdown
                                  _buildSectionTitle('Service Cost Breakdown:'),
                                  const SizedBox(height: 12),
                                  _buildCostRow('Service Fee', widget.service.price),

                                  Container(
                                    height: 1,
                                    color: const Color(0xFFE0E0E0),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),

                                  _buildTotalRow(
                                    'Total Cost',
                                    '${_getCurrencySymbol()}${widget.cost.toStringAsFixed(2)}',
                                  ),

                                  const SizedBox(height: 32),

                                  // Track My Service Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TrackingScreen(
                                                  caregiverName: 'Caregiver',
                                                  serviceType:
                                                      widget.service.title,
                                                  appointmentDateTime:
                                                      '${_formatDate(widget.selectedDate)} - ${_formatTime(widget.selectedTime)}',
                                                  paymentMethod:
                                                      _getPaymentMethodDisplay(
                                                        widget.paymentMethod,
                                                      ),
                                                  totalAmount:
                                                      '${_getCurrencySymbol()}${widget.cost.toStringAsFixed(2)}',
                                                ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1976D2),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Track My Service',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  String _getCurrencySymbol() {
    return widget.paymentMethod == 'upi' ? '₹' : '\$';
  }

  String _getPaymentMethodDisplay(String method) {
    switch (method) {
      case 'paypal':
        return 'PayPal';
      case 'cash':
        return 'Cash on Delivery';
      case 'upi':
        return 'UPI';
      default:
        return method;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF777777)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
