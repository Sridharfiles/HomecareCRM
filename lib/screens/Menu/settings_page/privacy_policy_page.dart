import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Privacy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 52), // Balance the back button
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    
                    // Privacy Policy Title
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Privacy Policy Content
                    _buildBodyText(
                      'My Application is one of our main priorities is the privacy of our visitors.This privacy policy document contains types of information that is collected and recorded by My App and how we use it.',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'if you have additional questions or require more information about our Privacy policy do not hesitate to contact us',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'This privacy policy applies only to our online activities and is valid for visitors to or websitewith regards to the information that they shared and collect my app.',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'By using this our app,you hereby consent to our Privacy Policy and agree to its terms.This privacy policy has been generated with is available.',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'if you have additional questions or require more information about our Privacy policy do not hesitate to contact us',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'This privacy policy applies only to our online activities and is valid for visitors to or websitewith regards to the information that they shared and collect my app.',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'By using this our app,you hereby consent to our Privacy Policy and agree to its terms.This privacy policy has been generated whih is available.',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'if you have additional questions or require more information about our Privacy policy do not hesitate to contact us',
                    ),
                    const SizedBox(height: 12),

                    _buildBodyText(
                      'This privacy policy applies only to our online activities and is valid for visitors to or websitewith regards to the information that they shared and collect my app.',
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirm
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        height: 1.5,
        color: Colors.grey[600],
        fontWeight: FontWeight.w400,
      ),
    );
  }
}