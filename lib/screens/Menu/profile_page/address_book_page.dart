import 'package:flutter/material.dart';
import 'package:homecarecrm/services/user_details_store_services.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({Key? key}) : super(key: key);

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final UserDetailsStoreService _userService = UserDetailsStoreService();
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? data = await _userService.fetchUserDetails();
      setState(() {
        userData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 12,
              right: 12,
              bottom: 12,
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Address Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : userData != null
                    ? ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return _buildUserAddressCard();
                      },
                    )
                    : const Center(
                      child: Text(
                        'No user information available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAddressCard() {
    if (userData == null) return const SizedBox.shrink();

    String fullName =
        '${userData!['firstName'] ?? ''} ${userData!['lastName'] ?? ''}'.trim();
    String phone = userData!['phoneNumber'] ?? '';
    String email = userData!['email'] ?? '';
    String street = userData!['streetAddress'] ?? '';
    String city = userData!['city'] ?? '';
    String state = userData!['state'] ?? '';
    String country = userData!['country'] ?? '';
    String pincode = userData!['pincode'] ?? userData!['zipCode'] ?? '';
    String district = userData!['district'] ?? '';
    String countryCode = userData!['countryCode'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fullName.isNotEmpty ? fullName : 'User Name',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 3),
          if (phone.isNotEmpty)
            Text(
              countryCode.isNotEmpty ? '$countryCode $phone' : phone,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              email,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
          if (street.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              street,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
          if (city.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(city, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          ],
          if (state.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              state,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
          if (district.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              district,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
          if (country.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              country,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
          if (pincode.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              pincode,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }
}
