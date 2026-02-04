import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  // Sample order data
  final List<Map<String, dynamic>> activeOrders = [
    {
      'name': 'Ginger',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$4.30',
      'image': null,
    },
    {
      'name': 'Carrot',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$1.25',
      'image': null,
    },
    {
      'name': 'Beef',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$5.50',
      'image': null,
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      'name': 'Apple',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$2.00',
      'image': Icons.apple,
    },
    {
      'name': 'Fruits',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$1.75',
      'image': null,
    },
    {
      'name': 'Chicken',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$4.30',
      'image': null,
    },
  ];

  final List<Map<String, dynamic>> cancelledOrders = [
    {
      'name': 'Oil',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$4.30',
      'image': null,
    },
    {
      'name': 'Lamb Meat',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$4.30',
      'image': null,
    },
    {
      'name': 'Banana',
      'date': 'May 23, 4.3PM Delivered',
      'price': '\$4.30',
      'image': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF2196F3),
                          size: 22,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'My Orders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Active Orders Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),

              // Active Orders List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: activeOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    activeOrders[index],
                    isActive: true,
                  );
                },
              ),

              const SizedBox(height: 12),

              // Completed Orders Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(
                  'Completed Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),

              // Completed Orders List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: completedOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    completedOrders[index],
                    isActive: false,
                  );
                },
              ),

              const SizedBox(height: 12),

              // Cancelled Orders Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(
                  'Cancelled Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),

              // Cancelled Orders List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: cancelledOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    cancelledOrders[index],
                    isActive: false,
                    isCancelled: true,
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order, {
    required bool isActive,
    bool isCancelled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image/Icon
            if (order['image'] != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  order['image'],
                  color: Colors.white,
                  size: 32,
                ),
              )
            else
              const SizedBox(width: 0),
            
            SizedBox(width: order['image'] != null ? 12 : 0),

            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order['date'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order['price'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle button action
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF2196F3),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(
                            isActive ? 'Cancel Order' : 'Rate Courier',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                          ),
                          child: Text(
                            isActive ? 'Track Order' : 'Re Order',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
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