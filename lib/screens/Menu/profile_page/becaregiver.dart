import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/user_details_store_services.dart';

class BeCaregiverPage extends StatefulWidget {
  const BeCaregiverPage({Key? key}) : super(key: key);

  @override
  State<BeCaregiverPage> createState() => _BeCaregiverPageState();
}

class _BeCaregiverPageState extends State<BeCaregiverPage> {
  final TextEditingController _applyLetterController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final UserDetailsStoreService _userService = UserDetailsStoreService();

  String? _selectedIdType;
  bool _isIdUploaded = false;
  String? _idFileName;
  bool _isSubmitting = false;
  bool _confirmInfo = false;
  bool _agreeTerms = false;

  final List<_CertificationFormData> _certifications = [
    _CertificationFormData(),
  ];

  @override
  void dispose() {
    _applyLetterController.dispose();
    _emergencyContactController.dispose();
    for (final cert in _certifications) {
      cert.dispose();
    }
    super.dispose();
  }

  void _addCertification() {
    setState(() {
      _certifications.add(_CertificationFormData());
    });
  }

  void _removeCertification(int index) {
    if (_certifications.length == 1) return;
    setState(() {
      final item = _certifications.removeAt(index);
      item.dispose();
    });
  }

  Future<void> _pickFile({required bool isIdUpload, int? certificationIndex}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final selected = result.files.single;
    final selectedName = selected.name;

    if (isIdUpload) {
      setState(() {
        _isIdUploaded = true;
        _idFileName = selectedName;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Government ID selected: $selectedName')),
      );
      return;
    }

    if (certificationIndex == null ||
        certificationIndex < 0 ||
        certificationIndex >= _certifications.length) {
      return;
    }

    setState(() {
      _certifications[certificationIndex].isUploaded = true;
      _certifications[certificationIndex].fileName = selectedName;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Certification ${certificationIndex + 1} selected: $selectedName',
        ),
      ),
    );
  }

  Future<void> _submitApplication() async {
    if (_selectedIdType == null || !_isIdUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete mandatory ID Verification before submitting.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final emergencyNumber = _emergencyContactController.text.trim();
    if (emergencyNumber.isNotEmpty &&
      !RegExp(r'^\d{10}$').hasMatch(emergencyNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency contact must be exactly 10 digits.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (final cert in _certifications) {
      final hasAnyValue =
          cert.nameController.text.trim().isNotEmpty ||
          cert.issuedByController.text.trim().isNotEmpty ||
          cert.isUploaded;

      if (!hasAnyValue) {
        continue;
      }

      if (cert.nameController.text.trim().isEmpty ||
          cert.issuedByController.text.trim().isEmpty ||
          !cert.isUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Complete certification name, issuer, and upload for each added certification.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (!_confirmInfo || !_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm information and agree to platform terms.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Collect certifications data
      final List<Map<String, dynamic>> certificationsData = [];
      for (final cert in _certifications) {
        if (cert.nameController.text.trim().isNotEmpty) {
          certificationsData.add({
            'name': cert.nameController.text.trim(),
            'issuedBy': cert.issuedByController.text.trim(),
            'fileName': cert.fileName ?? '',
          });
        }
      }

      // Call Firebase submission service
      await _userService.submitCaregiverApplication(
        idType: _selectedIdType!,
        idFileName: _idFileName ?? '',
        certifications: certificationsData,
        emergencyContact: emergencyNumber.isNotEmpty ? emergencyNumber : null,
        applyLetter: _applyLetterController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Caregiver application submitted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting application: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Be Caregiver',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Complete your caregiver details to start receiving care requests.',
                style: TextStyle(
                  color: Color(0xFF0D47A1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. ID Verification (MANDATORY)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload Government ID: Aadhaar / PAN / Driving License',
              style: TextStyle(color: Color(0xFF616161)),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedIdType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select ID Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Aadhaar', child: Text('Aadhaar')),
                DropdownMenuItem(value: 'PAN', child: Text('PAN')),
                DropdownMenuItem(
                  value: 'Driving License',
                  child: Text('Driving License'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedIdType = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _pickFile(isIdUpload: true);
                    },
                    icon: const Icon(Icons.upload_file),
                    label: Text(_isIdUploaded ? 'ID Uploaded' : 'Upload ID'),
                  ),
                ),
              ],
            ),
            if (_idFileName != null && _idFileName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Selected: $_idFileName',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            const Text(
              'Required for trust and approval',
              style: TextStyle(color: Color(0xFF616161), fontSize: 12),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. Certifications (OPTIONAL)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add certifications if available',
              style: TextStyle(color: Color(0xFF616161)),
            ),
            const SizedBox(height: 16),
            ...List.generate(_certifications.length, (index) {
              final cert = _certifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Certification ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (_certifications.length > 1)
                          IconButton(
                            onPressed: () => _removeCertification(index),
                            icon: const Icon(Icons.close, size: 20),
                            tooltip: 'Remove',
                          ),
                      ],
                    ),
                    TextField(
                      controller: cert.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Certification Name',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: cert.issuedByController,
                      decoration: const InputDecoration(labelText: 'Issued By'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _pickFile(
                                isIdUpload: false,
                                certificationIndex: index,
                              );
                            },
                            icon: const Icon(Icons.upload_file),
                            label: Text(
                              cert.isUploaded
                                  ? 'Certificate Uploaded'
                                  : 'Upload Certificate',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (cert.fileName != null && cert.fileName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Selected: ${cert.fileName}',
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addCertification,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Certification'),
            ),
            const SizedBox(height: 14),
            const SizedBox(height: 8),
            TextField(
              controller: _applyLetterController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Apply Letter (optional but recommended)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Emergency Contact (Recommended)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emergencyContactController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Emergency Contact Number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Builds trust',
              style: TextStyle(color: Color(0xFF616161), fontSize: 12),
            ),
            const SizedBox(height: 20),
            const Text(
              '8. Agreement Section',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _confirmInfo,
              onChanged: (value) {
                setState(() {
                  _confirmInfo = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'I confirm all information is correct',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: _agreeTerms,
              onChanged: (value) {
                setState(() {
                  _agreeTerms = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'I agree to platform terms',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Application',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificationFormData {
  _CertificationFormData();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController issuedByController = TextEditingController();
  bool isUploaded = false;
  String? fileName;

  void dispose() {
    nameController.dispose();
    issuedByController.dispose();
  }
}
