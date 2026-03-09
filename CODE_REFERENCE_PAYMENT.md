# UPI Payment Implementation - Code Reference

## Overview of Implementation

This document shows the exact code structure and how everything connects together.

---

## 1. PaymentService Class Structure

**Location**: `lib/services/payment_services.dart`

### Methods Available:

```dart
class PaymentService {
  // Constants (Edit these to change configuration)
  static const String MERCHANT_UPI_ID = 'sridharkumaresan4-1@okicici';
  static const double BASE_PRICE = 0.2;
  static const double DELIVERY_FEE = 15.0;

  // Main Payment Methods
  Future<Map<String, dynamic>> processUPIPayment({...})
  Future<Map<String, dynamic>> processPayPalPayment({...})
  Future<Map<String, dynamic>> processCashPayment({...})
  
  // Helper Methods
  Future<void> updatePaymentStatus(String paymentId, String newStatus)
  Future<Map<String, dynamic>?> getPaymentById(String paymentId)
  Future<List<Map<String, dynamic>>> getUserPayments()
  String generateUPIDeepLink({...})
  
  // Validation Methods (Private)
  bool _isValidUPI(String upi)
  bool _isValidCardNumber(String cardNumber)
  bool _isValidExpiry(String expiry)
  bool _isValidCVV(String cvv)
}
```

### UPI Payment Processing:

```dart
// Method signature
Future<Map<String, dynamic>> processUPIPayment({
  required String userUpiId,      // User's UPI ID
  required double amount,         // Payment amount
  required String bookingId,      // Reference ID
}) async {
  // 1. Validates format: ^[a-zA-Z0-9._-]+@[a-zA-Z]+$
  // 2. Creates Firestore document in 'payments' collection
  // 3. Returns success/error map
}

// Response on Success:
{
  'success': true,
  'paymentId': 'document-id',
  'message': 'Payment initiated successfully',
  'amount': 0.2,
  'upiId': 'user@bank',
  'merchantUpiId': 'sridharkumaresan4-1@okicici',
}

// Response on Error:
{
  'success': false,
  'message': 'Error processing payment: Invalid UPI ID format',
}
```

---

## 2. PaymentScreen Integration

**Location**: `lib/screens/caregiver_details_page/payment_page.dart`

### Class Structure:

```dart
class PaymentScreen extends StatefulWidget {
  final ServiceModel service;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int selectedHours;
  // Constructor...
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Variables
  late PaymentService _paymentService;
  bool _isProcessing = false;
  String selectedPaymentMethod = 'paypal';
  String upiId = '';
  String cardHolderName = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService();  // Initialize service
  }

  // Main method that handles payment
  Future<void> _processPayment() async {
    // 1. Sets _isProcessing = true (shows loading)
    // 2. Creates transaction ID
    // 3. Calls appropriate payment method based on selection
    // 4. Handles response and navigates on success
    // 5. Shows error message on failure
  }

  void _validateAndProceed() {
    // 1. Validates payment method selected
    // 2. Validates method-specific fields:
    //    - PayPal: card details
    //    - UPI: UPI ID format (must have @)
    //    - Cash: no validation needed
    // 3. Calls _processPayment() if valid
  }

  void _showError(String message) {
    // Shows red SnackBar with error message
  }
}
```

### Currency Symbol Logic:

```dart
String get currencySymbol {
  if (selectedPaymentMethod == 'upi') {
    return '₹';  // Indian Rupee
  }
  return '\$';   // US Dollar
}
```

### Proceed Button State:

```dart
// Disabled during processing
_isProcessing ? null : () { _validateAndProceed(); }

// Shows loading spinner when processing
_isProcessing
    ? CircularProgressIndicator(...)
    : Text('Proceed')
```

---

## 3. Validation Implementation

### UPI Validation Regex:

```dart
// Pattern: username@bankname
// Allows: letters, numbers, dots, dashes, underscores before @
// Bank name: letters only
// Pattern: ^[a-zA-Z0-9._-]+@[a-zA-Z]+$

bool _isValidUPI(String upi) {
  final upiRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z]+$');
  return upiRegex.hasMatch(upi);
}

// Validation in payment page:
if (selectedPaymentMethod == 'upi') {
  if (upiId.isEmpty || !upiId.contains('@')) {
    _showError('Please enter a valid UPI ID (e.g., username@bankname)');
    return;
  }
}
```

### Valid Examples:

| Valid Examples | Why Valid |
|---|---|
| `azhar123@okicibank` | Has all allowed chars + @ + letters after @ |
| `john.doe@icici` | Dot in username allowed |
| `user-name@ybl` | Dash in username allowed |
| `person_123@hdfc` | Underscore in username allowed |

### Invalid Examples:

