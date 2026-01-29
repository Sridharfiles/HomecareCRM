import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appointmentconfirmation.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedDate = '';
  String selectedTimeSlot = '';
  String selectedPaymentMethod = 'paypal'; // paypal, cash, card
  String cardHolderName = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';

  final List<String> timeSlots = [
    '8 AM – 11 AM',
    '11 AM – 1 PM',
    '2 PM – 5 PM',
    '5 PM – 8 PM',
    '8 PM – 11 PM',
  ];

  // Price calculation
  double get subtotal => 150.0;
  double get couponDiscount => 20.0;
  double get deliveryFee => 10.0;
  double get total => subtotal - couponDiscount + deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E88E5)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expected Date & Time Section
            const Text(
              'Expected date & Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Select Date Field
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate =
                              '${picked.day}/${picked.month}/${picked.year}';
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF0D6EFD),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedDate.isEmpty
                                  ? 'Select Date'
                                  : selectedDate,
                              style: TextStyle(
                                color:
                                    selectedDate.isEmpty
                                        ? Colors.grey
                                        : const Color(0xFF444444),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Slot Buttons
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Time Slot',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        timeSlots.map((timeSlot) {
                          final isSelected = selectedTimeSlot == timeSlot;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTimeSlot = timeSlot;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFFFA000)
                                        : const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFFFFA000)
                                          : const Color(0xFFDDDDDD),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timeSlot,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color(0xFF555555),
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method Section
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // PayPal Option
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'paypal';
                      });
                    },
                    child: Row(
                      children: [
                        // PayPal Logo
                        Container(
                          width: 40,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF003087), Color(0xFF009CDE)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              'PayPal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Pay with PayPal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                        // Radio Button
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  selectedPaymentMethod == 'paypal'
                                      ? const Color(0xFFFFA000)
                                      : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child:
                              selectedPaymentMethod == 'paypal'
                                  ? const Center(
                                    child: Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: Color(0xFFFFA000),
                                    ),
                                  )
                                  : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider Line
                  Container(height: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // Cash on Delivery Option
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'cash';
                      });
                    },
                    child: Row(
                      children: [
                        // Cash/Card Icon
                        Container(
                          width: 40,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.handHoldingUsd,
                              color: const Color(0xFFFFA000),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Cash on delivery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                        // Radio Button
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  selectedPaymentMethod == 'cash'
                                      ? const Color(0xFFFFA000)
                                      : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child:
                              selectedPaymentMethod == 'cash'
                                  ? const Center(
                                    child: Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: Color(0xFFFFA000),
                                    ),
                                  )
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card Details Section (Conditional)
            if (selectedPaymentMethod == 'paypal')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          'Card Holder Name',
                          Icons.person,
                          (value) => cardHolderName = value,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Card Number',
                          Icons.credit_card,
                          (value) => cardNumber = value,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'Expiry Date',
                                Icons.date_range,
                                (value) => expiryDate = value,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                'CVV',
                                Icons.lock,
                                (value) => cvv = value,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            // Price Summary Section
            const Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPriceRow(
                    'Sub total',
                    '\$${subtotal.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow(
                    'Coupon',
                    '-\$${couponDiscount.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow(
                    'Delivery Fee',
                    '\$${deliveryFee.toStringAsFixed(2)}',
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  _buildPriceRow(
                    'Total',
                    '\$${total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _validateAndProceed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _validateAndProceed() {
    // Validate date selection
    if (selectedDate.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    // Validate time slot selection
    if (selectedTimeSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    // Validate payment method
    if (selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    // If PayPal is selected, validate card details
    if (selectedPaymentMethod == 'paypal') {
      if (cardHolderName.isEmpty ||
          cardNumber.isEmpty ||
          expiryDate.isEmpty ||
          cvv.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all card details')),
        );
        return;
      }
    }

    // Navigate to confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AppointmentConfirmationScreen(),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    Function(String) onChanged, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF999999)),
        prefixIcon: Icon(icon, color: const Color(0xFF777777)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : const Color(0xFF1E88E5),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isDiscount
                      ? Colors.green
                      : (isTotal ? Colors.black : const Color(0xFF1E88E5)),
            ),
          ),
        ],
      ),
    );
  }
}
