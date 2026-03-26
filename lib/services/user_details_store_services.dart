import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDetailsStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Get Google profile data for current user
  Future<Map<String, dynamic>?> getGoogleProfileData() async {
    try {
      // Get the current Firebase user
      User? currentUser = _firebaseAuth.currentUser;
      
      if (currentUser != null) {
        return {
          'firstName': currentUser.displayName?.split(' ').first ?? '',
          'lastName': currentUser.displayName?.split(' ').skip(1).join(' ') ?? '',
          'email': currentUser.email,
          'profilePicture': currentUser.photoURL,
        };
      }
      return null;
    } catch (e) {
      print('Error getting Google profile data: $e');
      return null;
    }
  }

  /// Store user details to Firestore
  Future<void> storeUserDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required String countryCode,
    String district = '',
  }) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }

      await _firestore.collection('users').doc(currentUser.uid).set(
        {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
          'streetAddress': streetAddress,
          'city': city,
          'state': state,
          'zipCode': zipCode,
          'country': country,
          'district': district,
          'pincode': zipCode,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      print('User details stored successfully');
    } catch (e) {
      print('Error storing user details: $e');
      rethrow;
    }
  }

  /// Fetch user details from Firestore
  Future<Map<String, dynamic>?> fetchUserDetails() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }

      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error fetching user details: $e');
      rethrow;
    }
  }

  /// Update user details in Firestore
  Future<void> updateUserDetails({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required String countryCode,
    String district = '',
  }) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }

      await _firestore.collection('users').doc(currentUser.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country,
        'district': district,
        'pincode': zipCode,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('User details updated successfully');
    } catch (e) {
      print('Error updating user details: $e');
      rethrow;
    }
  }

  /// Get current user email from Firebase Auth
  Future<String?> getCurrentUserEmail() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      return currentUser?.email;
    } catch (e) {
      print('Error getting user email: $e');
      return null;
    }
  }

  /// Submit caregiver application and update user role
  Future<void> submitCaregiverApplication({
    required String idType,
    required String idFileName,
    required List<Map<String, dynamic>> certifications,
    required String? emergencyContact,
    required String applyLetter,
  }) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }

      final caregiverData = {
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'idType': idType,
        'idFileName': idFileName,
        'certifications': certifications,
        'emergencyContact': emergencyContact ?? '',
        'applyLetter': applyLetter,
        'status': 'pending',
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('caregivers').add(caregiverData);

      await _firestore.collection('users').doc(currentUser.uid).update({
        'role': 'pendingcaregiver',
        'caregiverApplicationSubmittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Caregiver application submitted successfully');
    } catch (e) {
      print('Error submitting caregiver application: $e');
      rethrow;
    }
  }
}