| Invalid Examples | Why Invalid |
|---|---|
| `azhar123` | Missing @ symbol |
| `azhar@bank@name` | Multiple @ symbols |
| `@okicibank` | No username |
| `azhar@123` | Numbers in bank name |
| `azhar @bank` | Space not allowed |

---

## 4. Data Flow Diagram

```
User Opens PaymentScreen
    ↓
   [Selects Payment Method]
    ├─ PayPal
    ├─ UPI
    └─ Cash
    ↓
   [Shows Method-Specific Form]
    └─ UPI Shows:
       ├─ Input: Your UPI ID field
       ├─ Display: Merchant UPI: sridharkumaresan4-1@okicici
       └─ Display: Amount: ₹0.20
    ↓
   [Uses UPI Regex Validation]
    └─ Pattern: ^[a-zA-Z0-9._-]+@[a-zA-Z]+$
    ↓
   [PaymentService.processUPIPayment()]
    ├─ Validates UPI format
    ├─ Creates transaction ID
    ├─ Stores in Firestore 'payments' collection
    └─ Returns success/error
    ↓
   [Navigate to ServiceConfirmationScreen]
    └─ Booking stored in 'bookings' collection
```

---

## 5. Firestore Collections Structure

### payments/ Collection

```
payments/
├── doc1/
│   ├── userId: "user123abc"
│   ├── userEmail: "user@gmail.com"
│   ├── bookingId: "TXN_1709862600000"
│   ├── paymentMethod: "upi"
│   ├── userUpiId: "azhar123@okicibank"
│   ├── merchantUpiId: "sridharkumaresan4-1@okicici"
│   ├── amount: 0.2
│   ├── currency: "INR"
│   ├── status: "pending"
│   ├── createdAt: Timestamp(2026-03-07 12:30:00)
│   └── updatedAt: Timestamp(2026-03-07 12:30:00)
│
└── doc2/
    └── (same structure, different payment method)
```

### bookings/ Collection

```
bookings/
├── doc1/
│   ├── userId: "user123abc"
│   ├── caregiverName: "John Smith"
│   ├── serviceTitle: "Home Care Nurse"
│   ├── selectedDate: "2026-03-15"
│   ├── selectedTime: "10:00 AM"
│   ├── selectedHours: 2
│   ├── paymentMethod: "upi"
│   ├── totalAmount: 100
│   ├── paymentDetails:
│   │   ├── method: "upi"
│   │   └── upiId: "azhar123@okicibank"
│   ├── status: "pending"
│   ├── createdAt: Timestamp(...)
│   └── updatedAt: Timestamp(...)
│
└── doc2/
    └── (another booking)
```

---

## 6. Error Handling Flow

```
Payment Processing Starts
    ├─ Try Block Begins
    │   ├─ Check authentication
    │   ├─ Validate UPI format
    │   ├─ Create payment record
    │   ├─ Write to Firestore
    │   └─ Set status "pending"
    │
    ├─ Catch Block (Any error)
    │   ├─ Sets _isProcessing = false
    │   ├─ Shows SnackBar with error message
    │   └─ User can retry
    │
    └─ Finally Block
        └─ Stops loading spinner
        └─ Re-enables Proceed button
```

### Possible Errors Caught:

```dart
// User not authenticated
"Error processing payment: User not authenticated"

// Invalid format
"Invalid UPI ID format"

// Firestore permission
"Missing or insufficient permissions"

// Network issue
"Error: connection timeout"

// Generic catch
"Error: [error message]"
```

---

## 7. Configuration Constants

### In PaymentService:

```dart
// Merchant UPI ID - Change this to your UPI
static const String MERCHANT_UPI_ID = 'sridharkumaresan4-1@okicici';

// Base test amount in rupees
// For testing: 0.2
// For production: change to actual price
static const double BASE_PRICE = 0.2;

// Delivery fee (flat rate for all services)
static const double DELIVERY_FEE = 15.0;
```

### Currency Dictionary (In PaymentScreen):

```dart
// UPI uses Indian Rupee
selectedPaymentMethod == 'upi' → '₹'

// PayPal uses US Dollar
selectedPaymentMethod == 'paypal' → '$'

// Cash uses Rupee (India-based)
selectedPaymentMethod == 'cash' → '₹'
```

---

## 8. Key Methods - Detailed Breakdown

### _validateAndProceed()

```dart
void _validateAndProceed() {
  // Step 1: Check if method selected
  if (selectedPaymentMethod.isEmpty) {
    _showError('Please select a payment method');
    return;
  }

  // Step 2: Validate PayPal details if selected
  if (selectedPaymentMethod == 'paypal') {
    if (cardHolderName.isEmpty || cardNumber.isEmpty || 
        expiryDate.isEmpty || cvv.isEmpty) {
      _showError('Please fill all card details');
      return;
    }
  }

  // Step 3: Validate UPI ID if selected
  if (selectedPaymentMethod == 'upi') {
    if (upiId.isEmpty || !upiId.contains('@')) {
      _showError('Please enter a valid UPI ID (e.g., username@bankname)');
      return;
    }
  }

  // Step 4: All validated, process payment
  _processPayment();
}
```

