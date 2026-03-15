import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:homecarecrm/screens/Menu/messages_page/messages_page.dart';
import 'package:homecarecrm/screens/Menu/topcaregivers_page/caregiver_details_page.dart';

class Caregiver {
  final String name;
  final double rating;
  final int reviews;
  final String location;
  final String image;
  final int price;

  Caregiver({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.image,
    required this.price,
  });
}

class CaregiverCard extends StatelessWidget {
  final Caregiver caregiver;
  final BuildContext context;

  const CaregiverCard({
    Key? key,
    required this.caregiver,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaregiverDetailsPage(caregiver: caregiver),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // Reduced from 15
        padding: const EdgeInsets.all(12), // Reduced from 16
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section - Profile Image
            CircleAvatar(
              radius: 32, // Reduced from 38
              backgroundImage: NetworkImage(caregiver.image),
            ),
            const SizedBox(width: 10), // Reduced from 12
            // Middle Section - Caregiver Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    caregiver.name,
                    style: const TextStyle(
                      fontSize: 17, // Reduced from 18
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3), // Reduced from 4
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15, // Reduced from 16
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${caregiver.rating} (${caregiver.reviews})',
                        style: const TextStyle(
                          fontSize: 13, // Reduced from 14
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // Reduced from 6
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 13, // Reduced from 14
                      ),
                      const SizedBox(width: 3), // Reduced from 4
                      Expanded(
                        child: Text(
                          caregiver.location,
                          style: const TextStyle(
                            fontSize: 12, // Reduced from 13
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10), // Reduced from 12
            // Right Section - Price and Action Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Price
                Text(
                  '\$${caregiver.price}/hr',
                  style: const TextStyle(
                    fontSize: 15, // Reduced from 16
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8), // Reduced from 12
                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Message Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagesPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 32, // Reduced from 36
                        height: 32, // Reduced from 36
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE7F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.message_outlined,
                          color: Colors.purple,
                          size: 16, // Reduced from 18
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Reduced from 10
                    // Call Button
                    GestureDetector(
                      onTap: () async {
                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: '9342583009',
                        );
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not launch phone dialer'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: 32, // Reduced from 36
                        height: 32, // Reduced from 36
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_outlined,
                          color: Colors.green,
                          size: 16, // Reduced from 18
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopCaregiversScreen extends StatelessWidget {
  TopCaregiversScreen({Key? key}) : super(key: key);

  final List<Caregiver> caregivers = [
    Caregiver(
      name: 'Janefa Cooper',
      rating: 4.9,
      reviews: 125,
      location: '123 Main St, New York, NY 10001',
      image: 'https://picsum.photos/seed/janefa/200/200.jpg',
      price: 120,
    ),
    Caregiver(
      name: 'Nordan Obhsar',
      rating: 4.3,
      reviews: 111,
      location: '456 Oak Ave, Los Angeles, CA 90001',
      image: 'https://picsum.photos/seed/nordan/200/200.jpg',
      price: 100,
    ),
    Caregiver(
      name: 'Analds Devids',
      rating: 4.6,
      reviews: 155,
      location: '789 Pine Rd, Chicago, IL 60601',
      image: 'https://picsum.photos/seed/analds/200/200.jpg',
      price: 150,
    ),
    Caregiver(
      name: 'Sarah Johnson',
      rating: 4.8,
      reviews: 98,
      location: '321 Elm St, Houston, TX 77001',
      image: 'https://picsum.photos/seed/sarah/200/200.jpg',
      price: 110,
    ),
    Caregiver(
      name: 'Michael Chen',
      rating: 4.7,
      reviews: 142,
      location: '654 Maple Dr, Phoenix, AZ 85001',
      image: 'https://picsum.photos/seed/michael/200/200.jpg',
      price: 130,
    ),
    Caregiver(
      name: 'Emma Wilson',
      rating: 4.5,
      reviews: 89,
      location: '987 Cedar Ln, Philadelphia, PA 19101',
      image: 'https://picsum.photos/seed/emma/200/200.jpg',
      price: 105,
    ),
    Caregiver(
      name: 'David Martinez',
      rating: 4.9,
      reviews: 176,
      location: '456 Beach Blvd, Miami, FL 33101',
      image: 'https://picsum.photos/seed/david/200/200.jpg',
      price: 125,
    ),
    Caregiver(
      name: 'Lisa Anderson',
      rating: 4.4,
      reviews: 93,
      location: '789 Mountain View, Denver, CO 80201',
      image: 'https://picsum.photos/seed/lisa/200/200.jpg',
      price: 115,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Top Caregivers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: caregivers.length,
        itemBuilder: (context, index) {
          return CaregiverCard(caregiver: caregivers[index], context: context);
        },
      ),
    );
  }
}
