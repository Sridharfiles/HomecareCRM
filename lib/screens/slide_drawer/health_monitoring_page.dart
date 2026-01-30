import 'package:flutter/material.dart';

class HealthMonitoringPage extends StatelessWidget {
  const HealthMonitoringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Health Monitoring & Reports',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Caregiver Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: const NetworkImage('https://picsum.photos/seed/johndoe/200/200.jpg'),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Caregiver',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Health Tracking Section
            const Text(
              'Health Tracking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Grid of Health Cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildHealthCard(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(int index) {
    final cards = [
      {
        'title': 'Vitals Tracking',
        'percentage': '80%',
        'icon': Icons.favorite,
        'color': Colors.blue,
        'progress': 0.8,
      },
      {
        'title': 'Mood Logging',
        'percentage': '60%',
        'icon': Icons.sentiment_satisfied_alt,
        'color': Colors.purple,
        'progress': 0.6,
      },
      {
        'title': 'Activity Tracking',
        'percentage': '75%',
        'icon': Icons.directions_run,
        'color': Colors.red,
        'progress': 0.75,
      },
      {
        'title': 'Sleep Tracking',
        'percentage': '50%',
        'icon': Icons.bedtime,
        'color': Colors.blue,
        'progress': 0.5,
      },
      {
        'title': 'Water Intake',
        'percentage': '90%',
        'icon': Icons.water_drop,
        'color': Colors.green,
        'progress': 0.9,
      },
      {
        'title': 'Medication Reminder',
        'percentage': '40%',
        'icon': Icons.medication,
        'color': Colors.orange,
        'progress': 0.4,
      },
    ];

    final card = cards[index];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Progress Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: card['progress'] as double,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(card['color'] as Color),
                  strokeWidth: 6,
                ),
              ),
              Icon(
                card['icon'] as IconData,
                color: card['color'] as Color,
                size: 24,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            card['title'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          // Percentage
          Text(
            card['percentage'] as String,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: card['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }
}
