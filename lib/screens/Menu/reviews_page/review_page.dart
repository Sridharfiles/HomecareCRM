import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/Menu/reviews_page/write_review_page.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF2196F3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2196F3), size: 20),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Reviews',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Rating Summary Card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '4.0',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: index < 4 ? const Color(0xFFFFA726) : const Color(0xFFBDBDBD),
                                size: 24,
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'based on 23 Reviews',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Rating bars
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildRatingBar('Excellent', 0.7, const Color(0xFFCDDC39)),
                                const SizedBox(height: 6),
                                _buildRatingBar('Good', 0.5, const Color(0xFF8BC34A)),
                                const SizedBox(height: 6),
                                _buildRatingBar('Average', 0.45, const Color(0xFFFF9800)),
                                const SizedBox(height: 6),
                                _buildRatingBar('Below Average', 0.55, const Color(0xFF9C27B0)),
                                const SizedBox(height: 6),
                                _buildRatingBar('Poor', 0.15, const Color(0xFFE91E63)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Review Cards
                    _buildReviewCard(
                      name: 'James Andre',
                      rating: 4.3,
                      daysAgo: '1 day ago',
                      review: 'The Grocery App has significantly enhanced our grocery shopping experience, providing seamless access to a wide variety of products and reliable delivery options. Its user-friendly interface simplifies the process of finding, ordering, and managing groceries, ensuring a consistently smooth and convenient experience. We highly recommend this app for its effectiveness in fostering a better shopping experience and connection with reliable suppliers.',
                      avatarUrl: 'https://i.pravatar.cc/150?img=1',
                    ),

                    const SizedBox(height: 12),

                    _buildReviewCard(
                      name: 'Powell Sumuled',
                      rating: 3.3,
                      daysAgo: '4 day ago',
                      review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eu lorem ut quam hendrerit rutrum. Nullam tristique consequat tortor, id sagittis nisl faucibus a. In hac habitasse platea dictumst. Mauris at purus et elit consequat laoreet non ac odio.',
                      avatarUrl: 'https://i.pravatar.cc/150?img=2',
                    ),

                    const SizedBox(height: 10),

                    _buildReviewCard(
                      name: 'Hales Andreeed',
                      rating: 5.3,
                      daysAgo: '7 day ago',
                      review: 'Integer eu neque a justo sagittis posuere. Morbi nec dolor nec nulla dictum fermentum. Quisque accumsan, sapien id congue lobortis, dui ante sodales quam, eu placerat quam turpis nec magna.',
                      avatarUrl: 'https://i.pravatar.cc/150?img=3',
                    ),

                    const SizedBox(height: 10),

                    _buildReviewCard(
                      name: 'Guptel Stin',
                      rating: 2.3,
                      daysAgo: '8 day ago',
                      review: 'Suspendisse potenti. Aenean eu nibh nec lectus congue efficitur vel ac lacus. Sed non lobortis erat, et aliquet justo. Nam a suscipit lorem.',
                      avatarUrl: 'https://i.pravatar.cc/150?img=4',
                    ),

                    const SizedBox(height: 10),

                    _buildReviewCard(
                      name: 'Andre',
                      rating: 4.3,
                      daysAgo: '6 day ago',
                      review: 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Quisque euismod convallis leo, non tempor tortor consectetur sed. Curabitur vel vestibulum eros.',
                      avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    ),

                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WriteReviewScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Write A Review',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(String label, double percentage, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF424242),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String name,
    required double rating,
    required String daysAgo,
    required String review,
    required String avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        ...List.generate(4, (index) {
                          return const Icon(
                            Icons.star,
                            color: Color(0xFFFFA726),
                            size: 15,
                          );
                        }),
                        const SizedBox(width: 5),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                daysAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF424242),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}