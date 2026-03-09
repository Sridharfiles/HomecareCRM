# Payment Integration Documentation

## Overview

The HomecareCRM application now supports three payment methods:
1. **PayPal** - Card-based payments (USD)
2. **Cash on Delivery** - Pay when service is completed
3. **UPI** - Indian Unified Payments Interface (INR)

## UPI Payment Integration

### Merchant UPI ID
```
sridharkumaresan4-1@okicici
```

### Test Payment Amount
- **Amount**: ₹0.20 (20 paise - for testing purposes)
- **Currency**: Indian Rupees (INR)

### How UPI Payment Works in the App

1. **User selects UPI payment method** on PaymentScreen
2. **User enters their UPI ID** (e.g., username@bank)
3. **Payment details are validated** for proper UPI format
4. **Payment is processed** through PaymentService
5. **Payment record is stored** in Firestore with user's UPI ID
6. **ServiceConfirmationScreen displays** booking confirmation
7. **Booking details are stored** in Firebase with payment information

### UPI Validation

The app validates UPI IDs using the following regex pattern:
```
^[a-zA-Z0-9._-]+@[a-zA-Z]+$
```

Valid UPI ID formats:
- `username@okicici`
- `john.doe@icici`
- `user_123@hdfc`
- `person-name@axis`

### File Structure

```
lib/
├── services/
│   ├── payment_services.dart          # NEW: Payment processing service
│   └── bookings_services.dart         # Booking management service
├── screens/
│   └── caregiver_details_page/
│       ├── payment_page.dart          # UPDATED: Payment method selection
│       ├── confirmbook_page.dart      # Date/time/hours selection
│       └── serviceconfirmation_page.dart  # Booking confirmation
└── ...
```

## Payment Service Methods

### PaymentService Class

```dart
// Process UPI Payment
Future<Map<String, dynamic>> processUPIPayment({
  required String userUpiId,
  required double amount,
  required String bookingId,
})

// Process PayPal Payment
Future<Map<String, dynamic>> processPayPalPayment({
  required String cardHolderName,
  required String cardNumber,
  required String expiryDate,
  required String cvv,
  required double amount,
  required String bookingId,
})

// Process Cash on Delivery
Future<Map<String, dynamic>> processCashPayment({
  required double amount,
  required String bookingId,
})

// Update Payment Status
Future<void> updatePaymentStatus(String paymentId, String newStatus)

// Get Payment by ID
Future<Map<String, dynamic>?> getPaymentById(String paymentId)

// Get User Payments
Future<List<Map<String, dynamic>>> getUserPayments()

// Generate UPI Deep Link
String generateUPIDeepLink({
  required String userUpiId,
  required double amount,
  required String transactionId,
})
```

## Firestore Data Structure

### Payments Collection: `payments/`

```json
{
  "paymentId": "document-id",
  "userId": "firebase-user-id",
  "userEmail": "user@example.com",
  "bookingId": "booking-reference",
  "paymentMethod": "upi|paypal|cash",
  "amount": 0.2,
  "currency": "INR|USD",
  "status": "pending|completed|failed",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp",
  
  // For UPI payments
  "userUpiId": "username@bankname",
  "merchantUpiId": "sridharkumaresan4-1@okicici",
  
  // For PayPal payments
  "cardHolderName": "John Doe",
  "cardNumber": "**** **** **** 1234",  // Masked
  "expiryDate": "1225",
  "cvv": "***",  // Masked
  
  // For Cash payments
  "paymentType": "cash_on_delivery"
}
```

### Bookings Collection: `bookings/`

```json
{
  "bookingId": "document-id",
  "userId": "firebase-user-id",
  "caregiverName": "John Smith",
  "serviceTitle": "Professional Home Nurse",
  "servicePrice": 50.0,
  "selectedDate": "2024-03-15",
  "selectedTime": "10:00 AM",
  "selectedHours": 2,
  "paymentMethod": "upi|paypal|cash",
  "totalAmount": 100.0,
  "status": "pending|confirmed|completed|cancelled",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp",
  
  // Payment details (conditionally stored)
  "paymentDetails": {
    "method": "upi",
    "upiId": "username@bankname"
    // or
    "method": "paypal",
    "cardLast4": "1234"
    // or
    "method": "cash"
  }
}
```

