import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:homecarecrm/screens/caregiver_details_page/caregiver_details_page.dart';

import 'package:homecarecrm/screens/home_page/service_card.dart';

import 'package:homecarecrm/screens/Menu/search_page/auto_parts_search_screen.dart';

import 'package:homecarecrm/services/favorites_service.dart';

// Top Caregivers data model
class TopCaregiver {
  final String name;
  final double rating;
  final int reviews;
  final String location;
  final String image;
  final int price;

  TopCaregiver({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': 'top_${name.toLowerCase().replaceAll(' ', '_')}',
      'name': name,
      'subtitle': '$reviews reviews • $location',
      'rating': rating,
      'price': '\$$price/hr',
      'isFree': false,
      'imageUrl': image,
      'category': 'Top Caregiver',
      'reviews': reviews,
      'location': location,
    };
  }
}

// Sample top caregivers data
final List<TopCaregiver> topCaregivers = [
  TopCaregiver(
    name: 'Janefa Cooper',
    rating: 4.9,
    reviews: 125,
    location: '123 Main St, New York, NY 10001',
    image: 'https://picsum.photos/seed/janefa/200/200.jpg',
    price: 120,
  ),
  TopCaregiver(
    name: 'Nordan Obhsar',
    rating: 4.3,
    reviews: 111,
    location: '456 Oak Ave, Los Angeles, CA 90001',
    image: 'https://picsum.photos/seed/nordan/200/200.jpg',
    price: 100,
  ),
  TopCaregiver(
    name: 'Analds Devids',
    rating: 4.6,
    reviews: 155,
    location: '789 Pine Rd, Chicago, IL 60601',
    image: 'https://picsum.photos/seed/analds/200/200.jpg',
    price: 150,
  ),
  TopCaregiver(
    name: 'Sarah Johnson',
    rating: 4.8,
    reviews: 98,
    location: '321 Elm St, Houston, TX 77001',
    image: 'https://picsum.photos/seed/sarah/200/200.jpg',
    price: 110,
  ),
  TopCaregiver(
    name: 'Michael Chen',
    rating: 4.7,
    reviews: 142,
    location: '654 Maple Dr, Phoenix, AZ 85001',
    image: 'https://picsum.photos/seed/michael/200/200.jpg',
    price: 130,
  ),
  TopCaregiver(
    name: 'Emma Wilson',
    rating: 4.5,
    reviews: 89,
    location: '987 Cedar Ln, Philadelphia, PA 19101',
    image: 'https://picsum.photos/seed/emma/200/200.jpg',
    price: 105,
  ),
  TopCaregiver(
    name: 'David Martinez',
    rating: 4.9,
    reviews: 176,
    location: '456 Beach Blvd, Miami, FL 33101',
    image: 'https://picsum.photos/seed/david/200/200.jpg',
    price: 125,
  ),
  TopCaregiver(
    name: 'Lisa Anderson',
    rating: 4.4,
    reviews: 93,
    location: '789 Mountain View, Denver, CO 80201',
    image: 'https://picsum.photos/seed/lisa/200/200.jpg',
    price: 115,
  ),
];

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

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredCaregivers = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    // Combine both caregivers and top caregivers
    final allCaregivers = <Map<String, dynamic>>[];
    allCaregivers.addAll(caregivers);
    allCaregivers.addAll(topCaregivers.map((tc) => tc.toMap()).toList());

    _filteredCaregivers = allCaregivers;

    _searchController.addListener(_onSearchChanged);

    _loadFavoriteStatuses();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);

    _searchController.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        // Reset to combined list
        final allCaregivers = <Map<String, dynamic>>[];
        allCaregivers.addAll(caregivers);
        allCaregivers.addAll(topCaregivers.map((tc) => tc.toMap()).toList());
        _filteredCaregivers = allCaregivers;
        _isSearching = false;
      } else {
        _isSearching = true;

        // Combine both caregivers and top caregivers for searching
        final allCaregivers = <Map<String, dynamic>>[];
        allCaregivers.addAll(caregivers);
        allCaregivers.addAll(topCaregivers.map((tc) => tc.toMap()).toList());

        _filteredCaregivers =
            allCaregivers.where((caregiver) {
              final name = (caregiver['name'] as String).toLowerCase();
              final category = (caregiver['category'] as String).toLowerCase();
              final subtitle = (caregiver['subtitle'] as String).toLowerCase();
              final location = caregiver['location'] as String? ?? '';

              return name.contains(query) ||
                  category.contains(query) ||
                  subtitle.contains(query) ||
                  location.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  Future<void> _loadFavoriteStatuses() async {
    User? currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) return;

    // Load favorite status for all caregivers (original + top)
    final allCaregivers = <Map<String, dynamic>>[];
    allCaregivers.addAll(caregivers);
    allCaregivers.addAll(topCaregivers.map((tc) => tc.toMap()).toList());

    for (var caregiver in allCaregivers) {
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

  Widget _buildSearchChip(String suggestion) {
    return ActionChip(
      label: Text(
        suggestion,
        style: const TextStyle(fontSize: 12, color: Color(0xFF0A6CFF)),
      ),
      backgroundColor: const Color(0xFFE8F2FF),
      onPressed: () {
        _searchController.text = suggestion;
      },
    );
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF8A8A8A),
                      size: 20,
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFF8A8A8A),
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                            : null,
                    hintText: 'Search caregivers...',
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

            // Search Results Header
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      '${_filteredCaregivers.length} ${_filteredCaregivers.length == 1 ? 'caregiver' : 'caregivers'} found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (_searchController.text.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0A6CFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Caregiver List
            Expanded(
              child:
                  _filteredCaregivers.isEmpty && _isSearching
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No caregivers found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching for:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildSearchChip('Sarah'),
                                _buildSearchChip('Janefa'),
                                _buildSearchChip('Medical'),
                                _buildSearchChip('Companion'),
                                _buildSearchChip('Top Caregiver'),
                              ],
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredCaregivers.length,
                        itemBuilder: (context, index) {
                          final caregiver = _filteredCaregivers[index];
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
                    child:
                        imageUrl.startsWith('http')
                            ? Image.network(
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
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 54,
                                  height: 54,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                            : Image.asset(
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
                        // Create a ServiceModel for caregiver
                        final service = ServiceModel(
                          id:
                              'search_result_${DateTime.now().millisecondsSinceEpoch}',
                          title: name,
                          description:
                              'Professional caregiving services with $subtitle years of experience',
                          price: price,
                          imageUrl: imageUrl,
                          rating: rating,
                          location: 'Available',
                          experience: 'Experienced',
                          features: ['Professional Care', 'Background Checked'],
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
                      child: Text('Book Now', style: TextStyle(fontSize: 14)),
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
