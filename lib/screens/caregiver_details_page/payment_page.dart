import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/payment_services.dart';
import 'serviceconfirmation_page.dart';
import '../home_page/service_card.dart';

class PaymentScreen extends StatefulWidget {
  final ServiceModel service;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int selectedHours;

  const PaymentScreen({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedHours,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentService _paymentService;
  bool _isProcessing = false;
  String selectedPaymentMethod = 'paypal'; // paypal, cash, card, upi
  String cardHolderName = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String upiId = '';

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService();
  }

  // Price calculation
  double get subtotal {
    // For UPI testing, return 0 to make total = 1.0
    if (selectedPaymentMethod == 'upi') {
      return 0.0;
    }
    // Parse service price and multiply by selected hours
    // Remove $ and /hr, then extract only the numerical part
    final priceString =
        widget.service.price.replaceAll('\$', '').replaceAll('/hr', '').trim();
    final servicePrice = double.parse(priceString);
    return servicePrice * widget.selectedHours;
  }

  double get couponDiscount => 0.0; // No coupon by default
  double get deliveryFee => 1.0; // Fixed delivery fee for testing (in INR for UPI)
  double get total => subtotal - couponDiscount + deliveryFee;

  // Get currency symbol based on payment method
  String get currencySymbol {
    if (selectedPaymentMethod == 'upi') {
      return '₹'; // Indian Rupee for UPI
    }
    return '\$'; // USD for PayPal and others
  }

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
                  const SizedBox(height: 16),

                  // Divider Line
                  Container(height: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // UPI Option
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'upi';
                      });
                    },
                    child: Row(
                      children: [
                        // UPI Icon
                        Container(
                          width: 40,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B63B5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.mobileScreen,
                              color: Color(0xFF6B63B5),
                              size: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Pay with UPI',
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
                                  selectedPaymentMethod == 'upi'
                                      ? const Color(0xFFFFA000)
                                      : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child:
                              selectedPaymentMethod == 'upi'
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


            // Service Details Section
            const Text(
              'Service Details',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Duration: ${widget.selectedHours} hour${widget.selectedHours > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${_formatDate(widget.selectedDate)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${_formatTime(widget.selectedTime)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                    '$currencySymbol${subtotal.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow(
                    'Coupon',
                    '-$currencySymbol${couponDiscount.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow(
                    'Delivery Fee',
                    '$currencySymbol${deliveryFee.toStringAsFixed(2)}',
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  _buildPriceRow(
                    'Total',
                    '$currencySymbol${total.toStringAsFixed(2)}',
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
                onPressed: _isProcessing ? null : () {
                  _validateAndProceed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: _isProcessing
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
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
    // Validate payment method
    if (selectedPaymentMethod.isEmpty) {
      _showError('Please select a payment method');
      return;
    }

    // If PayPal is selected, validate card details
    if (selectedPaymentMethod == 'paypal') {
      if (cardHolderName.isEmpty ||
          cardNumber.isEmpty ||
          expiryDate.isEmpty ||
          cvv.isEmpty) {
        _showError('Please fill all card details');
        return;
      }
    }

    // Process payment
    _processPayment();
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Generate a transaction ID for this payment
      final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

      // Process payment based on method
      Map<String, dynamic> paymentResult = {};

      if (selectedPaymentMethod == 'paypal') {
        paymentResult = await _paymentService.processPayPalPayment(
          cardHolderName: cardHolderName,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
          amount: total,
          bookingId: transactionId,
        );
      } else if (selectedPaymentMethod == 'upi') {
        // For UPI, first validate amount and launch the UPI app
        final upiResult = await _paymentService.initiateUpiPayment(
          amount: total.toStringAsFixed(2),
        );

        if (!mounted) return;

        // Handle different error types
        if (!upiResult['success']) {
          final errorType = upiResult['errorType'] ?? 'UNKNOWN_ERROR';
          
          setState(() {
            _isProcessing = false;
          });

          // Show specific error dialog based on error type
          if (errorType == 'AMOUNT_EXCEEDS_LIMIT') {
            await _showAmountErrorDialog(upiResult);
          } else if (errorType == 'NO_UPI_APP') {
            await _showNoUpiAppDialog(upiResult);
          } else {
            _showError(upiResult['message'] ?? 'UPI payment initiation failed');
          }
          return;
        }

        // Show warning if amount is close to limit
        if (upiResult['isWarning'] == true) {
          bool continuePayment = await _showAmountWarningDialog(upiResult['warning']);
          if (!continuePayment) {
            setState(() {
              _isProcessing = false;
            });
            return;
          }
        }

        // Ask user to confirm payment completion
        final paymentConfirmed = await _showPaymentConfirmationDialog();

        if (!paymentConfirmed) {
          _showError('Payment was not completed');
          setState(() {
            _isProcessing = false;
          });
          return;
        }

        // User confirmed payment - create payment record
        paymentResult = await _paymentService.processUPIPayment(
          amount: total,
          bookingId: transactionId,
        );
      } else if (selectedPaymentMethod == 'cash') {
        paymentResult = await _paymentService.processCashPayment(
          amount: total,
          bookingId: transactionId,
        );
      }

      if (!mounted) return;

      if (paymentResult['success'] == true) {
        // Payment completed successfully - navigate to confirmation screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceConfirmationScreen(
              service: widget.service,
              selectedDate: widget.selectedDate,
              selectedTime: widget.selectedTime,
              selectedHours: widget.selectedHours,
              paymentMethod: selectedPaymentMethod,
              cost: total,
              paymentId: paymentResult['paymentId'] ?? transactionId,
              cardHolderName:
                  cardHolderName.isEmpty ? null : cardHolderName,
              cardNumber: cardNumber.isEmpty ? null : cardNumber,
              expiryDate: expiryDate.isEmpty ? null : expiryDate,
              cvv: cvv.isEmpty ? null : cvv,
              upiId: upiId.isEmpty ? null : upiId,
            ),
          ),
        );
      } else {
        _showError(paymentResult['message'] ?? 'Payment processing failed');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<bool> _showPaymentConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Confirmation'),
          content: const Text(
            'Have you completed the UPI payment successfully?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No, Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
              ),
              child: const Text('Yes, Completed'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Dialog for amount exceeding UPI limit
  Future<void> _showAmountErrorDialog(Map<String, dynamic> errorData) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Amount Too High'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(errorData['message']),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your UPI Limit:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('₹${errorData['maxLimit']}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Dialog for warning when amount is close to limit
  Future<bool> _showAmountWarningDialog(String warning) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Amount Warning'),
          content: Text(warning),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA000),
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Dialog when no UPI app is installed
  Future<void> _showNoUpiAppDialog(Map<String, dynamic> errorData) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No UPI App Found'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please install one of these UPI payment apps:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildUpiAppOption('Google Pay', '10M+'),
                _buildUpiAppOption('PhonePe', '50M+'),
                _buildUpiAppOption('BHIM', '5M+'),
                _buildUpiAppOption('Amazon Pay', '10M+'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpiAppOption(String appName, String downloads) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.app_registration, color: Color(0xFF1E88E5)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                downloads,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
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

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
