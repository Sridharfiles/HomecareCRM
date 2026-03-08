import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/caregiver_details_page/caregiver_details_page.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';
import 'package:homecarecrm/screens/Menu/search_page/auto_parts_search_screen.dart';
import 'package:homecarecrm/services/favorites_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// Sample caregivers data with IDs
final List<Map<String, dynamic>> caregivers = [
  {
    'id': 'caregiver_1',
    'name': 'Sarah Johnson',
    'subtitle': '5 years experience',
    'rating': 4.8,
    'price': '\$25/hr',
    'isFree': false,
    'imageUrl': 'assets/images/caregiver1.jpg',
    'category': 'Companion Care',
  },
  {
    'id': 'caregiver_2',
    'name': 'Michael Chen',
    'subtitle': '3 years experience',
    'rating': 4.6,
    'price': '\$30/hr',
    'isFree': false,
    'imageUrl': 'assets/images/caregiver2.jpg',
    'category': 'Medical Care',
  },
  {
    'id': 'caregiver_3',
    'name': 'Emily Davis',
    'subtitle': '7 years experience',
    'rating': 4.9,
    'price': '\$35/hr',
    'isFree': false,
    'imageUrl': 'assets/images/caregiver3.jpg',
    'category': 'Companion Care',
  },
];

class _SearchScreenState extends State<SearchScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Set<String> _favoriteCaregivers = <String>{};

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatuses();
  }

  Future<void> _loadFavoriteStatuses() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return;

    // Load favorite status for each caregiver
    for (var caregiver in caregivers) {
      bool isFavorite = await _favoritesService.isFavorite(
        caregiver['id'] ?? caregiver['name'],
      );
      if (isFavorite) {
        _favoriteCaregivers.add(caregiver['id'] ?? caregiver['name']);
      }
    }
    setState(() {});
  }

  Future<void> _toggleFavorite(Map<String, dynamic> caregiver) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to add favorites'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      String caregiverId = caregiver['id'] ?? caregiver['name'];

      print('DEBUG: Attempting to toggle favorite for: ${caregiver['name']}');
      print('DEBUG: Caregiver data: $caregiver');
      print('DEBUG: Caregiver ID: $caregiverId');

      bool isNowFavorite = await _favoritesService.toggleFavorite(caregiver);

      print('DEBUG: Toggle result: $isNowFavorite');

      setState(() {
        if (isNowFavorite) {
          _favoriteCaregivers.add(caregiverId);
        } else {
          _favoriteCaregivers.remove(caregiverId);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowFavorite
                ? '${caregiver['name']} added to favorites'
                : '${caregiver['name']} removed from favorites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('ERROR: Failed to toggle favorite: $e');
      print('ERROR TYPE: ${e.runtimeType}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating favorites: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A6CFF),
        elevation: 2,
        centerTitle: true,
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF8A8A8A),
                      size: 20,
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Color(0xFF8A8A8A),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Caregiver List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: caregivers.length,
                itemBuilder: (context, index) {
                  final caregiver = caregivers[index];
                  return CaregiverCard(
                    name: caregiver['name'],
                    subtitle: caregiver['subtitle'],
                    rating: caregiver['rating'],
                    price: caregiver['price'],
                    isFree: caregiver['isFree'],
                    imageUrl: caregiver['imageUrl'],
                    isFavorite: _favoriteCaregivers.contains(
                      caregiver['id'] ?? caregiver['name'],
                    ),
                    onFavoriteToggle: () => _toggleFavorite(caregiver),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to Auto Parts Search Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AutoPartsSearchScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A6CFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class CaregiverCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final double rating;
  final String price;
  final bool isFree;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const CaregiverCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.price,
    required this.isFree,
    required this.imageUrl,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Main content row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Circular image
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      imageUrl,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey[400],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Right side - Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and price row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212529),
                              ),
                            ),
                          ),

                          // Price
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isFree
                                      ? const Color(0xFF2ECC71)
                                      : const Color(0xFF0A6CFF),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6C757D),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Rating row
                      Row(
                        children: [
                          // Star icons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: const Color(0xFF0A6CFF),
                              );
                            }),
                          ),

                          const SizedBox(width: 6),

                          // Rating text
                          Text(
                            '($rating)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C757D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                // Favorite button
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),

                const SizedBox(width: 8),

                // Cancel button
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle cancel action
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0A6CFF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF0A6CFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Book button
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        // Create a ServiceModel for the caregiver
                        final service = ServiceModel(
                          title: name,
                          description:
                              'Professional caregiving services with $subtitle years of experience',
                          price: price,
                          imageUrl: imageUrl,
                          rating: rating,
                          location: 'Available',
                          experience: '$subtitle years',
                          features: [
                            'Professional Care',
                            'Background Checked',
                            'Experienced',
                          ],
                        );

                        // Navigate to BookPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookPage(service: service),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A6CFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Book',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
