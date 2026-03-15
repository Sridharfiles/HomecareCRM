import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';
import 'package:homecarecrm/screens/caregiver_details_page/caregiver_details_page.dart';

class BookmarkedPage extends StatefulWidget {
  const BookmarkedPage({Key? key}) : super(key: key);

  @override
  State<BookmarkedPage> createState() => _BookmarkedPageState();
}

class _BookmarkedPageState extends State<BookmarkedPage> {
  // Sample bookmarked services data
  final List<ServiceModel> bookmarkedServices = [
    ServiceModel(
      id: 'bookmark_1',
      imageUrl: 'assets/images/image2.jpg',
      title: 'Volunteer Caregiver',
      rating: 4.5,
      price: 'Free',
      location: 'Available in Los Angeles & Nearby Areas',
      experience: '7+ Years of Experience',
      description:
          'Compassionate companion care services for seniors who need social interaction and assistance with daily tasks.',
      features: [
        'Friendly and Professional Companions',
        'Help with Daily Errands and Shopping',
        'Social Activities and Engagement',
      ],
    ),
    ServiceModel(
      id: 'bookmark_2',
      imageUrl: 'assets/images/image1.jpg',
      title: 'Companion Care',
      rating: 4.8,
      price: '\$20/hr',
      location: 'Available in New York & Nearby Areas',
      experience: '5+ Years of Experience',
      description:
          'Our professional caregivers provide compassionate support for seniors and individuals with special needs.',
      features: [
        'Certified and Background-Checked Caregivers',
        '24/7 On-Demand Support',
        'Customized Care Plans',
      ],
    ),
    ServiceModel(
      id: 'bookmark_3',
      imageUrl: 'assets/images/image3.jpg',
      title: 'Agency Caregiver',
      rating: 4.3,
      price: '\$25/hr',
      location: 'Available in Chicago & Nearby Areas',
      experience: '4+ Years of Experience',
      description:
          'Supporting family caregivers with respite care and professional assistance.',
      features: [
        'Respite Care for Family Caregivers',
        'Flexible Scheduling Options',
        'Experienced and Trustworthy Staff',
      ],
    ),
    ServiceModel(
      id: 'bookmark_4',
      imageUrl: 'assets/images/image4.jpg',
      title: 'Geriatric Caregiver',
      rating: 4.7,
      price: '\$18.50/hr',
      location: 'Available in Miami & Nearby Areas',
      experience: '6+ Years of Experience',
      description:
          'Specialized geriatric care for elderly patients with complex health needs.',
      features: [
        'Specialized Training in Geriatric Care',
        'Mobility and Transfer Assistance',
        'Cognitive Stimulation Activities',
      ],
    ),
    ServiceModel(
      id: 'bookmark_5',
      imageUrl: 'assets/images/image5.jpg',
      title: 'Dementia Care',
      rating: 4.9,
      price: '\$30/hr',
      location: 'Available in Boston & Nearby Areas',
      experience: '8+ Years of Experience',
      description:
          'Specialized care for patients with dementia and Alzheimer\'s disease, providing memory support and cognitive stimulation.',
      features: [
        'Memory Care Specialists',
        'Cognitive Stimulation Programs',
        'Behavioral Management Support',
      ],
    ),
    ServiceModel(
      id: 'bookmark_6',
      imageUrl: 'assets/images/image6.jpg',
      title: 'Post-Surgery Care',
      rating: 4.6,
      price: '\$35/hr',
      location: 'Available in Seattle & Nearby Areas',
      experience: '6+ Years of Experience',
      description:
          'Professional post-operative care to ensure smooth recovery and proper wound management after surgery.',
      features: [
        'Wound Care Specialists',
        'Medication Management',
        'Recovery Assistance',
      ],
    ),
    ServiceModel(
      id: 'bookmark_7',
      imageUrl: 'assets/images/image1.jpg',
      title: 'Palliative Care',
      rating: 4.8,
      price: '\$40/hr',
      location: 'Available in San Francisco & Nearby Areas',
      experience: '10+ Years of Experience',
      description:
          'Compassionate palliative care focusing on pain management and quality of life for patients with serious illnesses.',
      features: [
        'Pain Management Experts',
        'Emotional Support',
        'Family Counseling',
      ],
    ),
    ServiceModel(
      id: 'bookmark_8',
      imageUrl: 'assets/images/image2.jpg',
      title: 'Physical Therapy Assistant',
      rating: 4.4,
      price: '\$28/hr',
      location: 'Available in Dallas & Nearby Areas',
      experience: '5+ Years of Experience',
      description:
          'Assistance with physical therapy exercises and rehabilitation programs to improve mobility and strength.',
      features: [
        'Rehabilitation Support',
        'Exercise Assistance',
        'Progress Monitoring',
      ],
    ),
    ServiceModel(
      id: 'bookmark_9',
      imageUrl: 'assets/images/image3.jpg',
      title: 'Mental Health Support',
      rating: 4.7,
      price: '\$32/hr',
      location: 'Available in Atlanta & Nearby Areas',
      experience: '7+ Years of Experience',
      description:
          'Professional mental health support and counseling for emotional well-being and psychological care.',
      features: [
        'Licensed Counselors',
        'Emotional Support',
        'Therapy Sessions',
      ],
    ),
    ServiceModel(
      id: 'bookmark_10',
      imageUrl: 'assets/images/image4.jpg',
      title: 'Pediatric Home Care',
      rating: 4.9,
      price: '\$26/hr',
      location: 'Available in Denver & Nearby Areas',
      experience: '6+ Years of Experience',
      description:
          'Specialized home care services for children with medical needs, ensuring comfort and proper care at home.',
      features: ['Child Care Specialists', 'Medical Support', 'Play Therapy'],
    ),
  ];

  void _removeBookmark(int index) {
    setState(() {
      bookmarkedServices.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service removed from bookmarks'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _bookService(ServiceModel service) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookPage(service: service)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A84FF),
        elevation: 6,
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Bookmarked',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0A84FF),
              size: 20,
            ),
          ),
        ),
      ),
      body:
          bookmarkedServices.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No bookmarked services yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bookmark services to see them here',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: bookmarkedServices.length,
                itemBuilder: (context, index) {
                  final service = bookmarkedServices[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 1,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top Row
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  service.imageUrl,
                                  width: 90,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 90,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.image,
                                        size: 30,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Center
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Service name
                                    Text(
                                      service.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Price text
                                    Text(
                                      service.price,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right - Filled bookmark icon
                              const Icon(
                                Icons.bookmark,
                                color: Color(0xFF0A84FF),
                                size: 22,
                              ),
                            ],
                          ),
                        ),

                        // Bottom Row
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            children: [
                              // Remove button
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _removeBookmark(index),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF0A84FF),
                                      width: 1.5,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Color(0xFF0A84FF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Book button
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _bookService(service),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A84FF),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
