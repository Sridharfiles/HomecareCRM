import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // v7: Use GoogleSignIn.instance (singleton)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of Firebase auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google and force showing all available accounts
  Future<UserCredential?> signInWithGoogleShowAllAccounts() async {
    return signInWithGoogle(forceAccountPicker: true);
  }

  /// Sign in with Google (v7 API) - MANUAL FLOW TO AVOID AUTO-CANCEL
  /// Set [forceAccountPicker] to true to show all available Gmail accounts
  Future<UserCredential?> signInWithGoogle({bool forceAccountPicker = false}) async {
    try {
      if (kDebugMode) {
        print('📱 GoogleSignInService: Starting sign-in process...');
        print('📱 GoogleSignInService: Initializing Google Sign-In...');
        if (forceAccountPicker) {
          print('📱 GoogleSignInService: Force account picker enabled - signing out first...');
        }
      }

      // v7: Initialize first
      await _googleSignIn.initialize();

      // If force account picker is enabled, sign out first to clear cache
      if (forceAccountPicker) {
        try {
          await _googleSignIn.signOut();
          if (kDebugMode) {
            print('📱 GoogleSignInService: Signed out to show account picker...');
          }
        } catch (e) {
          if (kDebugMode) {
            print('📱 GoogleSignInService: Note: Sign out during account picker: $e');
          }
        }
      }

      if (kDebugMode) {
        print('📱 GoogleSignInService: Checking for cached account...');
      }

      // Try lightweight authentication first (cached account) - only if not forcing account picker
      GoogleSignInAccount? googleUser;
      if (!forceAccountPicker) {
        var result = _googleSignIn.attemptLightweightAuthentication();
        
        if (result is Future<GoogleSignInAccount?>) {
          googleUser = await result;
        } else {
          googleUser = result as GoogleSignInAccount?;
        }
      }

      // If no cached account, do full authentication
      if (googleUser == null) {
        if (kDebugMode) {
          print('📱 GoogleSignInService: No cached account, doing full authentication...');
        }
        
        try {
          // Authenticate will show account picker with all available Gmail accounts
          googleUser = await _googleSignIn.authenticate();
          
          if (kDebugMode) {
            print('📱 GoogleSignInService: ✅ User authenticated!');
            print('📱 GoogleSignInService: Email: ${googleUser!.email}');
          }
        } on GoogleSignInException catch (e) {
          if (kDebugMode) {
            print('📱 GoogleSignInService: GoogleSignInException: ${e.code.name}');
          }
          
          // Return null for cancellation, don't treat as error
          if (e.code == GoogleSignInExceptionCode.canceled) {
            return null;
          }
          rethrow;
        }
      } else {
        if (kDebugMode) {
          print('📱 GoogleSignInService: ✅ Using cached account!');
          print('📱 GoogleSignInService: Email: ${googleUser.email}');
        }
      }

      if (googleUser == null) {
        if (kDebugMode) {
          print('📱 GoogleSignInService: ❌ User cancelled sign-in');
        }
        return null;
      }

      if (kDebugMode) {
        print('📱 GoogleSignInService: Getting authentication token...');
      }

      // Get authentication
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (kDebugMode) {
        print('📱 GoogleSignInService: Getting authorization for scopes...');
      }

      // Get authorization with required scopes
      final authorization = await googleUser.authorizationClient.authorizationForScopes(
        ['email', 'profile'],
      );

      if (kDebugMode) {
        print('📱 GoogleSignInService: Creating Firebase credential...');
      }

      // Create Firebase credential using the authorization token
      final String? accessToken = authorization?.accessToken;
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      if (kDebugMode) {
        print('📱 GoogleSignInService: Signing in to Firebase...');
      }

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (kDebugMode) {
        print('📱 GoogleSignInService: ✅✅✅ SUCCESS! ✅✅✅');
        print('📱 GoogleSignInService: Firebase User email: ${userCredential.user?.email}');
        print('📱 GoogleSignInService: Firebase User uid: ${userCredential.user?.uid}');
      }

      return userCredential;
    } on GoogleSignInException catch (e) {
      if (kDebugMode) {
        print('📱 GoogleSignInService: ❌ GoogleSignInException: ${e.code.name}');
      }
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('📱 GoogleSignInService: ❌ FirebaseAuthException: ${e.code}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('📱 GoogleSignInService: ❌ Unexpected error: $e');
      }
      rethrow;
    }
  }

  /// Sign out from Google and Firebase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      if (kDebugMode) {
        print('User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign out: $e');
      }
      rethrow;
    }
  }

  /// Disconnect Google account (revoke access)
  Future<void> disconnectGoogle() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();

      if (kDebugMode) {
        print('Google account disconnected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error disconnecting Google account: $e');
      }
      rethrow;
    }
  }

  /// Check if Firebase user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  /// Get user display name
  String? getUserDisplayName() {
    return _auth.currentUser?.displayName;
  }

  /// Get user email
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Get user photo URL
  String? getUserPhotoUrl() {
    return _auth.currentUser?.photoURL;
  }

  /// Get user ID
  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  /// Get detailed user information
  Map<String, dynamic>? getUserInfo() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
      'isAnonymous': user.isAnonymous,
      'metadata': {
        'creationTime': user.metadata.creationTime?.toIso8601String(),
        'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
      },
    };
  }

  /// Silent sign-in (v7 API)
  Future<UserCredential?> silentSignIn() async {
    try {
      await _googleSignIn.initialize();

      final result = _googleSignIn.attemptLightweightAuthentication();

      GoogleSignInAccount? googleUser;
      if (result is Future<GoogleSignInAccount?>) {
        googleUser = await result;
      } else {
        googleUser = result as GoogleSignInAccount?;
      }

      if (googleUser == null) {
        if (kDebugMode) {
          print('Silent sign-in failed — no cached account');
        }
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get authorization with required scopes
      final authorization = await googleUser.authorizationClient.authorizationForScopes(
        ['email', 'profile'],
      );

      final String? accessToken = authorization?.accessToken;
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (kDebugMode) {
        print('Silent sign-in successful: ${userCredential.user?.email}');
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error during silent sign-in: $e');
      }
      return null;
    }
  }
}
