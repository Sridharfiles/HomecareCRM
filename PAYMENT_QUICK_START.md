# UPI Payment Integration - Quick Start Guide

## What's New ✨

The HomecareCRM app now supports **UPI payments** with professional payment processing infrastructure.

### Payment Details
- **Merchant UPI ID**: `sridharkumaresan4-1@okicici`
- **Test Amount**: ₹0.20 (Indian Rupees)
- **Payment Methods**: UPI, PayPal (Card), Cash on Delivery

---

## 📱 Payment Flow

```
1. Select Caregiver Service
   ↓
2. Confirm Booking (Date, Time, Hours)
   ↓
3. Choose Payment Method (UPI / PayPal / Cash)
   ↓
4. Enter Payment Details (UPI ID / Card Details)
   ↓
5. Review & Process Payment
   ↓
6. Booking Confirmation
   ↓
7. Track Booking Status
```

---

## How to Test UPI Payment

### Step 1: Navigate to Payment Screen
1. Open the app
2. Select any caregiver service
3. Click "Book Now"

### Step 2: Confirm Booking Details
1. Select your preferred **date**
2. Choose a **time slot** (Morning/Afternoon/Evening)
3. Select **hours** (1-8 hours)
4. Click "Next"

### Step 3: Choose UPI Payment
1. On PaymentScreen, tap "Pay with UPI" option
2. The form below selected methods will show:
   - **Your UPI ID** input field
   - **Merchant UPI ID**: `sridharkumaresan4-1@okicici` (displays where payment goes)
   - **Payment Amount**: ₹0.20

### Step 4: Enter Your UPI ID
Enter a valid UPI ID in format: `username@bankname`

**Valid Examples:**
- `azhar123@okhdfcbank`
- `john.doe@ikici`
- `mobile_payment@ybl`
- `person_name@airtel`

### Step 5: Process Payment
1. Verify the amount: **₹0.20**
2. Click "Proceed" button
3. Wait for payment processing (shows loading indicator)
4. On success: See booking confirmation

---

## 💾 What Gets Stored in Firebase

### Payment Information Stored
```
User UPI ID: Your entered UPI ID
Merchant UPI: sridharkumaresan4-1@okicici
Amount: ₹0.20
Status: Stored for records
```

### Booking Information Stored
```
Service Details: Caregiver name, service type
Booking Details: Date, time, duration
Payment Method: UPI
User ID: For tracking
```

---

## ✅ Validation Rules

### UPI ID Must:
- ✅ Contain exactly one `@` symbol
- ✅ Have characters before @: letters, numbers, dots, dashes, underscores
- ✅ Have characters after @: letters (bank name)
- ✅ NOT be empty

### UPI ID Examples:
| Valid | Invalid |
|-------|---------|
| `user@icici` | `user` (missing @) |
| `john.doe@hdfc` | `john@@hdfc` (double @) |
| `person_123@axis` | `@okaxis` (no username) |
| `xyz-abc@ybl` | `xyz@abc@upi` (multiple @) |

### Error Messages You Might See:
```
"Please enter a valid UPI ID (e.g., username@bankname)"
→ Check your UPI ID format

"Please select a payment method"
→ Select UPI from payment options

"Error processing payment: User not authenticated"
→ Make sure you're logged in
```

---

## 🔒 Security Features

✅ **UPI ID Validation**: Ensures proper format
✅ **Firebase Authentication**: Only logged-in users can pay
✅ **Firestore Rules**: Users can only see their own payments
✅ **Masked Data**: Card numbers and CVV stored as masked (***) in database
✅ **Timestamp Tracking**: All payments logged with creation/update time

---

## 📊 Payment Service Architecture

### Three Payment Methods:

**1. UPI (Indian Rupees)**
- Format: `username@bankname`
- Amount: ₹0.20 (test)
- Merchant: sridharkumaresan4-1@okicici

**2. PayPal (USD)**
- Requires: Card holder name, card number, expiry, CVV
- Amount: Calculated in USD
- Status: Pending until verified

**3. Cash on Delivery (INR)**
- No upfront payment
- Pay when service completed
- Amount: ₹250+ (includes delivery fee)

---

## 🧪 Testing Checklist

- [ ] Can select UPI payment method
- [ ] UPI ID field appears when UPI selected
- [ ] Merchant UPI ID displays correctly
- [ ] Amount shows in ₹ (rupee symbol)
- [ ] Payment validates empty UPI ID
- [ ] Payment validates invalid formats (no @)
- [ ] Accepts valid UPI IDs (with @)
- [ ] Shows loading indicator during processing
- [ ] Payment saved in Firestore
- [ ] Can see booking confirmation
- [ ] Can track booking in MyBookings

---

## 📝 Code Structure

### New Files:
```
lib/services/payment_services.dart
  ├── PaymentService class
  ├── processUPIPayment()
  ├── processPayPalPayment()
  ├── processCashPayment()
  └── Validation methods
```

### Updated Files:
```
lib/screens/caregiver_details_page/payment_page.dart
  ├── Import PaymentService
  ├── UPI validation UI
  ├── Merchant UPI display
  └── Payment processing
```

---

## 🔧 Configuration

To change payment details, edit:

**PaymentService** (`lib/services/payment_services.dart`):
```dart
static const String MERCHANT_UPI_ID = 'sridharkumaresan4-1@okicici';
static const double BASE_PRICE = 0.2; // in rupees
static const double DELIVERY_FEE = 15.0; // in rupees
```

**Currency Display**:
```dart
String get currencySymbol {
  if (selectedPaymentMethod == 'upi') {
    return '₹'; // Indian Rupee
  }
  return '\$'; // US Dollar
}
```

---

## 🐛 Troubleshooting

### Issue: "UPI ID isn't valid"
**Solution**: Make sure UPI ID has format `username@bankname` with @ symbol

### Issue: Payment not appearing in Firestore
**Solution**: 
1. Check you're logged in
2. Check Firestore security rules
3. Verify user ID matches

### Issue: Amount showing wrong currency
**Solution**: Currency updates based on selected payment method. Toggle between UPI and other methods to see ₹ vs $

### Issue: Loading spinner doesn't disappear
**Solution**: Check Firebase connection, internet connectivity

---

## 📞 Support

For issues:
1. Check PAYMENT_INTEGRATION.md for detailed documentation
2. Review Firebase Console logs
3. Check Flutter debug console for error messages
4. Verify Firestore security rules are properly configured

---

## 🚀 Next Steps

1. ✅ Test UPI payment flow
2. ✅ Verify Firestore data storage
3. ⏳ Integrate with actual UPI payment gateway (coming soon)
4. ⏳ Add payment notifications via email/SMS
5. ⏳ Implement refund system
6. ⏳ Create payment analytics dashboard

---

## Files Reference

- **Service**: `lib/services/payment_services.dart` - Payment processing logic
- **UI**: `lib/screens/caregiver_details_page/payment_page.dart` - Payment form and UI
- **Booking**: `lib/services/bookings_services.dart` - Booking storage
- **Docs**: `PAYMENT_INTEGRATION.md` - Full technical documentation
- **This**: `PAYMENT_QUICK_START.md` - Quick reference guide

---

**Version**: 1.0
**Last Updated**: March 2026
**Status**: ✅ Ready for Testing
