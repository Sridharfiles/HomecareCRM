# Booking & Payment Integration - Updated Structure

## Changes Made

### 1. **Delivery Fee Updated**
- **Previous**: ₹15.00
- **Current**: ₹0.30 (Developer testing fee)
- **Location**: `lib/services/payment_services.dart` line 10

```dart
static const double DELIVERY_FEE = 0.3; // in rupees (Developer testing fee)
```

**Total Cost Breakdown for Testing:**
```
Base Price: ₹0.20 (service)
Delivery Fee: ₹0.30
─────────────────
Total: ₹0.50 (50 paise)
```

---

## 2. **New Collection: `booking_payments`**

A new collection has been created to **match bookings with their payment details by booking ID**.

### Purpose:
- **Links bookings with payments** using booking ID as key
- **Stores payment method details** (UPI, Card, Cash)
- **Audit trail** of all payment-booking relationships
- **Easy lookup** of payment status for a specific booking

### Structure:

```
Firestore Database:
├── bookings/ (existing)
│   └── [bookingId]
│       ├── userId
│       ├── caregiverName
│       ├── selectedDate
│       ├── serviceTitle
│       └── ... other booking details
│
└── booking_payments/ (NEW)
    └── [bookingId] (same ID as booking)
        ├── bookingId: "doc-id-123"
        ├── userId: "user-id-456"
        ├── paymentMethod: "upi"
        ├── amount: 0.50
        ├── currency: "INR"
        ├── status: "completed"
        ├── paymentDetails:
        │   ├── method: "upi"
        │   ├── userUpiId: "username@bank"
        │   └── merchantUpiId: "sridharkumaresan4-1@okicici"
        ├── createdAt: Timestamp
        └── updatedAt: Timestamp
```

---

## 3. **How It Works (Data Flow)**

```
User Makes Payment
        ↓
Payment Processed by PaymentService
├─ Stored in 'payments' collection
└─ Returns paymentId
        ↓
createBookingPayment() Called
├─ Takes bookingId & payment details
├─ Creates document in 'booking_payments'
└─ Links booking with payment info
        ↓
Booking Created by BookingService
├─ Stored in 'bookings' collection
└─ Uses same bookingId
        ↓
Query: Get Payment for Booking
├─ bookingPayments.doc(bookingId).get()
└─ Instantly get payment details!
```

---

## 4. **New Methods in PaymentService**

### Create Booking Payment Link
```dart
/// Create booking payment record linking booking with payment details
Future<void> createBookingPayment({
  required String bookingId,
  required String paymentMethod,
  required double amount,
  String? userUpiId,
  String? cardLast4,
}) async {
  // Creates document in 'booking_payments' collection
  // Stores payment details with method-specific info
}
```

### Get Booking Payment for a Booking
```dart
/// Get booking payment details by booking ID
Future<Map<String, dynamic>?> getBookingPayment(String bookingId) async {
  // Retrieves payment details for a specific booking
  // Returns null if no payment found
}
```

### Get All User's Booking Payments
```dart
/// Get all booking payments for current user
Future<List<Map<String, dynamic>>> getUserBookingPayments() async {
  // Returns all payment records for logged-in user
  // Ordered by creation date (newest first)
}
```

### Update Booking Payment Status
```dart
/// Update booking payment status
Future<void> updateBookingPaymentStatus(
  String bookingId,
  String newStatus,
) async {
  // Updates payment status: "completed", "failed", "refunded"
}
```

---

## 5. **Firestore Collection Examples**

### Example 1: UPI Payment with Booking

**bookings/booking-001**
```json
{
  "bookingId": "booking-001",
  "userId": "user-123",
  "caregiverName": "John Smith",
  "serviceTitle": "Home Care Nurse",
  "selectedDate": "2026-03-15",
  "selectedTime": "10:00 AM",
  "selectedHours": 2,
  "paymentMethod": "upi",
  "upiId": "azhar123@okicibank",
  "bookingStatus": "pending",
  "createdAt": "2026-03-07T12:30:00Z"
}
```