### _processPayment()

```dart
Future<void> _processPayment() async {
  setState(() { _isProcessing = true; });  // Show loading

  try {
    // Create unique transaction ID
    final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

    // Process based on selected method
    Map<String, dynamic> paymentResult = {};

    if (selectedPaymentMethod == 'upi') {
      paymentResult = await _paymentService.processUPIPayment(
        userUpiId: upiId,
        amount: total,
        bookingId: transactionId,
      );
    } else if (selectedPaymentMethod == 'paypal') {
      paymentResult = await _paymentService.processPayPalPayment(
        cardHolderName: cardHolderName,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        amount: total,
        bookingId: transactionId,
      );
    } else if (selectedPaymentMethod == 'cash') {
      paymentResult = await _paymentService.processCashPayment(
        amount: total,
        bookingId: transactionId,
      );
    }

    // Check result
    if (paymentResult['success'] == true) {
      // Success - navigate to confirmation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceConfirmationScreen(
            // Pass all booking details...
          ),
        ),
      );
    } else {
      // Failed - show error
      _showError(paymentResult['message'] ?? 'Payment failed');
    }
  } catch (e) {
    _showError('Error: ${e.toString()}');
  } finally {
    setState(() { _isProcessing = false; });  // Hide loading
  }
}
```

---

## 9. Testing Code Examples

### Test Valid UPI ID:

```dart
// These will PASS validation
String validUPI1 = 'azhar123@okicibank';
String validUPI2 = 'john.doe@icici';
String validUPI3 = 'user_name@ybl';
String validUPI4 = 'person-account@hdfc';

// Test with validation regex
final upiRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z]+$');
print(upiRegex.hasMatch(validUPI1)); // true
```

### Test Invalid UPI ID:

```dart
// These will FAIL validation
String invalidUPI1 = 'azhar123';          // No @
String invalidUPI2 = 'azhar@';            // No bank name
String invalidUPI3 = 'azhar@@icici';      // Double @
String invalidUPI4 = 'azhar @icici';      // Space not allowed
String invalidUPI5 = 'azhar@123';         // Numbers in bank name

// Test with validation regex
final upiRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z]+$');
print(upiRegex.hasMatch(invalidUPI1)); // false
```

---

## 10. Integration Points

### Where PaymentService is Used:

1. **payment_page.dart** - Main integration point
   ```dart
   import '../../services/payment_services.dart';
   
   late PaymentService _paymentService;
   
   @override
   void initState() {
     _paymentService = PaymentService();
   }
   ```

2. **serviceconfirmation_page.dart** - Could use for payment verification
   ```dart
   // Optional: verify payment status
   final paymentService = PaymentService();
   var payment = await paymentService.getPaymentById(paymentId);
   ```

3. **my_bookings_page.dart** - Could show payment status
   ```dart
   // Optional: display payment details in booking list
   ```

---

## 11. Future Integration Points

For real payment processing, integrate:

### For Real UPI Payments:
```dart
// Use Razorpay or Phonepe SDK
// Replace processUPIPayment() with actual gateway call
// Keep Firestore record creation
```

### For Email Notifications:
```dart
// After successful payment:
// 1. Send email receipt
// 2. Send booking confirmation
// 3. Track payment status
```

### For Invoice Generation:
```dart
// After payment success:
// 1. Generate PDF invoice
// 2. Store invoice in Cloud Storage
// 3. Email invoice to user
```

---

## 12. Quick Reference - Common Tasks

### Change Merchant UPI:
```dart
// File: lib/services/payment_services.dart, Line ~X
static const String MERCHANT_UPI_ID = 'your-new-upi@bank';
```

### Change Test Amount:
```dart
// File: lib/services/payment_services.dart, Line ~X
static const double BASE_PRICE = 50.0; // 50 rupees or cents
```

### Add New Payment Method:
```dart
// 1. Add method in PaymentScreen UI
// 2. Add validation in _validateAndProceed()
// 3. Add processing in _processPayment()
// 4. Add method in PaymentService
```

### Debug Payment Issues:
```dart
// Check Firestore Console for payment documents
// Check Flutter logs: print() statements show transaction ID
// Check network in DevTools
// Enable Firestore logging: FirebaseFirestore.enableLogging(true);
```

---

**End of Code Reference**

For more information, see:
- `PAYMENT_INTEGRATION.md` - Full technical documentation
- `PAYMENT_QUICK_START.md` - Testing guide
- `UPI_PAYMENT_SETUP_COMPLETE.md` - Complete setup summary
