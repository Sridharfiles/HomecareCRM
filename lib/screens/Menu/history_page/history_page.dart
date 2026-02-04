import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF0D6EFD),
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  text: 'Last Places',
                ),
                Tab(
                  text: 'Last Caregivers',
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLastPlacesTab(),
                _buildLastCaregiversTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastPlacesTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildPlaceCard(
          icon: Icons.home,
          placeName: 'Home',
          dateTime: 'Dec 15, 2024 - 10:30 AM',
          description: 'Regular home care service',
        ),
        const SizedBox(height: 12),
        _buildPlaceCard(
          icon: Icons.apartment,
          placeName: 'Care Home',
          dateTime: 'Dec 12, 2024 - 2:15 PM',
          description: 'Professional care facility visit',
        ),
        const SizedBox(height: 12),
        _buildPlaceCard(
          icon: Icons.local_hospital,
          placeName: 'Hospital',
          dateTime: 'Dec 8, 2024 - 9:00 AM',
          description: 'Medical appointment and checkup',
        ),
        const SizedBox(height: 12),
        _buildPlaceCard(
          icon: Icons.local_pharmacy,
          placeName: 'Clinic',
          dateTime: 'Dec 5, 2024 - 11:30 AM',
          description: 'Routine health screening',
        ),
        const SizedBox(height: 12),
        _buildPlaceCard(
          icon: Icons.business,
          placeName: 'Office',
          dateTime: 'Dec 1, 2024 - 3:45 PM',
          description: 'Corporate wellness program',
        ),
      ],
    );
  }

  Widget _buildPlaceCard({
    required IconData icon,
    required String placeName,
    required String dateTime,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF0D6EFD).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0D6EFD),
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Middle Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          // Right Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D6EFD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'View Map',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastCaregiversTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildCaregiverCard(
          imageUrl: 'https://picsum.photos/seed/caregiver1/200/200.jpg',
          name: 'Sarah Johnson',
          dateRange: 'Dec 5 to Dec 12',
          review: 'Excellent care and professional service. Very attentive to needs.',
          rating: 4.8,
        ),
        const SizedBox(height: 12),
        _buildCaregiverCard(
          imageUrl: 'https://picsum.photos/seed/caregiver2/200/200.jpg',
          name: 'Michael Chen',
          dateRange: 'Nov 20 to Nov 27',
          review: 'Very experienced and caring. Made the patient feel comfortable.',
          rating: 4.9,
        ),
        const SizedBox(height: 12),
        _buildCaregiverCard(
          imageUrl: 'https://picsum.photos/seed/caregiver3/200/200.jpg',
          name: 'Emily Davis',
          dateRange: 'Nov 10 to Nov 17',
          review: 'Professional and compassionate. Highly recommended.',
          rating: 4.7,
        ),
        const SizedBox(height: 12),
        _buildCaregiverCard(
          imageUrl: 'https://picsum.photos/seed/caregiver4/200/200.jpg',
          name: 'Robert Wilson',
          dateRange: 'Oct 25 to Nov 1',
          review: 'Reliable and trustworthy. Great communication throughout.',
          rating: 4.6,
        ),
        const SizedBox(height: 12),
        _buildCaregiverCard(
          imageUrl: 'https://picsum.photos/seed/caregiver5/200/200.jpg',
          name: 'Lisa Martinez',
          dateRange: 'Oct 15 to Oct 22',
          review: 'Very caring and patient. Excellent medical knowledge.',
          rating: 4.9,
        ),
      ],
    );
  }

  Widget _buildCaregiverCard({
    required String imageUrl,
    required String name,
    required String dateRange,
    required String review,
    required double rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Image
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          
          const SizedBox(width: 16),
          
          // Middle Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateRange,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  review,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Right Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D6EFD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'View Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
