import 'package:flutter/material.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({Key? key}) : super(key: key);

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int? expandedIndex;

  final List<FaqItem> faqs = [
    FaqItem(
      question: 'Pinapple related questions:',
      answer:
          'Here you can find information about pineapple products, varieties, nutritional benefits, and storage tips.',
      isCategory: true,
    ),
    FaqItem(
      question: 'System related questions:',
      answer:
          'Learn about our app features, how to navigate the system, troubleshooting common issues, and system requirements.',
      isCategory: true,
    ),
    FaqItem(
      question: 'Support related questions:',
      answer:
          'Get help with technical support, customer service hours, contact methods, and response times.',
      isCategory: true,
    ),
    FaqItem(
      question: 'How can I reset my password?',
      answer:
          'To reset your password:\n1. Go to the login page\n2. Click on "Forgot Password"\n3. Enter your registered email\n4. Check your email for the reset link\n5. Follow the instructions to create a new password',
      isCategory: false,
    ),
    FaqItem(
      question: 'What are the available payment methods?',
      answer:
          'We accept the following payment methods:\n• Credit/Debit Cards (Visa, Mastercard, American Express)\n• Digital Wallets (PayPal, Google Pay, Apple Pay)\n• Bank Transfer\n• Cash on Delivery (selected areas)',
      isCategory: false,
    ),
    FaqItem(
      question: 'How do I update my account information?',
      answer:
          'To update your account information:\n1. Go to Settings\n2. Select "Account Settings"\n3. Click on "Edit Profile"\n4. Update your details\n5. Save changes\n\nYou can update your name, email, phone number, and address.',
      isCategory: false,
    ),
    FaqItem(
      question: 'How do I contact customer support?',
      answer:
          'You can contact our customer support through:\n• Email: support@example.com\n• Phone: 1-800-123-4567\n• Live Chat (available in the app)\n• Contact form on our website\n\nSupport hours: Mon-Fri 9AM-6PM',
      isCategory: false,
    ),
    FaqItem(
      question: 'Is my personal information secure?',
      answer:
          'Yes, we take your privacy seriously. We use:\n• SSL encryption for all data transmission\n• Secure servers with regular security audits\n• Strict data protection policies\n• No sharing of personal data with third parties without consent\n\nYour information is stored securely and complies with data protection regulations.',
      isCategory: false,
    ),
    FaqItem(
      question: 'What is the return policy?',
      answer:
          'Our return policy:\n• 30-day return window from delivery date\n• Items must be unused and in original packaging\n• Refund processed within 5-7 business days\n• Free return shipping for defective items\n• Partial refund for opened/used items\n\nTo initiate a return, go to Orders > Select item > Request Return',
      isCategory: false,
    ),
  ];

  void toggleExpansion(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2196F3),
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'FAQS',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Frequently Asked Questions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // FAQ List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  final isExpanded = expandedIndex == index;

                  return FaqCard(
                    faq: faq,
                    isExpanded: isExpanded,
                    onTap: () => toggleExpansion(index),
                  );
                },
              ),
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Submit your Question',
                  textAlign: TextAlign.center,
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
    );
  }
}

class FaqCard extends StatelessWidget {
  final FaqItem faq;
  final bool isExpanded;
  final VoidCallback onTap;

  const FaqCard({
    Key? key,
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE91E63), Color(0xFFD81B60)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E63).withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  faq.answer,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;
  final bool isCategory;

  FaqItem({
    required this.question,
    required this.answer,
    this.isCategory = false,
  });
}