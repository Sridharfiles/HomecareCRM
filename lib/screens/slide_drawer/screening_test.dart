import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/slide_drawer/messages_page.dart';

class ScreeningTestScreen extends StatefulWidget {
  const ScreeningTestScreen({super.key});

  @override
  State<ScreeningTestScreen> createState() => _ScreeningTestScreenState();
}

class _ScreeningTestScreenState extends State<ScreeningTestScreen> {
  // Blood Pressure
  bool hasBloodPressure = true;
  TextEditingController systolicController = TextEditingController(text: '132');
  TextEditingController diastolicController = TextEditingController(text: '80');

  // Diabetes
  bool hasDiabetes = true;
  TextEditingController beforeMealController = TextEditingController(
    text: '7.6',
  );
  TextEditingController afterMealController = TextEditingController(
    text: '12.8',
  );

  // Previous Surgery
  bool hasPreviousSurgery = true;
  String selectedSurgeryType = 'Minor heart surgery';
  final List<String> surgeryTypes = [
    'Minor heart surgery',
    'Major heart surgery',
    'Orthopedic surgery',
    'Abdominal surgery',
    'Neurological surgery',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Screening Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question 1: Blood Pressure
            _buildQuestionSection(
              question: 'Do you have blood pressure?',
              hasCondition: hasBloodPressure,
              onToggle: (value) => setState(() => hasBloodPressure = value),
              child:
                  hasBloodPressure
                      ? Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Systolic (upper)',
                              controller: systolicController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInputField(
                              label: 'Diastolic (lower)',
                              controller: diastolicController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      )
                      : null,
            ),

            const SizedBox(height: 24),

            // Question 2: Diabetes
            _buildQuestionSection(
              question: 'Do you have diabetes?',
              hasCondition: hasDiabetes,
              onToggle: (value) => setState(() => hasDiabetes = value),
              child:
                  hasDiabetes
                      ? Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Before meal',
                              controller: beforeMealController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInputField(
                              label: 'After meal',
                              controller: afterMealController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                      )
                      : null,
            ),

            const SizedBox(height: 24),

            // Question 3: Previous Surgery
            _buildQuestionSection(
              question: 'Do you have any previous surgery record?',
              hasCondition: hasPreviousSurgery,
              onToggle: (value) => setState(() => hasPreviousSurgery = value),
              child:
                  hasPreviousSurgery
                      ? _buildDropdownField(
                        label: 'Surgery Type',
                        value: selectedSurgeryType,
                        items: surgeryTypes,
                        onChanged:
                            (value) =>
                                setState(() => selectedSurgeryType = value!),
                      )
                      : null,
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to SOS Emergency Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SOSEmergencyScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                ),
                child: const Text(
                  'Submit',
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

  Widget _buildQuestionSection({
    required String question,
    required bool hasCondition,
    required ValueChanged<bool> onToggle,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 12),

        // Toggle Buttons
        Row(
          children: [
            // Yes Button
            GestureDetector(
              onTap: () => onToggle(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      hasCondition
                          ? const Color(0xFF1976D2)
                          : Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFF1976D2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                      size: 16,
                      color:
                          hasCondition ? Colors.white : const Color(0xFF1976D2),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Yes',
                      style: TextStyle(
                        color:
                            hasCondition
                                ? Colors.white
                                : const Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // No Button
            GestureDetector(
              onTap: () => onToggle(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      !hasCondition
                          ? const Color(0xFF1976D2)
                          : Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFF1976D2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'No',
                  style: TextStyle(
                    color:
                        !hasCondition ? Colors.white : const Color(0xFF1976D2),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        ),

        if (child != null) ...[const SizedBox(height: 16), child],
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF424242),
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF424242),
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBDBDBD)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items:
                  items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}

// SOS Emergency Screen
class SOSEmergencyScreen extends StatelessWidget {
  const SOSEmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sosSize = screenWidth * 0.7; // 70% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Top Controls - Close Button
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF424242),
                      size: 20,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Central SOS Indicator - Large Red Circle (70% screen width)
              Container(
                width: sosSize,
                height: sosSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: sosSize * 0.4, // Small white circle at center
                    height: sosSize * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 32, // Large font size
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), // Medium margin-top
              // Status Message
              const Text(
                'Sending message and sharing location to all your caregivers and close contacts. Please wait until they reach you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF424242), // Dark grey
                  fontFamily: 'Roboto',
                  height: 1.5, // Comfortable line spacing
                ),
              ),

              const Spacer(flex: 2),

              // Primary Action Button - Call Emergency Service
              SizedBox(
                width: double.infinity,
                height: 56, // Touch-friendly size
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to existing Messages page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MessagesPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 6, // Elevated
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.black.withValues(alpha: 0.3),
                  ),
                  child: const Text(
                    'Call Emergency Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16), // Clear button separation
              // Secondary Action Button - Cancel SOS
              SizedBox(
                width: double.infinity,
                height: 56, // Touch-friendly size
                child: OutlinedButton(
                  onPressed: () {
                    // Stops SOS process and navigates back safely
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1976D2), width: 2),
                    backgroundColor: Colors.white, // White background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel SOS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1976D2), // Primary Blue text
                      fontFamily: 'Roboto',
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
}
