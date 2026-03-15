import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/Menu/topcaregivers_page/topcaregivers.dart';
import 'package:homecarecrm/screens/caregiver_details_page/confirmbook_page.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';

class CaregiverDetailsPage extends StatelessWidget {
  final Caregiver caregiver;

  const CaregiverDetailsPage({
    Key? key,
    required this.caregiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          caregiver.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCE4EC),
              Color(0xFFF3E5F5),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Profile Image
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(caregiver.image),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Name
            Center(
              child: Text(
                caregiver.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Rating
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFFFC107),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${caregiver.rating} (${caregiver.reviews} reviews)',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Address
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      caregiver.location,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Hourly Rate
            Center(
              child: Text(
                '\$${caregiver.price}/hr',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D6EFD),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Book Now Button
            Center(
              child: GestureDetector(
                onTap: () {
                  // Create a ServiceModel from caregiver data
                  final serviceModel = ServiceModel(
                    id: 'top_caregiver_${caregiver.name}',
                    imageUrl: caregiver.image,
                    title: caregiver.name,
                    rating: caregiver.rating,
                    price: '\$${caregiver.price}/hr',
                    location: caregiver.location,
                    experience: 'Professional Caregiver',
                    description: 'Experienced caregiver providing quality care services',
                    features: ['24/7 Availability', 'Certified', 'Experienced', 'Background Checked'],
                  );
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmBookingScreen(
                        service: serviceModel,
                        selectedDate: DateTime.now(),
                        selectedTime: TimeOfDay.now(),
                        selectedHours: 1,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D6EFD),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D6EFD).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
