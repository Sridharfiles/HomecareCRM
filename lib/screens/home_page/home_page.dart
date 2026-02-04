import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';
import 'package:homecarecrm/static_data/caregivers_data.dart';
import 'package:homecarecrm/screens/Menu/settings_page/notification_page.dart';
import 'package:homecarecrm/screens/Menu/main_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const SlideDrawer(), // Add drawer here
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF0D6EFD),
                    Color(0xFF1E88E5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 26,
                        ),
                      );
                    },
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFF0D6EFD),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Icons
            SizedBox(
              height: 110,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryIcon(
                    icon: Icons.handshake_outlined,
                    label: 'Elderly Care',
                    color: const Color(0xFFE3F2FD),
                    iconColor: const Color(0xFF2196F3),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.favorite_border,
                    label: 'Home Care',
                    color: const Color(0xFFFFEBEE),
                    iconColor: const Color(0xFFE91E63),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.volunteer_activism,
                    label: 'Personal Care',
                    color: const Color(0xFFFCE4EC),
                    iconColor: const Color(0xFFE91E63),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.family_restroom,
                    label: 'Family Care',
                    color: const Color(0xFFFFF3E0),
                    iconColor: const Color(0xFFFF9800),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.accessibility_new_outlined,
                    label: 'Disability Care',
                    color: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.child_care_rounded,
                    label: 'Child Care',
                    color: const Color(0xFFF3E5F5),
                    iconColor: const Color(0xFF9C27B0),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.pets_outlined,
                    label: 'Pet Care',
                    color: const Color(0xFFEFEBE9),
                    iconColor: const Color(0xFF795548),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.local_hospital,
                    label: 'Medical Care',
                    color: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.restaurant_menu,
                    label: 'Meal Support',
                    color: const Color(0xFFFFF9C4),
                    iconColor: const Color(0xFFFFEB3B),
                  ),
                  const SizedBox(width: 18),
                  _buildCategoryIcon(
                    icon: Icons.emergency,
                    label: 'Emergency Care',
                    color: const Color(0xFFFFE0B2),
                    iconColor: const Color(0xFFFF9800),
                  ),
                ],
              ),
            ),



            // Popular Services Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Services',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF0D6EFD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Service Cards Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: serviceData.length,
                itemBuilder: (context, index) {
                  return ServiceCard(service: serviceData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

