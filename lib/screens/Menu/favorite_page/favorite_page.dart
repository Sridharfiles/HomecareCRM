import 'package:flutter/material.dart';

class Caregiver {
  final String name;
  final String price;
  final String image;
  final String category;

  Caregiver({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });
}

class FavoriteCaregiverScreen extends StatefulWidget {
  const FavoriteCaregiverScreen({super.key});

  @override
  State<FavoriteCaregiverScreen> createState() =>
      _FavoriteCaregiverScreenState();
}

class _FavoriteCaregiverScreenState extends State<FavoriteCaregiverScreen>
    with SingleTickerProviderStateMixin {
  bool showFilter = false;
  String? selectedFilter;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final List<String> filterOptions = [
    'Companion Care',
    'Agency Caregiver',
    'Family Caregiver',
    'Geriatric Caregiver',
    'Hospice Care',
    'Pediatric Caregiver',
    'Informal Caregiver',
    'Volunteer Caregiver',
  ];

  final List<Caregiver> allCaregivers = [
    Caregiver(
      name: 'Companion Care',
      price: '\$20/hr',
      image: 'assets/companion_care.jpg',
      category: 'Companion Care',
    ),
    Caregiver(
      name: 'Agency Caregiver',
      price: '\$25/hr',
      image: 'assets/agency_caregiver.jpg',
      category: 'Agency Caregiver',
    ),
    Caregiver(
      name: 'Family Caregiver',
      price: '\$18.50/hr',
      image: 'assets/family_caregiver.jpg',
      category: 'Family Caregiver',
    ),
    Caregiver(
      name: 'Geriatric Caregiver',
      price: '\$22/hr',
      image: 'assets/geriatric_caregiver.jpg',
      category: 'Geriatric Caregiver',
    ),
    Caregiver(
      name: 'Hospice Care',
      price: '\$20/hr',
      image: 'assets/hospice_care.jpg',
      category: 'Hospice Care',
    ),
    Caregiver(
      name: 'Pediatric Caregiver',
      price: '\$28/hr',
      image: 'assets/pediatric_caregiver.jpg',
      category: 'Pediatric Caregiver',
    ),
    Caregiver(
      name: 'Informal Caregiver',
      price: '\$15/hr',
      image: 'assets/informal_caregiver.jpg',
      category: 'Informal Caregiver',
    ),
    Caregiver(
      name: 'Volunteer Caregiver',
      price: 'Free',
      image: 'assets/volunteer_caregiver.jpg',
      category: 'Volunteer Caregiver',
    ),
  ];

  List<Caregiver> get filteredCaregivers {
    if (selectedFilter == null) {
      return allCaregivers;
    }
    return allCaregivers
        .where((caregiver) => caregiver.category == selectedFilter)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleFilter() {
    setState(() {
      showFilter = !showFilter;
      if (showFilter) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Favorite',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Caregiver List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredCaregivers.length,
                  itemBuilder: (context, index) {
                    final caregiver = filteredCaregivers[index];
                    return CaregiverCard(caregiver: caregiver);
                  },
                ),
              ),
            ],
          ),

          // Filter FAB
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: toggleFilter,
              backgroundColor: Colors.orange,
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // Filter Bottom Sheet
          if (showFilter)
            GestureDetector(
              onTap: toggleFilter,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

          if (showFilter)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: FilterBottomSheet(
                  filterOptions: filterOptions,
                  selectedFilter: selectedFilter,
                  onFilterSelected: (filter) {
                    setState(() {
                      selectedFilter = filter;
                    });
                    toggleFilter();
                  },
                  onClose: toggleFilter,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CaregiverCard extends StatelessWidget {
  final Caregiver caregiver;

  const CaregiverCard({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(width: 12),

            // Caregiver info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caregiver.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    caregiver.price,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Favorite icon
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  final List<String> filterOptions;
  final String? selectedFilter;
  final Function(String) onFilterSelected;
  final VoidCallback onClose;

  const FilterBottomSheet({
    super.key,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
          ),

          // Filter options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filterOptions.length,
              itemBuilder: (context, index) {
                final option = filterOptions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => onFilterSelected(option),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}