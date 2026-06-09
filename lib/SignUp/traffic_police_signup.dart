import 'dart:io';
import 'package:disaster_watch/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Dashboard/traffic_police_dashboard.dart';

class TrafficPoliceSignupScreen extends StatefulWidget {
  const TrafficPoliceSignupScreen({super.key});

  @override
  State<TrafficPoliceSignupScreen> createState() =>
      _TrafficPoliceSignupScreenState();
}

class _TrafficPoliceSignupScreenState extends State<TrafficPoliceSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

final TextEditingController _nameController =
    TextEditingController(text: "Maryam Malik");

final TextEditingController _fatherNameController =
    TextEditingController(text: "Maryam Malik");

final TextEditingController _dobController =
    TextEditingController(text: "15-08-1990");

final TextEditingController _cnicController =
    TextEditingController(text: "3740512345671");

final TextEditingController _phoneController =
    TextEditingController(text: "03001234567");

final TextEditingController _emailController =
    TextEditingController(text: "maryamtraffic@trafficpolice.gov.pk");

final TextEditingController _passwordController =
    TextEditingController(text: "Younis@ns2828");

final TextEditingController _confirmPasswordController =
    TextEditingController(text: "Younis@ns2828");

final TextEditingController _departmentController =
    TextEditingController(text: "Investigation Department");

final TextEditingController _rankController =
    TextEditingController(text: "Inspector");

final TextEditingController _badgeController =
    TextEditingController(text: "INS-4587");

final TextEditingController _serviceIdController =
    TextEditingController(text: "POL-2020-001");

final TextEditingController _stationController =
    TextEditingController(text: "Rawalpindi Central Police Station");

