import 'package:flutter/material.dart';

class DocumentsPrescriptionsScreen extends StatelessWidget {
  const DocumentsPrescriptionsScreen({super.key});

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
          'Documents & Prescriptions',
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
        child: Column(
          children: [
            // Caregiver Profile Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/caregiver_profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Icon(Icons.person, size: 30, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  // Name and Role
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Caregiver',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF777777),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Section Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '📄 Manage Your Medical Files',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Document List Items
            DocumentCard(
              icon: Icons.note_add,
              iconColor: const Color(0xFF9C27B0), // Purple
              title: 'Doctor\'s Notes',
              description: 'Store & review medical advice',
              timestamp: 'Last updated: 2 hours ago',
              progress: 70,
              progressColor: const Color(0xFF9C27B0),
            ),
            
            DocumentCard(
              icon: Icons.share,
              iconColor: const Color(0xFF3F51B5), // Blue
              title: 'File Sharing',
              description: 'Send records to healthcare providers',
              timestamp: 'Last updated: 1 day ago',
              progress: 60,
              progressColor: const Color(0xFF3F51B5),
            ),
            
            DocumentCard(
              icon: Icons.description,
              iconColor: const Color(0xFFFB8C00), // Orange
              title: 'Lab Reports',
              description: 'View & track test results',
              timestamp: 'Last updated: 3 days ago',
              progress: 75,
              progressColor: const Color(0xFFFB8C00),
            ),
            
            DocumentCard(
              icon: Icons.file_present,
              iconColor: const Color(0xFF009688), // Teal
              title: 'Insurance Documents',
              description: 'Manage medical insurance files',
              timestamp: 'Last updated: 1 week ago',
              progress: 50,
              progressColor: const Color(0xFF009688),
            ),
            
            DocumentCard(
              icon: Icons.contact_emergency,
              iconColor: const Color(0xFFF44336), // Red
              title: 'Emergency Contact Info',
              description: 'Store emergency medical details',
              timestamp: 'Last updated: 2 hours ago',
              progress: 95,
              progressColor: const Color(0xFFF44336),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String timestamp;
  final int progress;
  final Color progressColor;

  const DocumentCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            // Handle document tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opened: $title')),
            );
          },
          splashColor: Colors.blue.withOpacity(0.1),
          child: Row(
            children: [
              // Left Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Center Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Right Progress Indicator
              _CircularProgressIndicator(
                progress: progress,
                color: progressColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularProgressIndicator extends StatelessWidget {
  final int progress;
  final Color color;

  const _CircularProgressIndicator({
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        children: [
          // Background circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 4,
              ),
            ),
          ),
          // Progress circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 4,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$progress%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
