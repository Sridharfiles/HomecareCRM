import 'package:flutter/material.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  DateTime selectedDate = DateTime(2025, 12, 20); // December 20, 2025
  DateTime currentMonth = DateTime(2025, 12, 1); // December 2025

  // Calendar data for December 2025
  final List<List<int>> calendarDays = [
    [29, 30, 1, 2, 3, 4, 5], // Week 1 (Nov 29, 30 in light grey)
    [6, 7, 8, 9, 10, 11, 12], // Week 2
    [13, 14, 15, 16, 17, 18, 19], // Week 3
    [20, 21, 22, 23, 24, 25, 26], // Week 4 (20 is selected)
    [27, 28, 29, 30, 31, 1, 2], // Week 5 (Jan 1, 2 in light grey)
  ];

  final List<String> weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  void previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void selectDate(int day) {
    setState(() {
      selectedDate = DateTime(currentMonth.year, currentMonth.month, day);
    });
  }

  bool isPreviousMonth(int day, int weekIndex) {
    if (weekIndex == 0) return day >= 29; // Nov 29, 30
    return false;
  }

  bool isNextMonth(int day, int weekIndex) {
    if (weekIndex == 4) return day <= 2; // Jan 1, 2
    return false;
  }

  bool isWeekend(int dayIndex) {
    return dayIndex == 0 || dayIndex == 6; // Sunday or Saturday
  }

  bool isSelected(int day) {
    return day == selectedDate.day &&
        currentMonth.month == selectedDate.month &&
        currentMonth.year == selectedDate.year;
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
          'Availability',
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
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Calendar Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Calendar Header
                Row(
                  children: [
                    IconButton(
                      onPressed: previousMonth,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: nextMonth,
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF1976D2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '2 weeks',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1976D2),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Weekdays Row
                Row(
                  children:
                      weekdays.map((day) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isWeekend(weekdays.indexOf(day))
                                        ? const Color(0xFFD32F2F)
                                        : const Color(0xFF757575),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 8),

                // Calendar Grid
                Column(
                  children:
                      calendarDays.asMap().entries.map((entry) {
                        int weekIndex = entry.key;
                        List<int> week = entry.value;

                        return Row(
                          children:
                              week.asMap().entries.map((dayEntry) {
                                int dayIndex = dayEntry.key;
                                int day = dayEntry.value;

                                bool isPrevMonth = isPreviousMonth(
                                  day,
                                  weekIndex,
                                );
                                bool isNextMonthDay = isNextMonth(
                                  day,
                                  weekIndex,
                                );
                                bool isSelectedDate = isSelected(day);
                                bool isWeekendDay = isWeekend(dayIndex);

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!isPrevMonth && !isNextMonthDay) {
                                        selectDate(day);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color:
                                            isSelectedDate
                                                ? const Color(0xFF7B61FF)
                                                : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$day',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                isSelectedDate
                                                    ? Colors.white
                                                    : isPrevMonth ||
                                                        isNextMonthDay
                                                    ? const Color(0xFFE0E0E0)
                                                    : isWeekendDay
                                                    ? const Color(0xFFD32F2F)
                                                    : const Color(0xFF212121),
                                            fontWeight:
                                                isSelectedDate
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Availability Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Available Slots for ${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No available time slots for this date.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Primary Action Button
          Container(
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Handle booking confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking confirmed!'),
                    backgroundColor: Color(0xFF1976D2),
                  ),
                );
              },
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
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
