import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/Menu/wallet_page/topup_wallet_successfully_page.dart';

class TopupEWalletPage extends StatefulWidget {
  const TopupEWalletPage({Key? key}) : super(key: key);

  @override
  State<TopupEWalletPage> createState() => _TopupEWalletPageState();
}

class _TopupEWalletPageState extends State<TopupEWalletPage> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TopUpEWallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            
            // Credit & Debit Cards Section
            const Text(
              'Credit & Debit Cards',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Add New Card Option
            _buildPaymentOption(
              title: 'Add New Card',
              icon: Icons.add_card,
              value: 'add_new_card',
            ),
            
            const SizedBox(height: 24),
            
            // More payment Options Section
            const Text(
              'More payment Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Master Card Option
            _buildPaymentOption(
              title: 'Master Card',
              icon: Icons.credit_card,
              value: 'master_card',
            ),
            
            const SizedBox(height: 12),
            
            // Apple Pay Option
            _buildPaymentOption(
              title: 'Apple Pay',
              icon: Icons.apple,
              value: 'apple_pay',
            ),
            
            const SizedBox(height: 12),
            
            // Google Pay Option
            _buildPaymentOption(
              title: 'Google Pay',
              icon: Icons.account_balance_wallet,
              value: 'google_pay',
            ),
            
            const SizedBox(height: 12),
            
            // PayPal Option
            _buildPaymentOption(
              title: 'PayPal',
              icon: Icons.payment,
              value: 'paypal',
            ),
            
            const SizedBox(height: 40),
            
            // Next Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TopupWalletSuccessfullyPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D6EFD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedOption == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0D6EFD).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0D6EFD),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.radio_button_checked,
                color: Color(0xFF0D6EFD),
                size: 20,
              )
            else
              const Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