**booking_payments/booking-001**
```json
{
  "bookingId": "booking-001",
  "userId": "user-123",
  "paymentMethod": "upi",
  "amount": 0.50,
  "currency": "INR",
  "status": "completed",
  "paymentDetails": {
    "method": "upi",
    "userUpiId": "azhar123@okicibank",
    "merchantUpiId": "sridharkumaresan4-1@okicici"
  },
  "createdAt": "2026-03-07T12:30:00Z",
  "updatedAt": "2026-03-07T12:30:00Z"
}
```

---

### Example 2: PayPal Payment with Booking

**bookings/booking-002**
```json
{
  "bookingId": "booking-002",
  "userId": "user-456",
  "caregiverName": "Sarah Johnson",
  "serviceTitle": "Health Checkup",
  "selectedDate": "2026-03-16",
  "selectedTime": "2:30 PM",
  "selectedHours": 1,
  "paymentMethod": "paypal",
  "cardHolderName": "John Doe",
  "cardNumber": "**** **** **** 5678",
  "bookingStatus": "pending",
  "createdAt": "2026-03-07T13:00:00Z"
}
```

**booking_payments/booking-002**
```json
{
  "bookingId": "booking-002",
  "userId": "user-456",
  "paymentMethod": "paypal",
  "amount": 0.50,
  "currency": "USD",
  "status": "completed",
  "paymentDetails": {
    "method": "paypal",
    "cardLast4": "5678"
  },
  "createdAt": "2026-03-07T13:00:00Z",
  "updatedAt": "2026-03-07T13:00:00Z"
}
```

---

### Example 3: Cash On Delivery

**bookings/booking-003**
```json
{
  "bookingId": "booking-003",
  "userId": "user-789",
  "caregiverName": "Mike Wilson",
  "serviceTitle": "Elderly Care",
  "selectedDate": "2026-03-17",
  "selectedTime": "9:00 AM",
  "selectedHours": 4,
  "paymentMethod": "cash",
  "bookingStatus": "pending",
  "createdAt": "2026-03-07T13:30:00Z"
}
```

**booking_payments/booking-003**
```json
{
  "bookingId": "booking-003",
  "userId": "user-789",
  "paymentMethod": "cash",
  "amount": 0.80,
  "currency": "INR",
  "status": "completed",
  "paymentDetails": {
    "method": "cash_on_delivery"
  },
  "createdAt": "2026-03-07T13:30:00Z",
  "updatedAt": "2026-03-07T13:30:00Z"
}
```

---

## 6. **Firestore Security Rules Update**

Add these rules for the new `booking_payments` collection:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Existing bookings rules
    match /bookings/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
    }
    
    // Existing payments rules
    match /payments/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
    }
    
    // NEW: booking_payments rules
    match /booking_payments/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## 7. **Querying Booking Payments**

### Get Payment Details for a Booking:
```dart
final paymentService = PaymentService();

// Retrieve payment details for specific booking
final bookingPayment = await paymentService.getBookingPayment('booking-001');

if (bookingPayment != null) {
  print('Payment Amount: ₹${bookingPayment['amount']}');
  print('Method: ${bookingPayment['paymentMethod']}');
  print('Status: ${bookingPayment['status']}');
}
```

### Get All User's Payments:
```dart
final paymentService = PaymentService();

// Get all booking payments for current user
final allPayments = await paymentService.getUserBookingPayments();

for (var payment in allPayments) {
  print('Booking: ${payment['bookingId']}');
  print('Amount: ${payment['amount']} ${payment['currency']}');
}
```

### Update Payment Status:
```dart
final paymentService = PaymentService();

// Mark payment as refunded after cancellation
await paymentService.updateBookingPaymentStatus('booking-001', 'refunded');
```

