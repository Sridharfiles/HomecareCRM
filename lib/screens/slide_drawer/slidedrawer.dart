import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/confirmbook.dart';
import 'package:homecarecrm/screens/slide_drawer/topcaregivers.dart';
import 'package:homecarecrm/service/google_signin_service.dart';

class SlideDrawer extends StatefulWidget {
  const SlideDrawer({Key? key}) : super(key: key);

  @override
  State<SlideDrawer> createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer> {
  Future<void> _handleSignOut(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D6EFD)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Logging out...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    try {
      final GoogleSignInService googleSignInService = GoogleSignInService();
      
      // Sign out (handles both Google and Firebase)
      await googleSignInService.signOut();
      
      // Close loading dialog if still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      // Navigate to login page and remove all previous routes
      // TODO: Uncomment and replace LoginScreen with your actual login screen
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => LoginScreen()),
      //   (route) => false,
      // );
      
      // Temporary: Show success message (Remove this after adding LoginScreen navigation)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text('Logged out successfully!'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
    } catch (e) {
      // Close loading dialog if still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      print('Error signing out: $e');
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text('Error signing out. Please try again.'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInService googleSignInService = GoogleSignInService();
    final User? currentUser = googleSignInService.currentUser;
    
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: currentUser?.photoURL != null 
                        ? Colors.transparent 
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                    image: currentUser?.photoURL != null
                        ? DecorationImage(
                            image: NetworkImage(currentUser!.photoURL!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: currentUser?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        currentUser?.displayName ?? 'Guest User',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (currentUser?.email != null)
                        Text(
                          currentUser!.email!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Homepage',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.check_box,
                  title: 'Booking',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmBookingScreen(),
                      ),
                    );
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
                  icon: Icons.monitor_heart,
                  title: 'HealthMonitoring',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'History',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today,
                  title: 'TaskSchedule',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.check_circle_outline,
                  title: 'ScreeningTest',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.article,
                  title: 'Prescriptions',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.medical_services,
                  title: 'Medication',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.access_time,
                  title: 'Availability',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart,
                  title: 'Analytics',
                  onTap: () {},
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
                  title: 'Reviews',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {},
                ),
                
                // Divider before Logout
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                ),
                
                // Logout
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    // Store the context before any async operations
                    final scaffoldContext = context;
                    
                    Navigator.pop(context); // Close drawer first
                    
                    // Show confirmation dialog
                    bool? shouldLogout = await showDialog<bool>(
                      context: scaffoldContext,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Row(
                            children: const [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Confirm Logout',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            'Are you sure you want to logout? You will need to sign in again to access your account.',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(false),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(dialogContext).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    
                    if (shouldLogout == true) {
                      _handleSignOut(scaffoldContext);
                    }
                  },
                  isLogout: true,
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
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.black87,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isLogout ? Colors.red : Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isLogout ? Colors.red.withOpacity(0.7) : Colors.black54,
        size: 24,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }
}
