import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/Menu/analytics_page/analytics_page.dart';
import 'package:homecarecrm/screens/Menu/availability_page/availability_page.dart';
import 'package:homecarecrm/screens/Menu/favorite_page/favorite_page.dart';
import 'package:homecarecrm/screens/Menu/healthmonitoring_page/health_monitoring_page.dart';
import 'package:homecarecrm/screens/Menu/history_page/history_page.dart';
import 'package:homecarecrm/screens/Menu/medication_page/medication_page.dart';
import 'package:homecarecrm/screens/Menu/messages_page/messages_page.dart';
import 'package:homecarecrm/screens/Menu/prescriptions_page/prescriptions_page.dart';
import 'package:homecarecrm/screens/Menu/profile_page/profile_page.dart';
import 'package:homecarecrm/screens/Menu/reviews_page/review_page.dart';
import 'package:homecarecrm/screens/Menu/screentesting_page/screening_test_page.dart';
import 'package:homecarecrm/screens/Menu/settings_page/settings_page.dart';
import 'package:homecarecrm/screens/Menu/taskschedule_page/task_schedule_page.dart';
import 'package:homecarecrm/screens/Menu/topcaregivers_page/topcaregivers.dart';
import 'package:homecarecrm/screens/Menu/bookmark_page/bookmarked_page.dart';
import 'package:homecarecrm/screens/Menu/subscriptions_page/subscription_page.dart';
import 'package:homecarecrm/screens/Menu/earnings_page/earnings_page.dart';
import 'package:homecarecrm/screens/Menu/mybookings_page/my_bookings_page.dart';
import 'package:homecarecrm/screens/Menu/search_page/search_screen.dart';
import 'package:homecarecrm/screens/Menu/wallet_page/wallet_page.dart';
import 'package:homecarecrm/services/google-signin.dart';
import 'package:homecarecrm/screens/login_page/login_page.dart';

class SlideDrawer extends StatefulWidget {
  const SlideDrawer({Key? key}) : super(key: key);

  @override
  State<SlideDrawer> createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer> {
  late GoogleSignInService _googleSignInService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _googleSignInService = GoogleSignInService();
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

  List<Widget> _buildMenuItems() {
    // Admin users only see: Homepage, Profile, Reviews, Settings, Logout
    if (_userRole == 'admin') {
      return [
        _buildMenuItem(
          icon: Icons.home,
          title: 'Homepage',
          onTap: () {
            Navigator.pop(context);
          },
        ),
        _buildMenuItem(
          icon: Icons.person,
          title: 'Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.reviews,
          title: 'Reviews',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReviewScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Log Out',
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Log Out'),
                  content: const Text(
                    'Are you sure you want to log out?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _googleSignInService.signOut();
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login',
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: const Text('Log Out'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ];
    }

    // Caregiver users only see: Homepage, History, Profile, Reviews, Settings, Logout
    if (_userRole == 'caregiver') {
      return [
        _buildMenuItem(
          icon: Icons.home,
          title: 'Homepage',
          onTap: () {
            Navigator.pop(context);
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
          icon: Icons.person,
          title: 'Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.reviews,
          title: 'Reviews',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReviewScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Log Out',
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Log Out'),
                  content: const Text(
                    'Are you sure you want to log out?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _googleSignInService.signOut();
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login',
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: const Text('Log Out'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ];
    }

    // Default menu for non-admin users
    return [
      _buildMenuItem(
        icon: Icons.home,
        title: 'Homepage',
        onTap: () {
          Navigator.pop(context);
        },
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
        icon: Icons.favorite,
        title: 'Favorite',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoriteCaregiverScreen(),
            ),
          );
        },
      ),
      _buildMenuItem(
        icon: Icons.search,
        title: 'Search',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
      ),
      _buildMenuItem(
        icon: Icons.calendar_month,
        title: 'MyBookings',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyBookingsPage(),
            ),
          );
        },
      ),
      _buildMenuItem(
        icon: Icons.message,
        title: 'Messages',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessagesPage()),
          );
        },
      ),
      _buildMenuItem(
        icon: Icons.person,
        title: 'Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        },
      ),
      _buildMenuItem(
        icon: Icons.reviews,
        title: 'Reviews',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReviewScreen(),
            ),
          );
        },
      ),
      _buildMenuItem(
        icon: Icons.settings,
        title: 'Settings',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
      ),
      const SizedBox(height: 8),
      const Divider(
        height: 1,
        thickness: 1,
        indent: 20,
        endIndent: 20,
        color: Colors.grey,
      ),
      const SizedBox(height: 8),
      _buildMenuItem(
        icon: Icons.logout,
        title: 'Log Out',
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Log Out'),
                content: const Text(
                  'Are you sure you want to log out?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _googleSignInService.signOut();
                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: const Text('Log Out'),
                  ),
                ],
              );
            },
          );
        },
      ),
    ];
  }

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
                // Profile Avatar with user photo or default icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: _googleSignInService.getUserPhotoUrl() != null
                        ? DecorationImage(
                            image: NetworkImage(
                              _googleSignInService.getUserPhotoUrl()!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _googleSignInService.getUserPhotoUrl() == null
                      ? Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hey!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _googleSignInService.getUserDisplayName() ?? 'User',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _googleSignInService.getUserEmail() ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (_userRole == 'admin' || _userRole == 'caregiver')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFF1E88E5),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _userRole == 'admin'
                                    ? Icons.admin_panel_settings
                                    : Icons.volunteer_activism,
                                size: 12,
                                color: Color(0xFF1E88E5),
                              ),
                              SizedBox(width: 4),
                              Text(
                                _userRole == 'admin' ? 'Admin' : 'Caregiver',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1E88E5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildMenuItems(),
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
