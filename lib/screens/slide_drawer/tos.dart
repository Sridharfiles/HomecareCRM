import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

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
                      'Terms Of Services',
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
                    
                    // Terms of Service Section
                    _buildSectionTitle('Terms of Service'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'These Terms of Service ("Terms") govern your use of HRMS mobile application (the "App") provided by. By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of the Terms, you may not access the App.',
                    ),
                    const SizedBox(height: 18),

                    // Use of the App Section
                    _buildSectionTitle('Use of the App'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'You must be at least 13 years old to use the App. If you are under 13, you may not use the App.You agree to use the App only for lawful purposes and in compliance with these Terms.You may not modify, adapt, or hack the App or modify another app to falsely imply that it is associated with the App.',
                    ),
                    const SizedBox(height: 18),

                    // Intellectual Property Section
                    _buildSectionTitle('Intellectual Property'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'The App and its original content, features, and functionality are owned by HRMS and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.You may not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any of the material on our App without our prior written consent.',
                    ),
                    const SizedBox(height: 18),

                    // Privacy Section
                    _buildSectionTitle('Privacy'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'Your use of the App is also governed by our Privacy Policy. By using the App, you consent to the collection and use of information as described in our Privacy Policy',
                    ),
                    const SizedBox(height: 18),

                    // Disclaimer Section
                    _buildSectionTitle('Disclaimer'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'The App is provided "as is" and "as available" without warranties of any kind, either express or implied.Virute does not warrant that the App will be uninterrupted or error-free, thatdefects will be corrected, or that the App is free of viruses or other harmful components',
                    ),
                    const SizedBox(height: 18),

                    // Governing Law Section
                    _buildSectionTitle('Governing Law'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'These Terms shall be governed by and construed in accordance with the laws of Virtue, without regard to its conflict of law provisions.',
                    ),
                    const SizedBox(height: 18),

                    // Changes to Terms Section
                    _buildSectionTitle('Changes to Terms'),
                    const SizedBox(height: 10),
                    _buildBodyText(
                      'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking',
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
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
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle decline
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle accept
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
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
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