import 'package:flutter/material.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({Key? key}) : super(key: key);

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  DateTime _startDate = DateTime(2026, 1, 31);
  DateTime _endDate = DateTime(2026, 2, 6);

  void _previousWeek() {
    setState(() {
      _startDate = _startDate.subtract(const Duration(days: 7));
      _endDate = _endDate.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _startDate = _startDate.add(const Duration(days: 7));
      _endDate = _endDate.add(const Duration(days: 7));
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A84FF),
        elevation: 4,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Earnings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0A84FF),
              size: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date Range Selector
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _previousWeek,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF0A84FF),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_formatDate(_startDate)} – ${_formatDate(_endDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _nextWeek,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF0A84FF),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Current Balance Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Balance (₹)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$1,250.75',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Next Payout: Jan 15, 2025',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Earnings Breakdown Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildEarningsRow('Total Deliveries', '52'),
                  _buildDivider(),
                  _buildEarningsRow('Hours Worked', '48 Hours 15 Minutes'),
                  _buildDivider(),
                  _buildEarningsRow('Base Fare', '\$820.00'),
                  _buildDivider(),
                  _buildEarningsRow('Distance Earnings', '\$220.50'),
                  _buildDivider(),
                  _buildEarningsRow('Tips Received', '\$85.75'),
                  _buildDivider(),
                  _buildEarningsRow('Bonuses', '\$125.00'),
                  _buildDivider(),
                  _buildEarningsRow('Referral Bonus', '\$100.00'),
                  _buildDivider(),
                  _buildEarningsRow('Surge Earnings', '\$50.00'),
                  _buildDivider(),
                  _buildEarningsRow(
                    'Total Earnings',
                    '\$1,250.75',
                    isHighlighted: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Footer Action
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Full earnings details coming soon!'),
                    backgroundColor: Color(0xFF0A84FF),
                  ),
                );
              },
              child: const Text(
                'See Full Details',
                style: TextStyle(
                  color: Color(0xFF0A84FF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? const Color(0xFF0A84FF) : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? const Color(0xFF0A84FF) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE0E0E0),
      indent: 20,
      endIndent: 20,
    );
  }
}
