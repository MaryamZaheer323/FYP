import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userRole;

  const EditProfileScreen({
    super.key,
    required this.userData,
    required this.userRole,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _dobController;
  late TextEditingController _cnicController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _rankController;
  late TextEditingController _badgeController;
  late TextEditingController _serviceIdController;
  late TextEditingController _stationController;
  late TextEditingController _departmentController;
  late TextEditingController _joiningDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    _fatherNameController = TextEditingController(text: widget.userData['fatherName'] ?? '');
    _dobController = TextEditingController(text: widget.userData['dateOfBirth'] ?? '');
    _cnicController = TextEditingController(text: widget.userData['cnic'] ?? '');
    _phoneController = TextEditingController(text: widget.userData['phone'] ?? '');
    _emailController = TextEditingController(text: widget.userData['email'] ?? '');
    _rankController = TextEditingController(text: widget.userData['rank'] ?? '');
    _badgeController = TextEditingController(text: widget.userData['badgeNumber'] ?? '');
    _serviceIdController = TextEditingController(text: widget.userData['serviceId'] ?? '');
    _stationController = TextEditingController(text: widget.userData['station'] ?? '');
    _departmentController = TextEditingController(text: widget.userData['department'] ?? '');
    _joiningDateController = TextEditingController(text: widget.userData['joiningDate'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _rankController.dispose();
    _badgeController.dispose();
    _serviceIdController.dispose();
    _stationController.dispose();
    _departmentController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  Color _getThemeColor() {
    switch (widget.userRole) {
      case 'Police':
        return Colors.blueAccent;
      case 'Fire Brigade':
        return Colors.deepOrange;
      case 'Rescue':
        return Colors.red;
      case 'Traffic Police':
        return Colors.orange;
      default:
        return Colors.blueAccent;
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameController.text.trim(),
        'fatherName': _fatherNameController.text.trim(),
        'dateOfBirth': _dobController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'rank': _rankController.text.trim(),
        'badgeNumber': _badgeController.text.trim(),
        'serviceId': _serviceIdController.text.trim(),
        'station': _stationController.text.trim(),
        'department': _departmentController.text.trim(),
        'joiningDate': _joiningDateController.text.trim(),
        'role': widget.userData['role'] ?? 'FIRE OFFICER',
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfilePhoto(themeColor),
            const SizedBox(height: 20),
            _buildPersonalInfoSection(themeColor),
            const SizedBox(height: 15),
            _buildProfessionalInfoSection(themeColor),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(Color themeColor) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: themeColor.withOpacity(0.2),
                child: Icon(Icons.person, size: 50, color: themeColor),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Tap to change photo', style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(Color themeColor) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: themeColor, size: 24),
              const SizedBox(width: 10),
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  themeColor: themeColor,
                  validator: (value) => value == null || value.isEmpty ? 'Full Name is required' : null,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _fatherNameController,
                  label: "Father's Name",
                  icon: Icons.family_restroom,
                  themeColor: themeColor,
                  validator: (value) => value == null || value.isEmpty ? "Father's Name is required" : null,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  icon: Icons.calendar_today,
                  themeColor: themeColor,
                  readOnly: true,
                  onTap: () => _selectDate(_dobController),
                  validator: (value) => value == null || value.isEmpty ? 'Date of Birth is required' : null,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _cnicController,
                  label: 'CNIC Number',
                  icon: Icons.credit_card,
                  themeColor: themeColor,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'CNIC Number is required';
                    if (value.length != 13) return 'CNIC must be 13 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Contact Number',
                  icon: Icons.phone,
                  themeColor: themeColor,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Phone number is required';
                    if (value.length != 11) return 'Phone must be 11 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  themeColor: themeColor,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoSection(Color themeColor) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work, color: themeColor, size: 24),
              const SizedBox(width: 10),
              const Text('Professional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildTextField(
                controller: _departmentController,
                label: 'Department/Unit',
                icon: Icons.business,
                themeColor: themeColor,
                validator: (value) => value == null || value.isEmpty ? 'Department is required' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _rankController,
                label: 'Rank/Designation',
                icon: Icons.military_tech,
                themeColor: themeColor,
                validator: (value) => value == null || value.isEmpty ? 'Rank is required' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _badgeController,
                label: 'Badge/Belt Number',
                icon: Icons.confirmation_number,
                themeColor: themeColor,
                validator: (value) => value == null || value.isEmpty ? 'Badge number is required' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _serviceIdController,
                label: 'Service/Employee ID',
                icon: Icons.badge,
                themeColor: themeColor,
                validator: (value) => value == null || value.isEmpty ? 'Service ID is required' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _stationController,
                label: 'Station/Posting Location',
                icon: Icons.location_on,
                themeColor: themeColor,
                validator: (value) => value == null || value.isEmpty ? 'Station is required' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _joiningDateController,
                label: 'Joining Date',
                icon: Icons.date_range,
                themeColor: themeColor,
                readOnly: true,
                onTap: () => _selectDate(_joiningDateController),
                validator: (value) => value == null || value.isEmpty ? 'Joining date is required' : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color themeColor,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: themeColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const _GlassContainer({required this.child, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: child,
    );
  }
}