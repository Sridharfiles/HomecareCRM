import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  // List of premium benefits
  final List<Map<String, String>> benefits = const [
    {
      'icon': '💰',
      'title': 'Exclusive Discounts',
      'description': 'Save big with special discounts on top-selling products.',
    },
    {
      'icon': '🚚',
      'title': 'Free Express Shipping',
      'description': 'Get your orders delivered faster at no extra cost.',
    },
    {
      'icon': '⏰',
      'title': 'Early Access to Sales',
      'description': 'Shop exclusive deals before they go public.',
    },
    {
      'icon': '🎧',
      'title': 'Priority Customer Support',
      'description': 'Get faster assistance from our dedicated support team.',
    },
    {
      'icon': '🎁',
      'title': 'Loyalty Rewards & Cashback',
      'description': 'Earn points & cashback on every purchase.',
    },
    {
      'icon': '⭐',
      'title': 'Exclusive Member Deals',
      'description': 'Access special promotions and members-only offers.',
    },
    {
      'icon': '🔄',
      'title': 'Hassle-Free Returns',
      'description': 'Enjoy extended return periods with premium membership.',
    },
    {
      'icon': '🚫',
      'title': 'Ad-Free Experience',
      'description': 'Shop without interruptions from ads.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A84FF),
        elevation: 4,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Subscription & Premium Features',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '🚀 Unlock Premium Shopping Benefits',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A84FF),
                ),
              ),
            ),
          ),

          // Content Layout
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: benefits.length,
              itemBuilder: (context, index) {
                final benefit = benefits[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Left side: Blue outline icon
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A84FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF0A84FF),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              benefit['icon']!,
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right side: Column with title and description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                benefit['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                benefit['description']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Subscribe Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle subscription logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Subscription feature coming soon!'),
                      backgroundColor: Color(0xFF0A84FF),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 4,
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
