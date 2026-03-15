import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get current user display name
  String get currentUserName {
    final user = _auth.currentUser;
    if (user != null) {
      return user!.displayName ?? user!.email ?? 'Anonymous User';
    }
    return 'Anonymous User';
  }

  // Add a new review to Firestore
  Future<void> addReview({
    required String category,
    required String reviewText,
    required String userId,
    required String userName,
  }) async {
    try {
      await _firestore.collection('reviews').add({
        'category': category,
        'reviewText': reviewText,
        'userId': userId,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Review added successfully');
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    }
  }

  // Get all reviews for a specific category
  Future<List<Map<String, dynamic>>> getReviewsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('reviews')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  // Get all reviews by current user
  Future<List<Map<String, dynamic>>> getUserReviews() async {
    try {
      final querySnapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting user reviews: $e');
      return [];
    }
  }

  // Get all reviews as a stream for real-time updates
  Stream<List<Map<String, dynamic>>> getAllReviews() {
    return _firestore
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();
      print('Review deleted successfully');
    } catch (e) {
      print('Error deleting review: $e');
      rethrow;
    }
  }

  // Stream reviews for a specific category (real-time updates)
  Stream<List<Map<String, dynamic>>> streamReviewsByCategory(String category) {
    return _firestore
        .collection('reviews')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // Stream reviews by current user (real-time updates)
  Stream<List<Map<String, dynamic>>> streamUserReviews() {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }
}
