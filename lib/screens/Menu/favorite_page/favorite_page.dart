import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homecarecrm/services/favorites_service.dart';
import 'package:homecarecrm/screens/caregiver_details_page/caregiver_details_page.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';

class FavoriteCaregiverScreen extends StatefulWidget {
  const FavoriteCaregiverScreen({super.key});

  @override
  State<FavoriteCaregiverScreen> createState() =>
      _FavoriteCaregiverScreenState();
}

class _FavoriteCaregiverScreenState extends State<FavoriteCaregiverScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _favoriteCaregivers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload favorites when returning to this page
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = "Please sign in to view favorites";
          _isLoading = false;
        });
        return;
      }

      print('DEBUG: Loading favorites for user: ${currentUser.uid}');

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Test direct Firebase query
      print('DEBUG: Testing direct Firebase query...');
      final directQuery =
          await FirebaseFirestore.instance
              .collection('favorites')
              .where('userId', isEqualTo: currentUser.uid)
              .get();

      print('DEBUG: Direct query found ${directQuery.docs.length} documents');
      for (var doc in directQuery.docs) {
        print('DEBUG: Direct doc data: ${doc.data()}');
      }

      List<Map<String, dynamic>> favorites =
          await _favoritesService.getFavorites();

      setState(() {
        _favoriteCaregivers = favorites;
        _isLoading = false;
      });

      print('DEBUG: Successfully loaded ${favorites.length} favorites');
    } catch (e) {
      print('ERROR: Failed to load favorites in UI: $e');
      print('ERROR TYPE: ${e.runtimeType}');

      setState(() {
        _errorMessage = "Failed to load favorites: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromFavorites(String caregiverId) async {
    try {
      await _favoritesService.removeFavorite(caregiverId);
      await _loadFavorites();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Removed from favorites")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error removing favorite: $e")));
    }
  }

  List<Map<String, dynamic>> get filteredCaregivers {
    return _favoriteCaregivers;
  }

  Future<void> _debugFirebase() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No user logged in')));
        return;
      }

      // Direct Firebase query
      final snapshot =
          await FirebaseFirestore.instance
              .collection('favorites')
              .where('userId', isEqualTo: currentUser.uid)
              .get();

      String debugInfo = 'Found ${snapshot.docs.length} favorites:\n';
      for (var doc in snapshot.docs) {
        debugInfo += '- ${doc.data()['name']} (${doc.id})\n';
      }

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Firebase Debug Info'),
              content: SingleChildScrollView(child: Text(debugInfo)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Firebase Error'),
              content: Text('Error: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Refresh button
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: _loadFavorites,
                  ),
                ),
              ],
            ),
          ),

          /// LIST
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : _favoriteCaregivers.isEmpty
                    ? const Center(child: Text("No favorites yet"))
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: _favoriteCaregivers.length,
                      itemBuilder: (context, index) {
                        final caregiver = _favoriteCaregivers[index];

                        return FavoriteCaregiverCard(
                          caregiver: caregiver,
                          onRemove: () {
                            _removeFromFavorites(caregiver['caregiverId']);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class FavoriteCaregiverCard extends StatelessWidget {
  final Map<String, dynamic> caregiver;
  final VoidCallback onRemove;

  const FavoriteCaregiverCard({
    super.key,
    required this.caregiver,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to service details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookPage(
                    service: ServiceModel(
                      imageUrl:
                          caregiver['imageUrl']?.startsWith('http') == true
                              ? caregiver['imageUrl']
                              : caregiver['imageUrl'] ??
                                  'assets/images/default.jpg',
                      title: caregiver['name'] ?? 'Unknown Service',
                      rating: (caregiver['rating'] ?? 0.0).toDouble(),
                      price: caregiver['price'] ?? 'Price not available',
                      location:
                          caregiver['location'] ?? 'Location not specified',
                      experience:
                          caregiver['subtitle'] ??
                          caregiver['experience'] ??
                          'Experience not specified',
                      description:
                          caregiver['description'] ??
                          'Professional caregiver service providing quality care and support.',
                      features:
                          caregiver['features'] ??
                          [
                            'Experienced and trained caregiver',
                            'Background verified',
                            'Compassionate and reliable',
                            'Flexible scheduling',
                          ],
                    ),
                  ),
            ),
          );
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              caregiver['imageUrl'] ?? "",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, size: 40);
              },
            ),
          ),
          title: Text(caregiver['name'] ?? "Unknown"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(caregiver['price'] ?? ""),
              if (caregiver['subtitle'] != null) Text(caregiver['subtitle']),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: onRemove,
          ),
        ),
      ),
    );
  }
}
