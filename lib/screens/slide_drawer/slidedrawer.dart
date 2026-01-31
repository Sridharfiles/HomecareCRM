import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/slide_drawer/topcaregivers.dart';
import 'package:homecarecrm/screens/slide_drawer/task_schedule.dart';
import 'package:homecarecrm/screens/slide_drawer/prescriptions.dart';
import 'package:homecarecrm/screens/slide_drawer/screening_test.dart';
import 'package:homecarecrm/screens/slide_drawer/medication.dart';
import 'package:homecarecrm/screens/slide_drawer/availability.dart';
import 'package:homecarecrm/screens/slide_drawer/analytics.dart';
import 'package:homecarecrm/screens/slide_drawer/health_monitoring_page.dart';
import 'package:homecarecrm/screens/slide_drawer/history_page.dart';

class SlideDrawer extends StatelessWidget {
  const SlideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: Colors.white,
            child: Row(
              children: [
                // Profile Avatar with default icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 35, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                // User Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hey!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'James Powell',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Homepage',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.check_box,
                  title: 'Booking',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.star,
                  title: 'TopCaregivers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopCaregiversScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.monitor_heart,
                  title: 'HealthMonitoring',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HealthMonitoringPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'History',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today,
                  title: 'TaskSchedule',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const TaskScheduleManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.check_circle_outline,
                  title: 'ScreeningTest',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreeningTestScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.article,
                  title: 'Prescriptions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const DocumentsPrescriptionsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.medical_services,
                  title: 'Medication',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicationScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.access_time,
                  title: 'Availability',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvailabilityScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart,
                  title: 'Analytics',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnalyticsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: 'Favorite',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.search,
                  title: 'Search',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.bookmark,
                  title: 'Bookmark',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.calendar_month,
                  title: 'MyBookings',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.monetization_on,
                  title: 'Earnings',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.subscriptions,
                  title: 'Subscriptions',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.wallet,
                  title: 'Wallet',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.message,
                  title: 'Messages',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.reviews,
                  title: 'Reviwes',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black54,
        size: 24,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }
}