## Firestore Security Rules

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to create and read their own payments
    match /payments/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
    }
    
    // Allow authenticated users to create and read their own bookings
    match /bookings/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
    }
  }
}
```

## Payment Flow

```
ConfirmBookingScreen (Select Date/Time/Hours)
          ↓
     PaymentScreen (Select Payment Method)
          ↓
   PaymentService (Process Payment)
          ↓
ServiceConfirmationScreen (Display Booking Confirmation)
          ↓
    BookingService (Store Booking in Firestore)
          ↓
  MyBookingsPage (Display Booking Details)
```

## Testing the UPI Payment

### Test Case 1: Basic UPI Payment
1. Open the app and select a caregiver service
2. Click "Book Now"
3. Select date, time, and duration on ConfirmBookingScreen
4. Click "Next" to go to PaymentScreen
5. Select "Pay with UPI"
6. Enter your UPI ID (e.g., `testuser@okicici`)
7. Verify merchant UPI ID is displayed: `sridharkumaresan4-1@okicici`
8. Verify amount is ₹0.20
9. Click "Proceed"
10. Payment should be processed and stored in Firestore
11. Booking confirmation should be displayed

### Test Case 2: UPI Validation
1. Select UPI payment method
2. Try entering invalid UPI IDs:
   - `testuser` (missing @)
   - `test@` (incomplete)
   - `test@@okicici` (double @)
3. App should show error: "Please enter a valid UPI ID (e.g., username@bankname)"
4. Enter valid UPI ID: `testuser@okicici`
5. Should proceed successfully

### Test Case 3: Missing UPI ID
1. Select UPI payment method
2. Leave UPI ID field empty
3. Click "Proceed"
4. App should show error: "Please enter a valid UPI ID"

## PayPal Integration Note

PayPal payments remain available and use USD currency:
- Card details are masked before storage
- Expiry date format: MMYY (e.g., 1225 for Dec 2025)
- CVV is masked with *** in Firestore

## Cash on Delivery

For cash payments:
- No payment details required upfront
- Payment status starts as "pending"
- Status updated to "completed" when payment is received
- Caregiver confirms payment collection in the app

## Pricing Configuration

Currently configured:
- **Base Service Price**: ₹0.2 (from service definition)
- **Delivery Fee**: $15.00 / ₹250.00 (depends on payment method)
- **Currency Conversion**: Handled at display level

To modify:
1. Update `PaymentService.BASE_PRICE` for default amount
2. Update `PaymentService.DELIVERY_FEE` for service fee
3. Update service prices in caregiver profiles

## Error Handling

The payment service handles these error cases:
- Invalid UPI ID format
- Invalid card numbers
- Expired credit cards
- Invalid CVV format
- User not authenticated
- Firestore permission errors

All errors are displayed to users via SnackBar notifications.

## Future Enhancements

1. **Real Payment Gateway Integration**
   - Integrate with actual UPI provider API
   - Implement PayPal SDK for real transactions
   - Add payment webhook handling

2. **Payment Notifications**
   - Email receipts
   - SMS payment confirmation
   - Push notifications for payment status

3. **Refund Management**
   - Process refunds for cancelled bookings
   - Partial refund support
   - Refund status tracking

4. **Payment Analytics**
   - Dashboard showing payment statistics
   - Revenue reports by payment method
   - Daily/weekly/monthly trends

5. **Multi-Currency Support**
   - Dynamic currency conversion
   - Support for international payments
   - Currency selection in user preferences

## Troubleshooting

### Payment not appearing in Firestore
- Check Firestore security rules
- Verify user is authenticated
- Check browser console for errors

### UPI ID validation failing
- Ensure format is `username@bankname`
- No spaces allowed
- Special characters supported: `.`, `_`, `-`

### Amount not displaying correctly
- Check if payment method changed after amount display
- Currency symbol updates based on selected method
- Clear app cache if amount still incorrect

## Support

For issues or questions about UPI payment integration:
1. Check Firestore logs in Firebase Console
2. Review logs in Flutter debugger
3. Verify Firestore security rules
4. Ensure required dependencies are installed

## References

- [UPI Payment Basics](https://upiappspayments.com/)
- [PayPal Integration Guide](https://developer.paypal.com/)
- [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Flutter Firebase](https://firebase.flutter.dev/)
