import 'package:flutter/material.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  // Form controllers
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  // Validation state
  bool _showErrors = false;

  // Error messages
  final List<String> _errorMessages = [
    'Please enter Medication Name',
    'Please enter Type (Tablet/Syrup)',
    'Please enter Dosage (e.g., 1 Pill, 10ml)',
    'Please enter Schedule (Morning/Night)',
    'Please enter Duration (e.g., 5 Days, Daily)',
  ];

  void _validateAndSubmit() {
    // Check if any field is empty
    bool hasEmptyField = _medicationNameController.text.isEmpty ||
                        _typeController.text.isEmpty ||
                        _dosageController.text.isEmpty ||
                        _scheduleController.text.isEmpty ||
                        _durationController.text.isEmpty;

    if (hasEmptyField) {
      // Show error state
      setState(() {
        _showErrors = true;
      });
    } else {
      // Success - navigate back or show success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medication added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1976D2),
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Medication',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Medication Name Field
            _buildInputField(
              controller: _medicationNameController,
              placeholder: 'Medication Name',
              errorText: _showErrors && _medicationNameController.text.isEmpty 
                  ? _errorMessages[0] 
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Type Field
            _buildInputField(
              controller: _typeController,
              placeholder: 'Type (Tablet/Syrup)',
              errorText: _showErrors && _typeController.text.isEmpty 
                  ? _errorMessages[1] 
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Dosage Field
            _buildInputField(
              controller: _dosageController,
              placeholder: 'Dosage (e.g., 1 Pill, 10ml)',
              errorText: _showErrors && _dosageController.text.isEmpty 
                  ? _errorMessages[2] 
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Schedule Field
            _buildInputField(
              controller: _scheduleController,
              placeholder: 'Schedule (Morning/Night)',
              errorText: _showErrors && _scheduleController.text.isEmpty 
                  ? _errorMessages[3] 
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Duration Field
            _buildInputField(
              controller: _durationController,
              placeholder: 'Duration (e.g., 5 Days, Daily)',
              errorText: _showErrors && _durationController.text.isEmpty 
                  ? _errorMessages[4] 
                  : null,
            ),
            
            const SizedBox(height: 32),
            
            // Add Medication Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: const Text(
                  'Add Medication',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String placeholder,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: placeholder,
            hintStyle: TextStyle(
              color: errorText != null ? const Color(0xFFD32F2F) : const Color(0xFF9E9E9E),
              fontFamily: 'Roboto',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? const Color(0xFFD32F2F) : const Color(0xFFBDBDBD),
                width: errorText != null ? 2 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? const Color(0xFFD32F2F) : const Color(0xFFBDBDBD),
                width: errorText != null ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? const Color(0xFFD32F2F) : const Color(0xFF1976D2),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
          ),
        ),
        
        // Error Message
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFD32F2F),
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _typeController.dispose();
    _dosageController.dispose();
    _scheduleController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
