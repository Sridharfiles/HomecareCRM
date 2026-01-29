import 'package:flutter/material.dart';

class ServiceConfirmationScreen extends StatelessWidget {
  const ServiceConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
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
                  'Tuesday, March 25, 2025 - 10:00 AM',
                ),
                _buildDetailRow('Service Type:', 'In-Home Elderly Care'),

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
                      color: Color(0xFFFB8C00),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Service Cost Breakdown
                _buildSectionTitle('Service Cost Breakdown:'),
                const SizedBox(height: 12),
                _buildCostRow('Service Fee', '\$120'),
                _buildCostRow('Additional Charges', '\$15'),

                Container(
                  height: 1,
                  color: const Color(0xFFE0E0E0),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                ),

                _buildTotalRow('Total', '\$135'),

                const SizedBox(height: 32),

                // Track My Service Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to service tracking screen
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ServiceTrackingScreen(),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
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
}
