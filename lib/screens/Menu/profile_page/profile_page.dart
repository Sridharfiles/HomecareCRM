import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/Menu/profile_page/becaregiver.dart';
import 'package:homecarecrm/screens/Menu/profile_page/address_book_page.dart';
import 'package:homecarecrm/screens/Menu/profile_page/caregiver_application_status_page.dart';
import 'package:homecarecrm/screens/Menu/profile_page/change_password_page.dart';
import 'package:homecarecrm/screens/Menu/profile_page/edit_profile_page.dart';
import 'package:homecarecrm/services/user_details_store_services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static final UserDetailsStoreService _userService = UserDetailsStoreService();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E88E5),
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      icon: Icons.person,
                      title: 'User Information',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.volunteer_activism,
                      title: 'Become a Caregiver',
                      onTap: () => _showBecomeCaregiverBottomSheet(context),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.location_on,
                      title: 'Address Book',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddressBookPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.lock,
                      title: 'Change Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFFA726), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFFFA726), size: 24),
          ],
        ),
      ),
    );
  }

  void _showBecomeCaregiverBottomSheet(BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.volunteer_activism,
                  size: 40,
                  color: Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Become a Caregiver',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join our caregiving network and start helping families in need.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Complete your caregiver profile')),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Upload certificates and experience')),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Start receiving care requests')),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    await _handleApplyNow(parentContext);
                  },
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleApplyNow(BuildContext context) async {
    try {
      final userData = await _userService.fetchUserDetails();
      final User? currentUser = _auth.currentUser;

      if (!context.mounted) return;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login again to continue.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_isUserInformationComplete(userData)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please complete User Information before applying as caregiver.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final query = await _firestore
          .collection('caregivers')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      final docs = query.docs.toList()
        ..sort((a, b) {
          final aTs = a.data()['submittedAt'] as Timestamp?;
          final bTs = b.data()['submittedAt'] as Timestamp?;

          if (aTs == null && bTs == null) return 0;
          if (aTs == null) return 1;
          if (bTs == null) return -1;
          return bTs.compareTo(aTs);
        });

      if (docs.isNotEmpty) {
        final latestApplication = docs.first.data();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaregiverApplicationStatusPage(
              applicationData: latestApplication,
            ),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BeCaregiverPage()),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to verify user information. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isUserInformationComplete(Map<String, dynamic>? userData) {
    if (userData == null) return false;

    final requiredFields = [
      'firstName',
      'lastName',
      'email',
      'phoneNumber',
      'streetAddress',
      'city',
      'state',
      'country',
    ];

    for (final field in requiredFields) {
      final value = userData[field];
      if (value == null || value.toString().trim().isEmpty) {
        return false;
      }
    }

    final zipCode = userData['zipCode'];
    final pincode = userData['pincode'];
    final hasZip =
        (zipCode != null && zipCode.toString().trim().isNotEmpty) ||
        (pincode != null && pincode.toString().trim().isNotEmpty);

    return hasZip;
  }
}