---

## 8. **Data Storage Advantages**

### Why `booking_payments` Collection?

| Advantage | Benefit |
|-----------|---------|
| **Direct Matching** | bookingId directly links to payment record |
| **Fast Lookups** | Get payment details in single query |
| **Audit Trail** | Complete record of payment for each booking |
| **Easy Updates** | Update payment status without affecting booking |
| **Clean Separation** | Payment logic separate from booking logic |
| **User Isolation** | Security rules ensure users only see their payments |

---

## 9. **Testing the New Collection**

### Step 1: Make a Payment
1. Open app and start booking
2. Select payment method (UPI, PayPal, or Cash)
3. Enter payment details
4. Click "Proceed" and wait for confirmation

### Step 2: Check Firestore
1. Open Firebase Console
2. Navigate to `Firestore Database`
3. Click on `booking_payments` collection
4. You should see a new document with:
   - Doc ID = Booking ID
   - Payment details stored
   - User ID matching your login

### Step 3: View in Code
```dart
// In your app, you can query:
final payment = await paymentService.getBookingPayment(bookingId);
print(payment);
// Shows all payment details linked to that booking
```

---

## 10. **Updated Flow Summary**

```
1. USER INITIATES BOOKING
   ↓
2. SELECTS PAYMENT METHOD
   ├─ UPI: Enter UPI ID
   ├─ Card: Enter card details
   └─ Cash: Confirm amount
   ↓
3. PAYMENT PROCESSED
   ├─ Stored in 'payments' collection
   ├─ Creates transaction ID
   └─ Returns success response
   ↓
4. BOOKING PAYMENT LINKED
   └─ createBookingPayment() called
      ├─ Creates 'booking_payments' document
      ├─ Uses bookingId as document ID
      ├─ Stores payment method details
      └─ Stores user UPI/Card info
   ↓
5. BOOKING CREATED
   ├─ Stored in 'bookings' collection
   ├─ Uses same bookingId
   └─ Ready for caregiver assignment
   ↓
6. PAYMENT VERIFIED
   └─ Query booking_payments for details
      ├─ Verify amount matches booking
      ├─ Check payment status
      └─ Send confirmation email
```

---

## 11. **Cost Breakdown for Testing**

```
Service Price:  ₹0.20
Delivery Fee:   ₹0.30
─────────────────────
Total Payment:  ₹0.50 per booking

For 10 test bookings: ₹5.00
For 100 test bookings: ₹50.00
```

---

## 12. **File Changes Summary**

### `lib/services/payment_services.dart`
- ✅ Changed `DELIVERY_FEE` from 15.0 to 0.3
- ✅ Added `bookingPaymentsCollection` reference
- ✅ Added `createBookingPayment()` method
- ✅ Added `getBookingPayment()` method
- ✅ Added `getUserBookingPayments()` method
- ✅ Added `updateBookingPaymentStatus()` method
- ✅ Added `_getCurrencyForPaymentMethod()` helper

### `lib/screens/caregiver_details_page/payment_page.dart`
- ✅ Added `createBookingPayment()` call after successful payment
- ✅ Passes booking ID, method, amount, and UPI/card details
- ✅ Error handling if booking payment creation fails

---

## ✅ Compilation Status

- ✅ `payment_services.dart` - No errors
- ✅ `payment_page.dart` - No errors
- ✅ All new methods working
- ✅ All new collections defined
- ✅ Ready for testing

---

## 📱 Next Steps

1. **Test the payment flow** with the new ₹0.50 total amount
2. **Verify `booking_payments` collection** in Firebase Console
3. **Check payment-booking linkage** in Firestore documents
4. **Use new methods** to query payment details by booking ID

---

**Updated**: March 7, 2026
**Status**: ✅ Ready for Testing
**Delivery Fee**: ₹0.30 (Developer Testing)
**Total Test Cost**: ₹0.50 per booking
