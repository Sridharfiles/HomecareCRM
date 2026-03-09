import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  final String caregiverName;
  final String serviceType;
  final String appointmentDateTime;
  final String paymentMethod;
  final String totalAmount;

  const TrackingScreen({
    super.key,
    required this.caregiverName,
    required this.serviceType,
    required this.appointmentDateTime,
    required this.paymentMethod,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text(
          'Track Caregiver Service',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingDetailsCard(
              caregiverName: caregiverName,
              serviceType: serviceType,
              appointmentDateTime: appointmentDateTime,
              paymentMethod: paymentMethod,
              totalAmount: totalAmount,
            ),
            SizedBox(height: 24),
            Text(
              'Service Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16),
            TrackingStatusList(),
            SizedBox(height: 24),
            HelpButton(),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsCard extends StatelessWidget {
  final String caregiverName;
  final String serviceType;
  final String appointmentDateTime;
  final String paymentMethod;
  final String totalAmount;

  const BookingDetailsCard({
    super.key,
    required this.caregiverName,
    required this.serviceType,
    required this.appointmentDateTime,
    required this.paymentMethod,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            DetailRow(label: 'Service Type', value: serviceType),
            DetailRow(label: 'Appointment', value: appointmentDateTime),
            DetailRow(label: 'Caregiver', value: caregiverName),
            DetailRow(label: 'Payment Method', value: paymentMethod),
            DetailRow(label: 'Total Amount', value: totalAmount, isBold: true),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF666666),
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF333333),
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingStatusList extends StatelessWidget {
  const TrackingStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TrackingStatusCard(
          title: 'Appointment Confirmed',
          time: '12/09/22 9:30 AM',
          icon: Icons.calendar_today,
          status: 'completed',
        ),
        const SizedBox(height: 16),
        TrackingStatusCard(
          title: 'Caregiver Assigned',
          time: '12/09/22 10:00 AM',
          icon: Icons.person,
          status: 'completed',
        ),
        const SizedBox(height: 16),
        TrackingStatusCard(
          title: 'Caregiver En Route',
          time: '12/09/22 10:15 AM',
          icon: Icons.directions_walk,
          status: 'current',
        ),
        const SizedBox(height: 16),
        TrackingStatusCard(
          title: 'Caregiving in Progress',
          time: '12/09/22 10:30 AM',
          icon: Icons.favorite,
          status: 'upcoming',
        ),
      ],
    );
  }
}

class TrackingStatusCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final String status; // 'completed', 'current', 'upcoming'

  const TrackingStatusCard({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = status == 'completed' || status == 'current';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1976D2) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF9E9E9E),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isActive
                            ? Colors.white.withOpacity(0.8)
                            : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          if (status == 'current')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle help button press
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Help request sent! We\'ll contact you soon.'),
              backgroundColor: Color(0xFF1E88E5),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Need Help?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
