import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  void _openFullDetailsScreen(
    BuildContext context,
    String applicationId,
    Map<String, dynamic> data,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationDetailsPage(
          applicationId: applicationId,
          applicationData: data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('caregivers')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading applications: ${snapshot.error}'),
            );
          }

          final docs = (snapshot.data?.docs ?? []).toList()
            ..sort((a, b) {
              final aTs = a.data()['submittedAt'] as Timestamp?;
              final bTs = b.data()['submittedAt'] as Timestamp?;

              if (aTs == null && bTs == null) return 0;
              if (aTs == null) return 1;
              if (bTs == null) return -1;

              return bTs.compareTo(aTs);
            });

          if (docs.isEmpty) {
            return const Center(
              child: Text('No pending caregiver applications'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final String userEmail =
                  (data['userEmail'] ?? 'Unknown user').toString();
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Caregiver Role Applied',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$userEmail applied for caregiver role.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            _openFullDetailsScreen(context, doc.id, data),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          elevation: 1,
                          minimumSize: const Size(double.infinity, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View Full Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ApplicationDetailsPage extends StatelessWidget {
  const ApplicationDetailsPage({
    super.key,
    required this.applicationId,
    required this.applicationData,
  });

  final String applicationId;
  final Map<String, dynamic> applicationData;

  bool _isLikelyImageUrl(String value) {
    final Uri? uri = Uri.tryParse(value);
    if (uri == null || (!uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https'))) {
      return false;
    }

    final lowerValue = value.toLowerCase();
    return lowerValue.contains('.png') ||
        lowerValue.contains('.jpg') ||
        lowerValue.contains('.jpeg') ||
        lowerValue.contains('.webp') ||
        lowerValue.contains('.gif') ||
        lowerValue.contains('firebasestorage.googleapis.com');
  }

  Widget _buildImageOrTextFile({required String fileValue}) {
    if (fileValue.trim().isEmpty || fileValue == 'Not provided' || fileValue == 'No file') {
      return const Text('Not provided');
    }

    if (!_isLikelyImageUrl(fileValue)) {
      return Text(fileValue);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        fileValue,
        height: 170,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text('Unable to load image link'),
          );
        },
      ),
    );
  }

  Future<void> _updateApplicationStatus({
    required BuildContext context,
    required bool isApproved,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String userId = (applicationData['userId'] ?? '').toString();

      await firestore.collection('caregivers').doc(applicationId).update({
        'status': isApproved ? 'accepted' : 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (isApproved && userId.isNotEmpty) {
        await firestore.collection('users').doc(userId).update({
          'role': 'caregiver',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isApproved
                  ? 'Application accepted successfully'
                  : 'Application rejected successfully',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update application: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String idType = (applicationData['idType'] ?? 'Not provided').toString();
    final String idFileName =
        (applicationData['idFileName'] ?? 'Not provided').toString();
    final String applyLetter =
        (applicationData['applyLetter'] ?? 'Not provided').toString().trim().isEmpty
            ? 'Not provided'
            : applicationData['applyLetter'].toString();
    final String emergencyContact =
        (applicationData['emergencyContact'] ?? 'Not provided')
                .toString()
                .trim()
                .isEmpty
            ? 'Not provided'
            : applicationData['emergencyContact'].toString();
    final String userEmail =
        (applicationData['userEmail'] ?? 'Unknown user').toString();

    final List<dynamic> certificationsRaw =
        (applicationData['certifications'] as List<dynamic>?) ?? <dynamic>[];
    final List<Map<String, String>> certifications = certificationsRaw
        .map((item) {
          if (item is Map<String, dynamic>) {
            return {
              'name': (item['name'] ?? 'Certificate').toString(),
              'fileName': (item['fileName'] ?? 'No file').toString(),
            };
          }
          return {
            'name': 'Certificate',
            'fileName': item.toString(),
          };
        })
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Caregiver Role Applied',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: $userEmail applied for caregiver role.'),
                    const SizedBox(height: 12),
                    Text('ID Type: $idType'),
                    const SizedBox(height: 8),
                    const Text(
                      'ID File:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    _buildImageOrTextFile(fileValue: idFileName),
                    const SizedBox(height: 8),
                    Text('Emergency Contact: $emergencyContact'),
                    const SizedBox(height: 8),
                    Text('Application Letter: $applyLetter'),
                    const SizedBox(height: 12),
                    const Text(
                      'Certifications:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    if (certifications.isEmpty)
                      const Text('No certifications uploaded')
                    else
                      ...certifications.map(
                        (cert) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cert['name'] ?? 'Certificate',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              _buildImageOrTextFile(
                                fileValue: cert['fileName'] ?? 'No file',
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _updateApplicationStatus(context: context, isApproved: false),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _updateApplicationStatus(context: context, isApproved: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}