import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int? selectedBarIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
            // Card Section - 3 Insight Cards
            _buildInsightCard(
              icon: Icons.card_giftcard,
              iconColor: const Color(0xFF9C27B0), // Purple
              title: 'Get bonus \$200 this month!',
              subtitle: '61 days attendance',
              subtitleIcon: Icons.calendar_today,
              progressColor: const Color(0xFF9C27B0),
              progressValue: 0.8,
            ),

            const SizedBox(height: 16),

            _buildInsightCard(
              icon: Icons.description,
              iconColor: const Color(0xFF2196F3), // Blue
              title: 'Generate custom reports',
              subtitle: 'Easy parent communication',
              subtitleIcon: Icons.message,
              progressColor: const Color(0xFF2196F3),
              progressValue: 0.65,
            ),

            const SizedBox(height: 16),

            _buildInsightCard(
              icon: Icons.emoji_events,
              iconColor: const Color(0xFFFF9800), // Orange
              title: 'Achieve Top Performer',
              subtitle: 'Consistent high performance',
              subtitleIcon: Icons.trending_up,
              progressColor: const Color(0xFFFF9800),
              progressValue: 0.7,
            ),

            const SizedBox(height: 32),

            // Enrollment Statistics Section
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Color(0xFF1976D2), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Enrollment Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bar Chart
            _buildBarChart(selectedBarIndex),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required IconData subtitleIcon,
    required Color progressColor,
    required double progressValue,
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          subtitleIcon,
                          color: const Color(0xFF757575),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressValue,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(int? selectedIndex) {
    final List<String> months = [
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
    ];
    final List<double> values = [
      12.0,
      15.0,
      18.0,
      14.0,
      18.0,
      22.0,
      16.0,
      20.0,
      14.0,
    ];
    final List<Color> colors = [
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF2196F3), // Blue
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFF9800), // Orange
      const Color(0xFFF44336), // Red
      const Color(0xFF009688), // Teal
      const Color(0xFFE91E63), // Pink
      const Color(0xFF3F51B5), // Navy
      const Color(0xFFFFEB3B), // Yellow
    ];

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chart Area with Y-axis
          Expanded(
            child: Row(
              children: [
                // Left spacing for bars
                const SizedBox(width: 20),

                // Bars and Y-axis together
                Expanded(
                  child: Row(
                    children: [
                      // Bars area
                      Expanded(
                        child: Stack(
                          children: [
                            // Bars
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom:
                                  20, // Further reduced space for X-axis labels
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(months.length, (index) {
                                  final isSelected = selectedIndex == index;
                                  final barHeight =
                                      (values[index] / 25.0) *
                                      180; // Increased to match Y-axis scale better

                                  return MouseRegion(
                                    onEnter: (_) {
                                      setState(() {
                                        selectedBarIndex = index;
                                      });
                                    },
                                    onExit: (_) {
                                      setState(() {
                                        selectedBarIndex = null;
                                      });
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedBarIndex =
                                              isSelected ? null : index;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Tooltip for selected/hovered bar
                                          if (isSelected)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1976D2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${values[index].toStringAsFixed(1)}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ),

                                          // Bar
                                          Container(
                                            width: 20,
                                            height: barHeight,
                                            decoration: BoxDecoration(
                                              color: colors[index],
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(8),
                                                  ),
                                              boxShadow:
                                                  isSelected
                                                      ? [
                                                        BoxShadow(
                                                          color: colors[index]
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          blurRadius: 8,
                                                          spreadRadius: 2,
                                                        ),
                                                      ]
                                                      : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),

                            // Y-axis labels positioned right next to bars
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 20, // Align with bars bottom
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    '25',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const Text(
                                    '20',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const Text(
                                    '15',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const Text(
                                    '10',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Small spacing between bars and Y-axis
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // X-axis labels positioned right below bars
          SizedBox(
            height: 20, // Further reduced height for tighter alignment
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  months.map((month) {
                    return Text(
                      month,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                        fontFamily: 'Roboto',
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
