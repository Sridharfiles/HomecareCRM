import 'package:flutter/material.dart';

class TaskScheduleManagementScreen extends StatelessWidget {
  const TaskScheduleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task & Schedule Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Caregiver Profile Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/caregiver_profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Role
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Caregiver',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF777777),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '📅 Daily Task List',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Task List Items
            TaskCard(
              index: 0,
              icon: Icons.medical_services,
              iconColor: const Color(0xFF2196F3), // Bright Blue
              title: 'Doctor Visit',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            TaskCard(
              index: 1,
              icon: Icons.sports_handball,
              iconColor: const Color(0xFF4CAF50), // Bright Green
              title: 'Therapy Session',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            TaskCard(
              index: 2,
              icon: Icons.medication,
              iconColor: const Color(0xFFF44336), // Bright Red
              title: 'Medication Reminder',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            TaskCard(
              index: 3,
              icon: Icons.fitness_center,
              iconColor: const Color(0xFFFF9800), // Bright Orange
              title: 'Exercise Routine',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            TaskCard(
              index: 4,
              icon: Icons.restaurant,
              iconColor: const Color(0xFF9C27B0), // Bright Purple
              title: 'Meal Preparation',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            TaskCard(
              index: 5,
              icon: Icons.monitor_heart,
              iconColor: const Color(0xFF009688), // Bright Teal
              title: 'Check Vital Signs',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            TaskCard(
              index: 6,
              icon: Icons.directions_walk,
              iconColor: const Color(0xFF3F51B5), // Bright Indigo
              title: 'Evening Walk',
              subtitle: 'Scheduled for today',
              isCompleted: true,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.index,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: Colors.blue.withOpacity(0.1),
          child: Row(
            children: [
              // Left Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),

              const SizedBox(width: 16),

              // Center Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),

              // Right Check Icon
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child:
                      isCompleted
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )
                          : Icon(
                            Icons.circle_outlined,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
