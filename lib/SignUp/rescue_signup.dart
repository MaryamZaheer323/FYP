import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Dashboard/rescue_dashboard.dart';

class RescueSignupScreen extends StatefulWidget {
  const RescueSignupScreen({super.key});

  @override
  State<RescueSignupScreen> createState() => _RescueSignupScreenState();
}

class _RescueSignupScreenState extends State<RescueSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _serviceIdController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();

  // Files storage
  final Map<String, XFile?> _files = {
    'scannedCNIC': null,
    'rescueIDCardFront': null,
    'rescueIDCardBack': null,
    'appointmentLetter': null,
    'recentPhotograph': null,
  };

  Future<void> _pickFile(String fileType) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _files[fileType] = file;
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
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
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

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Collect all user data
      final userData = {
        'name': _nameController.text.trim(),
        'fatherName': _fatherNameController.text.trim(),
        'dateOfBirth': _dobController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'department': _departmentController.text.trim(),
        'rank': _rankController.text.trim(),
        'badgeNumber': _badgeController.text.trim(),
        'serviceId': _serviceIdController.text.trim(),
        'station': _stationController.text.trim(),
        'joiningDate': _joiningDateController.text.trim(),
        'role': 'RESCUE OFFICER',
      };

      // Navigate to RescueDashboard with user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RescueDashboard(userData: userData),
        ),
      );
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
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
    if (today.month < birthMonth || (today.month == birthMonth && today.day < birthDay)) {
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
            colors: [
              Colors.black,
              Color(0xFF0A0E21),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      'Rescue Service Registration',
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
                        label: 'Official Email (@rescue.gov.pk)',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.endsWith('@rescue.gov.pk')) {
                            return 'Email must end with @rescue.gov.pk';
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
                          if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
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
                        'Rescue Service Department Information',
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
                        label: 'Rescue Department/Unit',
                        icon: Icons.health_and_safety,
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
                        label: 'Rescue Station/Posting Location',
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
                        label: 'Joining Date in Rescue Service',
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

                      _buildFileUploadCard('Scanned CNIC', 'scannedCNIC', Icons.credit_card),
                      _buildFileUploadCard('Rescue Service ID Card (Front)', 'rescueIDCardFront', Icons.badge),
                      _buildFileUploadCard('Rescue Service ID Card (Back)', 'rescueIDCardBack', Icons.badge),
                      _buildFileUploadCard('Appointment/Service Letter', 'appointmentLetter', Icons.description),
                      _buildFileUploadCard('Recent Photograph', 'recentPhotograph', Icons.camera_alt),

                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
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
        prefixIcon: Icon(icon, color: Colors.red),
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
          color: isUploaded ? Colors.green : Colors.red,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
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