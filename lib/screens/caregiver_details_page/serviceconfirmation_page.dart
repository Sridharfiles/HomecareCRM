import 'package:flutter/material.dart';
import '../Menu/mybookings_page/tracking_page.dart';
import '../home_page/service_card.dart';

class ServiceConfirmationScreen extends StatelessWidget {
  final ServiceModel service;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int selectedHours;

  const ServiceConfirmationScreen({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedHours,
  });

  @override
  Widget build(BuildContext context) {
    print('ServiceConfirmationScreen build method called');
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
      body: Column(
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
                          // Service Details Section
                          _buildSectionTitle('Service Details'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Service ID:', '#CGR123456'),
                          _buildDetailRow(
                            'Caregiver Name:',
                            'John Doe (Certified Nurse)',
                          ),
                          _buildDetailRow(
                            'Appointment Date & Time:',
                            '${_formatDate(selectedDate)} - ${_formatTime(selectedTime)}',
                          ),
                          _buildDetailRow('Service Type:', service.title),
                          _buildDetailRow(
                            'Duration:',
                            '$selectedHours hour${selectedHours > 1 ? 's' : ''}',
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
                              'Paid via Insurance (BlueCross)',
                              style: TextStyle(
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
                          _buildCostRow('Service Fee', service.price),
                          _buildCostRow('Additional Charges', '\$15'),

                          Container(
                            height: 1,
                            color: const Color(0xFFE0E0E0),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                          ),

                          _buildTotalRow(
                            'Total',
                            '\$${(double.parse(service.price.replaceAll('\$', '').replaceAll('/hr', '').trim()) + 15).toStringAsFixed(0)}',
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
                                    builder:
                                        (context) => TrackingScreen(
                                          serviceId: '#CGR123456',
                                          caregiverName:
                                              'John Doe (Certified Nurse)',
                                          serviceType: service.title,
                                          appointmentDateTime:
                                              '${_formatDate(selectedDate)} - ${_formatTime(selectedTime)}',
                                          paymentMethod:
                                              'Paid via Insurance (BlueCross)',
                                          totalAmount:
                                              '\$${(double.parse(service.price.replaceAll('\$', '').replaceAll('/hr', '').trim()) + 15).toStringAsFixed(0)}',
                                        ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