final TextEditingController _joiningDateController =
    TextEditingController(text: "01-01-2020");

  // Files storage
  final Map<String, File?> _files = {
    'scannedCNIC': null,
    'trafficPoliceIDCardFront': null,
    'trafficPoliceIDCardBack': null,
    'appointmentLetter': null,
    'recentPhotograph': null,
  };

  Future<void> _pickFile(String fileType) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _files[fileType] = File(file.path);
        });
        _showMessage('Success', 'File uploaded successfully ✅');
      }
    } catch (e) {
      _showMessage('Error', 'Failed to pick file: $e');
    }
  }

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: title == 'Success' ? Colors.green : Colors.red,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // In TrafficPoliceSignupScreen

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Collect all user data
        final userData = {
          'name': _nameController.text.trim(),
          'fatherName': _fatherNameController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
          'cnic': _cnicController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(), // Add password
          'department': _departmentController.text.trim(),
          'rank': _rankController.text.trim(),
          'badgeNumber': _badgeController.text.trim(),
          'serviceId': _serviceIdController.text.trim(),
          'station': _stationController.text.trim(),
          'joiningDate': _joiningDateController.text.trim(),
          'role': 'TRAFFIC OFFICER',
        };

        // Register using FirestoreService
        await _firestoreService.registerTrafficOfficer(userData, _files);

        // Show success message
        _showMessage(
          'Success',
          'Registration successful! Please wait for admin approval.',
        );

        // Navigate to login after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        });
      } catch (e) {
        _showMessage('Error', e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  int _calculateAge(String dob) {
    if (dob.isEmpty) return 0;
    List<String> parts = dob.split('-');
    if (parts.length != 3) return 0;
    int birthYear = int.parse(parts[0]);
    int birthMonth = int.parse(parts[1]);
    int birthDay = int.parse(parts[2]);

    DateTime today = DateTime.now();
    int age = today.year - birthYear;
    if (today.month < birthMonth ||
        (today.month == birthMonth && today.day < birthDay)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0A0E21), Color(0xFF1A1A2E)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Traffic Police Registration',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _fatherNameController,
                        label: "Father's Name",
                        icon: Icons.family_restroom,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Father's Name is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        icon: Icons.calendar_today,
                        onTap: () => _selectDate(_dobController),
                        readOnly: true,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Date of Birth is required';
                          }
                          int age = _calculateAge(value);
                          if (age < 22) {
                            return 'Age must be 22 years or above (Current age: $age years)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _cnicController,
                        label: 'CNIC Number',
                        icon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'CNIC Number is required';
                          }
                          if (value.length != 13) {
                            return 'CNIC Number must be exactly 13 digits';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'CNIC Number must contain only numbers';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Contact Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact Number is required';
                          }
                          if (value.length != 11) {
                            return 'Contact Number must be exactly 11 digits';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Contact Number must contain only numbers';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Official Email (@trafficpolice.gov.pk)',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.endsWith('@trafficpolice.gov.pk')) {
                            return 'Email must end with @trafficpolice.gov.pk';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter (A-Z)';
                          }
                          if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter (a-z)';
                          }
                          if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                            return 'Password must contain at least one number (0-9)';
                          }
                          if (!RegExp(
                            r'(?=.*[!@#$%^&*(),.?":{}|<>])',
                          ).hasMatch(value)) {
                            return 'Password must contain at least one special character (!@#\$%^&*)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock,
                        obscureText: true,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),
                      const Divider(color: Colors.white30),
                      const SizedBox(height: 20),

                      const Text(
                        'Traffic Police Department Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _departmentController,
                        label: 'Traffic Police Department/Unit',
                        icon: Icons.traffic,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Department is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _rankController,
                        label: 'Rank/Designation',
                        icon: Icons.military_tech,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Rank is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _badgeController,
                        label: 'Badge/Belt Number',
                        icon: Icons.confirmation_number,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Badge Number is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _serviceIdController,
                        label: 'Service/Employee ID',
                        icon: Icons.badge,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Service ID is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _stationController,
                        label: 'Traffic Police Station/Posting Location',
                        icon: Icons.location_on,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Station is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _joiningDateController,
                        label: 'Joining Date in Traffic Police',
                        icon: Icons.date_range,
                        onTap: () => _selectDate(_joiningDateController),
                        readOnly: true,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Joining Date is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),
                      const Divider(color: Colors.white30),
                      const SizedBox(height: 20),

                      const Text(
                        'Verification Documents',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildFileUploadCard(
                        'Scanned CNIC',
                        'scannedCNIC',
                        Icons.credit_card,
                      ),
                      _buildFileUploadCard(
                        'Traffic Police ID Card (Front)',
                        'trafficPoliceIDCardFront',
                        Icons.badge,
                      ),
                      _buildFileUploadCard(
                        'Traffic Police ID Card (Back)',
                        'trafficPoliceIDCardBack',
                        Icons.badge,
                      ),
                      _buildFileUploadCard(
                        'Appointment/Service Letter',
                        'appointmentLetter',
                        Icons.description,
                      ),
                      _buildFileUploadCard(
                        'Recent Photograph',
                        'recentPhotograph',
                        Icons.camera_alt,
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .deepOrange, // Change color as per your theme
                            foregroundColor: Colors.white,
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.6,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'REGISTER',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    bool readOnly = false,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildFileUploadCard(String title, String fileKey, IconData icon) {
    bool isUploaded = _files[fileKey] != null;
    String fileName = isUploaded ? _files[fileKey]!.path.split('/').last : '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withOpacity(0.05),
      child: ListTile(
        leading: Icon(
          isUploaded ? Icons.check_circle : icon,
          color: isUploaded ? Colors.green : Colors.orange,
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: isUploaded
            ? Text(
                fileName,
                style: const TextStyle(color: Colors.green),
                overflow: TextOverflow.ellipsis,
              )
            : const Text(
                'Tap to upload image',
                style: TextStyle(color: Colors.white70),
              ),
        trailing: isUploaded
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _files[fileKey] = null;
                  });
                  _showMessage('Deleted', 'File removed successfully');
                },
              )
            : null,
        onTap: () => _pickFile(fileKey),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _departmentController.dispose();
    _rankController.dispose();
    _badgeController.dispose();
    _serviceIdController.dispose();
    _stationController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }
}
