import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/slide_drawer/add_medication.dart';
import 'package:homecarecrm/screens/slide_drawer/messages_page.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  // Track checkbox states for each medication
  List<bool> medicationChecked = [false, false, false, false];

  void navigateToMessages() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagesPage()),
    );
  }

  void toggleCheckbox(int index) {
    setState(() {
      medicationChecked[index] = !medicationChecked[index];
    });
  }

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
          'Medication',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Sub-Header Text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'You are currently having 4 Medicines',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9E9E9E),
                fontFamily: 'Roboto',
              ),
            ),
          ),

          // Medication List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                MedicationCard(
                  index: 0,
                  timeSchedule: '9 AM – 08:00 PM',
                  medicineName: 'Cholecalciferol',
                  description: 'Tablet (1 Pill) – After meal',
                  frequencyTag: 'Morning',
                  durationTag: 'Daily',
                  isChecked: medicationChecked[0],
                  onCheckboxToggle: () => toggleCheckbox(0),
                  onMessageTap: navigateToMessages,
                ),

                MedicationCard(
                  index: 1,
                  timeSchedule: '9 AM',
                  medicineName: 'Ascorbic Acid',
                  description: 'Syrup (10ml) – After meal',
                  frequencyTag: 'Morning',
                  durationTag: '5 Days (till 23 SEP)',
                  isChecked: medicationChecked[1],
                  onCheckboxToggle: () => toggleCheckbox(1),
                  onMessageTap: navigateToMessages,
                ),

                MedicationCard(
                  index: 2,
                  timeSchedule: '9 AM – 02:30 PM – 08:00 PM',
                  medicineName: 'Phytonadione',
                  description: 'Tablet (1 Pill) – After meal',
                  frequencyTag: 'Morning & Night',
                  durationTag: 'Daily',
                  isChecked: medicationChecked[2],
                  onCheckboxToggle: () => toggleCheckbox(2),
                  onMessageTap: navigateToMessages,
                ),

                MedicationCard(
                  index: 3,
                  timeSchedule: '9 AM',
                  medicineName: 'Paracetamol 500mg',
                  description: 'Tablet (1 Pill) – After meal',
                  frequencyTag: '3 times',
                  durationTag: '5 Days (till 23 SEP)',
                  isChecked: medicationChecked[3],
                  onCheckboxToggle: () => toggleCheckbox(3),
                  onMessageTap: navigateToMessages,
                ),

                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Medication screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class MedicationCard extends StatelessWidget {
  final int index;
  final String timeSchedule;
  final String medicineName;
  final String description;
  final String frequencyTag;
  final String durationTag;
  final bool isChecked;
  final VoidCallback onCheckboxToggle;
  final VoidCallback onMessageTap;

  const MedicationCard({
    super.key,
    required this.index,
    required this.timeSchedule,
    required this.medicineName,
    required this.description,
    required this.frequencyTag,
    required this.durationTag,
    required this.isChecked,
    required this.onCheckboxToggle,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle medication card tap
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped on: $medicineName')));
          },
          splashColor: Colors.blue.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                children: [
                  // Clock Icon and Time Schedule
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeSchedule,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1976D2),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Green Message Icon and Checkbox
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onMessageTap,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onCheckboxToggle,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF1976D2),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color:
                                isChecked
                                    ? const Color(0xFF1976D2)
                                    : Colors.white,
                          ),
                          child:
                              isChecked
                                  ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Middle Section
              Row(
                children: [
                  // Medicine Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63), // Brown
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Medicine Name and Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicineName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9E9E9E),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tags / Chips
              Row(
                children: [
                  // Frequency Tag (Pink)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF48FB1), // Pink
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      frequencyTag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Duration Tag (Yellow)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F), // Yellow
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      durationTag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
