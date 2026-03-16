import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/services/notification_service.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  String? get userId => _auth.currentUser?.uid;

  /// Add to favorites
  Future<void> addFavorite(Map<String, dynamic> service) async {
    if (userId == null) {
      print('ERROR: No user logged in for addFavorite');
      return;
    }

    print('DEBUG: Adding favorite for user: $userId');
    print('DEBUG: Service data: $service');

    try {
      await _firestore
          .collection("favorites")
          .doc("${userId}_${service['id']}")
          .set({
            "userId": userId,
            "caregiverId": service['id'],
            "name": service['name'],
            "subtitle": service['subtitle'],
            "rating": service['rating'],
            "price": service['price'],
            "isFree": service['isFree'],
            "imageUrl": service['imageUrl'],
            "category": service['category'],
            "addedAt": FieldValue.serverTimestamp(),
          });

      print('SUCCESS: Favorite added successfully');

      // Create notification for adding to favorites
      try {
        await _notificationService.createServiceNotification(
          type: NotificationType.serviceAddedToFavorites,
          serviceId: service['id'].toString(),
          serviceTitle: service['name'] ?? 'Service',
        );
        print('🔔 Favorite added notification created');
      } catch (notificationError) {
        print('⚠️ Error creating favorite notification: $notificationError');
        // Don't rethrow notification error as favorite was added successfully
      }
    } catch (e) {
      print('ERROR: Failed to add favorite: $e');
      print('ERROR TYPE: ${e.runtimeType}');

      if (e.toString().contains('permission-denied')) {
        print(
          'ERROR: Firebase rules are blocking access - update Firestore rules!',
        );
      }

      rethrow;
    }
  }

  /// Remove favorite
  Future<void> removeFavorite(String caregiverId) async {
    if (userId == null) return;

    await _firestore
        .collection("favorites")
        .doc("${userId}_$caregiverId")
        .delete();
  }

  /// Check if favorite
  Future<bool> isFavorite(String caregiverId) async {
    if (userId == null) return false;

    final doc =
        await _firestore
            .collection("favorites")
            .doc("${userId}_$caregiverId")
            .get();

    return doc.exists;
  }

  /// Toggle favorite
  Future<bool> toggleFavorite(Map<String, dynamic> service) async {
    bool exists = await isFavorite(service['id']);

    if (exists) {
      await removeFavorite(service['id']);
      return false;
    } else {
      await addFavorite(service);
      return true;
    }
  }

  /// Get all favorites
  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      if (userId == null) {
        print('DEBUG: No user logged in for getFavorites');
        return [];
      }

      print('DEBUG: Fetching favorites for user: $userId');

      final snapshot =
          await _firestore
              .collection("favorites")
              .where("userId", isEqualTo: userId)
              .get();

      print('DEBUG: Found ${snapshot.docs.length} favorites');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data["docId"] = doc.id;
        print('DEBUG: Favorite document ID: ${doc.id}');
        print('DEBUG: Favorite data: $data');
        print('DEBUG: Favorite name: ${data['name']}');
        print('DEBUG: Favorite price: ${data['price']}');
        return data;
      }).toList();
    } catch (e) {
      print('ERROR: Failed to get favorites: $e');
      print('ERROR TYPE: ${e.runtimeType}');

      // Check for permission denied
      if (e.toString().contains('permission-denied')) {
        print(
          'ERROR: Firebase rules are blocking access - update Firestore rules!',
        );
      }

      return [];
    }
  }

  /// Stream favorites (for realtime UI)
  Stream<List<Map<String, dynamic>>> streamFavorites() {
    if (userId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("favorites")
        .where("userId", isEqualTo: userId)
        .orderBy("addedAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data["docId"] = doc.id;
            return data;
          }).toList();
        });
  }
}
