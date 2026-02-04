import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/caregiver_details_page/caregiver_details_page.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';
import 'package:homecarecrm/screens/Menu/search_page/auto_parts_search_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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

  const CaregiverCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.price,
    required this.isFree,
    required this.imageUrl,
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

// Sample caregiver data with home page images
final List<Map<String, dynamic>> caregivers = [
  {
    'name': 'Professional Home Care Service',
    'subtitle': '2',
    'rating': 4.5,
    'price': '\$28/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image1.jpg',
  },
  {
    'name': 'Companion Care',
    'subtitle': '2',
    'rating': 4.8,
    'price': 'Free',
    'isFree': true,
    'imageUrl': 'assets/images/image2.jpg',
  },
  {
    'name': 'Family Caregiver Support',
    'subtitle': '2',
    'rating': 4.2,
    'price': '\$15/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image3.jpg',
  },
  {
    'name': 'Geriatric Caregiver',
    'subtitle': '3',
    'rating': 4.9,
    'price': '\$35/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image4.jpg',
  },
  {
    'name': 'Home Health Aide',
    'subtitle': '4',
    'rating': 4.6,
    'price': '\$22/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image5.jpg',
  },
  {
    'name': 'Respite Care',
    'subtitle': '2',
    'rating': 4.7,
    'price': '\$32/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image6.jpg',
  },
  {
    'name': 'Dementia Care Expert',
    'subtitle': '1',
    'rating': 4.4,
    'price': '\$38/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image1.jpg',
  },
  {
    'name': 'Post-Surgery Caregiver',
    'subtitle': '2',
    'rating': 4.3,
    'price': '\$30/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image2.jpg',
  },
  {
    'name': 'Physical Therapy Assistant',
    'subtitle': '3',
    'rating': 4.8,
    'price': '\$25/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image3.jpg',
  },
  {
    'name': 'Mental Health Support',
    'subtitle': '2',
    'rating': 4.1,
    'price': '\$20/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image4.jpg',
  },
  {
    'name': 'Palliative Care Specialist',
    'subtitle': '1',
    'rating': 4.9,
    'price': '\$45/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image5.jpg',
  },
  {
    'name': 'Child Care Specialist',
    'subtitle': '5',
    'rating': 4.6,
    'price': '\$18/hr',
    'isFree': false,
    'imageUrl': 'assets/images/image6.jpg',
  },
];
