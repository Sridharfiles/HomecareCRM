import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';
import 'package:homecarecrm/screens/Menu/applications_page/applications.dart';
import 'package:homecarecrm/screens/Menu/service_page/create_service_page.dart';
import 'package:homecarecrm/screens/Menu/settings_page/notification_page.dart';
import 'package:homecarecrm/screens/Menu/main_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        String resolvedRole = 'user';
        if (userDoc.exists) {
          final data = userDoc.data();
          if (data is Map<String, dynamic>) {
            final roleValue = (data['role'] ?? '').toString().trim().toLowerCase();
            if (roleValue.isNotEmpty) {
              resolvedRole = roleValue;
            }
          }
        }

        if (mounted) {
          setState(() {
            _userRole = resolvedRole;
          });
        }
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const SlideDrawer(),
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
                  colors: [Color(0xFF0D6EFD), Color(0xFF1E88E5)],
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
            // Admin Panel (Only for Admin Users)
            if (_userRole == 'admin')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.admin_panel_settings,
                          color: Color(0xFF1E88E5),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildAdminFunctionVertical(
                      icon: Icons.person_add,
                      label: 'Manage Caregivers',
                      description: 'View and manage all caregivers',
                      backgroundColor: const Color(0xFF4CAF50),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Navigate to Caregiver Management'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildAdminFunctionVertical(
                      icon: Icons.pending_actions,
                      label: 'Applications',
                      description: 'Review pending caregiver applications',
                      backgroundColor: const Color(0xFF2196F3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplicationsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildAdminFunctionVertical(
                      icon: Icons.people,
                      label: 'Users',
                      description: 'Manage all platform users',
                      backgroundColor: const Color(0xFF9C27B0),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('View All Users'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildAdminFunctionVertical(
                      icon: Icons.analytics,
                      label: 'Analytics',
                      description: 'View reports and statistics',
                      backgroundColor: const Color(0xFFFF9800),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('View Analytics & Reports'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            // Caregiver Quick Card
            if (_userRole == 'caregiver')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.add_business,
                            color: Color(0xFF1E88E5),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Create a Service',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Provide services, set availability, and start receiving bookings from users.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF616161),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateServicePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Create a Service',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Category Icons (Hide for Admin and Caregiver)
            if (_userRole != 'admin' && _userRole != 'caregiver')
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
            // Popular Services Header (Hide for Admin and Caregiver)
            if (_userRole != 'admin' && _userRole != 'caregiver')
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
            // Service Cards Grid (Hide for Admin and Caregiver) - Fetch from Firestore
            if (_userRole != 'admin' && _userRole != 'caregiver')
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('services')
                      .where('status', isEqualTo: 'active')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D6EFD),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No services available'),
                      );
                    }

                    final services = snapshot.data!.docs;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final serviceDoc = services[index];
                        final data = serviceDoc.data() as Map<String, dynamic>;
                        
                        // Convert Firestore document to ServiceModel
                        final service = ServiceModel(
                          id: serviceDoc.id,
                          imageUrl: data['serviceCoverImageName'] != null && 
                                    data['serviceCoverImageName'].toString().isNotEmpty
                              ? data['serviceCoverImageName']
                              : 'assets/images/image1.jpg', // Placeholder image
                          title: data['title'] ?? 'Unknown Service',
                          rating: (data['rating'] ?? 0.0).toDouble(),
                          price: '\₹${data['price'] ?? '0'}',
                          location: data['location'] ?? 'Location not specified',
                          experience: data['experience'] ?? 'Experience not specified',
                          description: data['description'] ?? 'No description available',
                          features: List<String>.from(data['features'] ?? []),
                        );
                        
                        return ServiceCard(service: service);
                      },
                    );
                  },
                ),
              ),
            if (_userRole == 'admin' || _userRole == 'caregiver')
              const Expanded(
                child: SizedBox(),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 32),
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

  Widget _buildAdminFunctionVertical({
    required IconData icon,
    required String label,
    required String description,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
