import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/home_page/service_card.dart';
import 'package:homecarecrm/screens/caregiver_details_page/payment_page.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final ServiceModel service;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int selectedHours;

  const ConfirmBookingScreen({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedHours,
  });

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  int selectedDateIndex = 0;
  String selectedTimeSlot = '';
  String selectedHours = '';
  String selectedTimePeriod = '';

  final List<Map<String, String>> dates = [
    {'date': '30 Jun', 'day': 'Thu'},
    {'date': '01 Jul', 'day': 'Fri'},
    {'date': '02 Jul', 'day': 'Sat'},
    {'date': '03 Jul', 'day': 'Sun'},
  ];

  final List<String> timeSlots = [
    '08:30 am',
    '09:00 am',
    '10:30 am',
    '11:00 am',
  ];

  final Map<String, List<String>> timeSlotsByPeriod = {
    'Morning': ['08:30 am', '09:00 am', '10:30 am', '11:00 am'],
    'Afternoon': ['12:00 pm', '01:00 pm', '02:30 pm', '03:30 pm', '04:00 pm'],
    'Evening': ['05:00 pm', '06:00 pm', '07:00 pm', '08:00 pm'],
  };

  final List<String> hourOptions = ['1 hour', '2 hours', '3 hours', '4 hours'];

  // Calculate total amount based on hours (assuming $50 per hour)
  double get totalAmount {
    if (selectedHours.isEmpty) return 0.0;
    final hours = int.parse(selectedHours.split(' ')[0]);
    return hours * 50.0;
  }

  // Check if all required fields are selected
  bool get isFormValid {
    return selectedDateIndex >= 0 &&
        selectedTimePeriod.isNotEmpty &&
        selectedTimeSlot.isNotEmpty &&
        selectedHours.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Book Your Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Date Section
            const Text(
              'Select date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedDateIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF0D6EFD) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF0D6EFD)
                                  : Colors.teal,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dates[index]['date']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dates[index]['day']!,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected
                                      ? Colors.white70
                                      : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Select Time Section
            const Text(
              'Select time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTimePeriod = 'Morning';
                        selectedTimeSlot =
                            ''; // Reset time slot when period changes
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedTimePeriod == 'Morning'
                              ? const Color(0xFF0D6EFD)
                              : Colors.grey[200],
                      foregroundColor:
                          selectedTimePeriod == 'Morning'
                              ? Colors.white
                              : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Morning'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTimePeriod = 'Afternoon';
                        selectedTimeSlot =
                            ''; // Reset time slot when period changes
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedTimePeriod == 'Afternoon'
                              ? const Color(0xFF0D6EFD)
                              : Colors.grey[200],
                      foregroundColor:
                          selectedTimePeriod == 'Afternoon'
                              ? Colors.white
                              : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Afternoon'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTimePeriod = 'Evening';
                        selectedTimeSlot =
                            ''; // Reset time slot when period changes
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedTimePeriod == 'Evening'
                              ? const Color(0xFF0D6EFD)
                              : Colors.grey[200],
                      foregroundColor:
                          selectedTimePeriod == 'Evening'
                              ? Colors.white
                              : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Evening'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (selectedTimePeriod.isEmpty
                          ? timeSlots
                          : timeSlotsByPeriod[selectedTimePeriod] ?? [])
                      .map((timeSlot) {
                        final isSelected = selectedTimeSlot == timeSlot;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimeSlot = timeSlot;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF0D6EFD).withOpacity(0.1)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFF0D6EFD)
                                        : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              timeSlot,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    isSelected
                                        ? const Color(0xFF0D6EFD)
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(),
            ),
            const SizedBox(height: 24),

            // Select Number of Hours Section
            const Text(
              'Select no. of hrs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  hourOptions.map((hour) {
                    final isSelected = selectedHours == hour;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedHours = hour;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF0D6EFD).withOpacity(0.1)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF0D6EFD)
                                    : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          hour,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isSelected
                                    ? const Color(0xFF0D6EFD)
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const Spacer(),
            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isFormValid
                        ? () {
                          // Navigate directly to payment screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PaymentScreen(
                                    service: widget.service,
                                    selectedDate: _getSelectedDate(),
                                    selectedTime: _getSelectedTime(),
                                    selectedHours: int.parse(
                                      selectedHours.split(' ')[0],
                                    ),
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFormValid ? const Color(0xFF0D6EFD) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _getSelectedDate() {
    // Get current date and add the selected date index
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + selectedDateIndex);
  }

  TimeOfDay _getSelectedTime() {
    // Parse the selected time slot (e.g., "08:30 am")
    final parts = selectedTimeSlot.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isAm = parts[1].toLowerCase() == 'am';

    return TimeOfDay(
      hour: isAm && hour == 12 ? 0 : (!isAm && hour != 12 ? hour + 12 : hour),
      minute: minute,
    );
  }
}
