import 'package:flutter/material.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({Key? key}) : super(key: key);

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final List<Map<String, String>> addresses = [
    {
      'name': 'James Powell',
      'phone': '86345454533',
      'email': 'James@gmail.com',
      'street': 'Uk 32 Street',
      'city': 'London, UK 664544',
      'country': 'UK',
      'company': 'Company Name',
      'apt': 'Apt 101',
    },
    {
      'name': 'James Powell',
      'phone': '86345454533',
      'email': 'James@gmail.com',
      'street': 'Uk 32 Street',
      'city': 'London, UK 664544',
      'country': 'UK',
      'company': 'Company Name',
      'apt': 'Apt 101',
    },
    {
      'name': 'James Powell',
      'phone': '86345454533',
      'email': 'James@gmail.com',
      'street': 'Uk 32 Street',
      'city': 'London, UK 664544',
      'country': 'UK',
      'company': 'Company Name',
      'apt': 'Apt 101',
    },
    {
      'name': 'James Powell',
      'phone': '86345454533',
      'email': 'James@gmail.com',
      'street': 'Uk 32 Street',
      'city': 'London, UK 664544',
      'country': 'UK',
      'company': 'Company Name',
      'apt': 'Apt 101',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 12),
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
                    icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 20),
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
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(addresses[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> address, int index) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(address['phone']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const SizedBox(height: 1),
                Text(address['email']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const SizedBox(height: 1),
                Text(address['street']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const SizedBox(height: 1),
                Text(address['city']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const SizedBox(height: 1),
                Text(address['country']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const SizedBox(height: 1),
                Text(address['company']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const SizedBox(height: 1),
                Text(address['apt']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.grey[700], size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 12),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.grey[700], size: 20),
                onPressed: () => _showDeleteDialog(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}