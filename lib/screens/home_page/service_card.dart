// card.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/caregiver_details_page/caregiver_details_page.dart';
import 'package:homecarecrm/services/favorites_service.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel service;

  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isFavorite = false;
  final FavoritesService _favoritesService = FavoritesService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    String caregiverId = _generateCaregiverId();
    bool favorite = await _favoritesService.isFavorite(caregiverId);
    setState(() {
      isFavorite = favorite;
    });
  }

  String _generateCaregiverId() {
    // Generate a unique ID based on service title
    return widget.service.title.toLowerCase().replaceAll(' ', '_');
  }

  Future<void> _toggleFavorite() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to add favorites')),
      );
      return;
    }

    try {
      // Create caregiver data map
      Map<String, dynamic> caregiverData = {
        'id': _generateCaregiverId(),
        'name': widget.service.title,
        'subtitle': widget.service.experience,
        'rating': widget.service.rating,
        'price': widget.service.price,
        'isFree': widget.service.price.toLowerCase().contains('free'),
        'imageUrl': widget.service.imageUrl,
        'category': 'Home Care', // Default category
      };

      bool isNowFavorite = await _favoritesService.toggleFavorite(
        caregiverData,
      );

      setState(() {
        isFavorite = isNowFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowFavorite
                ? '${widget.service.title} added to favorites'
                : '${widget.service.title} removed from favorites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookPage(service: widget.service),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    widget.service.imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFE91E63),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Service details - Compact padding
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.service.rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.service.price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D6EFD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceModel {
  final String imageUrl;
  final String title;
  final double rating;
  final String price;
  final String location;
  final String experience;
  final String description;
  final List<String> features;

  ServiceModel({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.price,
    required this.location,
    required this.experience,
    required this.description,
    required this.features,
  });
}
