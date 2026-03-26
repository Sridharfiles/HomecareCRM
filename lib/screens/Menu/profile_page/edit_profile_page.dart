import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/services/user_details_store_services.dart';
import 'package:homecarecrm/static_data/countries_data.dart';
import 'package:homecarecrm/static_data/states_districts_data.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  final UserDetailsStoreService _userService = UserDetailsStoreService();

  String? _selectedCountry;
  String? _selectedCountryCode;
  String? _selectedState;
  String? _selectedDistrict;
  String _selectedCity = '';
  List<String> _availableStates = [];
  List<String> _availableDistricts = [];
  String? _userName;
  String? _userEmail;
  String? _userProfilePicture;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Get Google profile data first
      Map<String, dynamic>? googleProfile =
          await _userService.getGoogleProfileData();

      if (googleProfile != null) {
        _userProfilePicture = googleProfile['profilePicture'];
      }

      // Get current user email from Firebase Auth
      String? email = await _userService.getCurrentUserEmail();
      if (email != null) {
        _emailController.text = email;
        _userEmail = email;
      }

      // Fetch user details from Firestore
      Map<String, dynamic>? userData = await _userService.fetchUserDetails();

      if (userData != null) {
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
          _streetController.text = userData['streetAddress'] ?? '';
          _stateController.text = userData['state'] ?? '';
            _districtController.text =
              (userData['city'] ?? userData['district'] ?? '').toString();
          _pincodeController.text = userData['pincode'] ?? '';
          _selectedCountry = userData['country'];
          _selectedCountryCode = userData['countryCode'];
          _selectedState = userData['state'];
            _selectedDistrict =
              (userData['city'] ?? userData['district'] ?? '').toString();
            _selectedCity =
              (userData['city'] ?? userData['district'] ?? '').toString();

          // Populate available states for selected country
          if (_selectedCountry != null) {
            _availableStates = getStatesForCountry(_selectedCountry!);
            if (_selectedState != null) {
              _availableDistricts = getDistrictsForState(
                _selectedCountry!,
                _selectedState!,
              );
            }
          }

          // Set display name
          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';
          _userName = '$firstName $lastName'.trim();
        });
      } else {
        // Use Google profile data if no Firestore data exists
        if (googleProfile != null) {
          setState(() {
            _firstNameController.text = googleProfile['firstName'] ?? '';
            _lastNameController.text = googleProfile['lastName'] ?? '';
            String firstName = googleProfile['firstName'] ?? '';
            String lastName = googleProfile['lastName'] ?? '';
            _userName = '$firstName $lastName'.trim();
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onCountrySelected(String? countryName) {
    if (countryName != null) {
      final country = countryList.firstWhere(
        (c) => c.name == countryName,
        orElse: () => countryList[0],
      );
      setState(() {
        _selectedCountry = country.name;
        _selectedCountryCode = country.dialCode;
        _selectedState = null;
        _selectedDistrict = null;
        _selectedCity = '';
        _stateController.clear();
        _districtController.clear();
        _availableStates = getStatesForCountry(country.name);
        _availableDistricts = [];
      });
    }
  }

  void _onStateSelected(String? stateName) {
    if (stateName != null && _selectedCountry != null) {
      setState(() {
        _selectedState = stateName;
        _selectedDistrict = null;
        _selectedCity = '';
        _districtController.clear();
        _availableDistricts = getDistrictsForState(
          _selectedCountry!,
          stateName,
        );
      });
    }
  }

  void _onDistrictSelected(String? districtName) {
    if (districtName != null) {
      setState(() {
        _selectedDistrict = districtName;
        _selectedCity = districtName;
        _districtController.text = districtName;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'User Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                        child:
                            _userProfilePicture != null
                                ? ClipOval(
                                  child: Image.network(
                                    _userProfilePicture!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey[600],
                                      );
                                    },
                                  ),
                                )
                                : Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                      ),
                      const SizedBox(height: 12),

                      // Name
                      Text(
                        _userName ?? 'User Name',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        _userEmail ?? 'email@example.com',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),

                      // Input Fields
                      _buildInputField(
                        _firstNameController,
                        Icons.person_outline,
                        'First Name',
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        _lastNameController,
                        Icons.person_outline,
                        'Last Name',
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        _emailController,
                        Icons.email_outlined,
                        'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                      ),
                      const SizedBox(height: 12),

                      // Country Dropdown
                      _buildCountryDropdown(),
                      const SizedBox(height: 12),

                      // Phone Number with Country Code Prefix
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            // Country Code Prefix
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                _selectedCountryCode ?? '+0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            // Phone Number Input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Enter phone number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // State Dropdown
                      _buildStateDropdown(),
                      const SizedBox(height: 12),

                      // City Dropdown
                      _buildCityDropdown(),
                      const SizedBox(height: 12),

                      _buildInputField(
                        _streetController,
                        Icons.home_outlined,
                        'Street Address',
                      ),
                      const SizedBox(height: 12),

                      _buildInputField(
                        _pincodeController,
                        Icons.markunread_mailbox_outlined,
                        'Pincode',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveUserInformation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child:
                              _isSaving
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Save Information',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedCountry,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Row(
          children: [
            Icon(Icons.flag_outlined, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Text(
              'Select Country',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
        items:
            countryList.map<DropdownMenuItem<String>>((CountryData country) {
              return DropdownMenuItem<String>(
                value: country.name,
                child: Text(country.name, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
        onChanged: _onCountrySelected,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedState,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Text(
              'Select State',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
        items:
            _availableStates.map<DropdownMenuItem<String>>((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
        onChanged: _selectedCountry != null ? _onStateSelected : null,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        disabledHint: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[400], size: 20),
            const SizedBox(width: 12),
            Text(
              'Select country first',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedDistrict,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Text(
              'Select City',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
        items:
            _availableDistricts.map<DropdownMenuItem<String>>((
              String city,
            ) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
        onChanged: _selectedState != null ? _onDistrictSelected : null,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        disabledHint: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[400], size: 20),
            const SizedBox(width: 12),
            Text(
              'Select state first',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    IconData icon,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserInformation() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('First name and last name are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if ((_selectedDistrict ?? '').trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select city'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final pincode = _pincodeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid pincode (6 digits only)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _userService.storeUserDetails(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        streetAddress: _streetController.text.trim(),
        city: (_selectedDistrict ?? _selectedCity).trim(),
        state: _selectedState ?? '',
        zipCode: _pincodeController.text.trim(),
        country: _selectedCountry ?? '',
        countryCode: _selectedCountryCode ?? '',
        district: _selectedDistrict ?? '',
      );

      if (mounted) {
        setState(() {
          String firstName = _firstNameController.text.trim();
          String lastName = _lastNameController.text.trim();
          _userName = '$firstName $lastName';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Information saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving user information: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving information: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
