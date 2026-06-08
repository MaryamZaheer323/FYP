 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportIncidentScreen extends StatefulWidget {
final Map<String, dynamic> userData; 
  
  const ReportIncidentScreen({super.key, required this.userData});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  List<XFile> _images = [];
  String? _selectedDepartment;
  String? _selectedType;
  bool _isLiveLocationEnabled = false;
  double? _latitude;
  double? _longitude;
  bool _isGettingLocation = false;
  bool _isSubmitting = false;

  final List<String> _departments = [
    'Police',
    'Traffic Police', 
    'Fire Brigade',
    'Rescue Service'
  ];

  final List<String> _incidentTypes = [
    'Fire',
    'Accident',
    'Theft',
    'Medical Emergency',
    'Natural Disaster',
    'Violence',
    'Traffic Jam',
    'Other',
  ];

  void _showMessage(String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
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

  Future<void> _toggleLiveLocation() async {
    if (!_isLiveLocationEnabled) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Location Error', 'Please enable location services', isError: true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showMessage('Permission Error', 'Location permission denied', isError: true);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage('Permission Error', 'Location permission permanently denied', isError: true);
        return;
      }

      setState(() {
        _isGettingLocation = true;
      });

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _isLiveLocationEnabled = true;
          _isGettingLocation = false;
        });
        _showMessage('Live Location Enabled',
            'Location: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}');
      } catch (e) {
        setState(() {
          _isGettingLocation = false;
        });
        _showMessage('Error', 'Failed to get location: $e', isError: true);
      }
    } else {
      setState(() {
        _isLiveLocationEnabled = false;
        _latitude = null;
        _longitude = null;
      });
      _showMessage('Live Location Disabled', 'Location tracking has been turned off');
    }
  }

  Future<void> _pickImages() async {
    if (_images.length >= 3) {
      _showMessage('Limit Reached', 'You can only upload maximum 3 images', isError: true);
      return;
    }
    
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        int remainingSlots = 3 - _images.length;
        int imagesToAdd = images.length > remainingSlots ? remainingSlots : images.length;
        
        setState(() {
          _images.addAll(images.take(imagesToAdd));
        });
        _showMessage('Success', '$imagesToAdd images added (Max 3)');
      }
    } catch (e) {
      _showMessage('Error', 'Failed to pick images: $e', isError: true);
    }
  }

  Future<void> _submitReport() async {
    // Validation
    if (_selectedDepartment == null) {
      _showMessage('Error', 'Please select a target department', isError: true);
      return;
    }

    if (_selectedType == null) {
      _showMessage('Error', 'Please select incident type', isError: true);
      return;
    }

    if (_descriptionController.text.isEmpty) {
      _showMessage('Error', 'Please enter description', isError: true);
      return;
    }

    if (!_isLiveLocationEnabled || _latitude == null || _longitude == null) {
      _showMessage('Error', 'Please enable live location first', isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare image paths (convert XFile to paths)
      List<String> imagePaths = _images.map((img) => img.path).toList();
      
      // Prepare report data
      final reportData = {
        'citizenName': widget.userData['name'] ?? 'Unknown',
        'citizenEmail': widget.userData['email'] ?? '',
        'citizenCNIC': widget.userData['cnic'] ?? '',
        'citizenPhone': widget.userData['phone'] ?? '',
        'department': _selectedDepartment,
        'type': _selectedType,
        'description': _descriptionController.text.trim(),
        'affectedPeople': _peopleController.text.trim().isEmpty ? 0 : int.parse(_peopleController.text.trim()),
        'latitude': _latitude,
        'longitude': _longitude,
        'location': '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
        'images': imagePaths,
        'imageCount': imagePaths.length,
        'status': 'pending', // pending, in-progress, resolved, rejected
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
        'reportId': '',
      };

      // Add to Firestore based on selected department
      DocumentReference docRef;
      switch (_selectedDepartment) {
        case 'Police':
          docRef = await _firestore.collection('police_reports').add(reportData);
          break;
        case 'Traffic Police':
          docRef = await _firestore.collection('traffic_reports').add(reportData);
          break;
        case 'Fire Brigade':
          docRef = await _firestore.collection('fire_reports').add(reportData);
          break;
        case 'Rescue Service':
          docRef = await _firestore.collection('rescue_reports').add(reportData);
          break;
        default:
          docRef = await _firestore.collection('general_reports').add(reportData);
      }
      
      // Update report with ID
      await docRef.update({'reportId': docRef.id});
      
      // Also add to citizen's personal reports collection
      await _firestore.collection('citizen_reports').add({
        ...reportData,
        'citizenId': widget.userData['email'],
        'reportRef': docRef.path,
      });

      _showMessage('Success',
          'Report submitted successfully to $_selectedDepartment!\n\n'
          'Report ID: ${docRef.id}\n'
          'Type: $_selectedType\n'
          'Location: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}\n'
          'Images: ${_images.length}'
      );

      // Clear form after successful submission
      _clearFormData();
      
      // Navigate back after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
      
    } catch (e) {
      _showMessage('Error', 'Failed to submit report: $e', isError: true);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearFormData() {
    setState(() {
      _descriptionController.clear();
      _peopleController.clear();
      _selectedDepartment = null;
      _selectedType = null;
      _images.clear();
      _isLiveLocationEnabled = false;
      _latitude = null;
      _longitude = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _peopleController.dispose();
    super.dispose();
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _GlassContainer(
                    margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Report Incident',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Incident Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Target Department - Dropdown (Single Selection)
                        const Text(
                          'Target Department',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDepartment,
                              hint: const Text(
                                'Select Department',
                                style: TextStyle(color: Colors.white70),
                              ),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: const Color(0xFF1A1A2E),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                              items: _departments.map((String dept) {
                                return DropdownMenuItem<String>(
                                  value: dept,
                                  child: Text(dept),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Incident Type Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedType,
                              hint: const Text(
                                'Select Incident Type',
                                style: TextStyle(color: Colors.white70),
                              ),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: const Color(0xFF1A1A2E),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedType = value;
                                });
                              },
                              items: _incidentTypes.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Description
                        TextField(
                          controller: _descriptionController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Live Location Toggle
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (_isGettingLocation)
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  else
                                    Icon(
                                      _isLiveLocationEnabled ? Icons.gps_fixed : Icons.gps_off,
                                      color: _isLiveLocationEnabled ? Colors.green : Colors.red,
                                      size: 24,
                                    ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Live Location',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (_isLiveLocationEnabled && _latitude != null)
                                        Text(
                                          'Lat: ${_latitude!.toStringAsFixed(4)}, Lng: ${_longitude!.toStringAsFixed(4)}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isLiveLocationEnabled,
                                onChanged: (value) => _toggleLiveLocation(),
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Affected People
                        TextField(
                          controller: _peopleController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Number of Affected People',
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.people, color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            hintText: 'Optional',
                            hintStyle: const TextStyle(color: Colors.white30),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 30),
                        const Divider(color: Colors.white30),
                        const SizedBox(height: 20),

                        // Images Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Upload Images',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${_images.length}/3 images selected',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: _images.length >= 3 ? null : _pickImages,
                              icon: const Icon(Icons.add_photo_alternate, color: Colors.blueAccent),
                              label: Text(
                                _images.length >= 3 ? 'Max Reached' : 'Add Photos',
                                style: TextStyle(
                                  color: _images.length >= 3 ? Colors.grey : Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Image Grid
                        if (_images.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_images[index].path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _images.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                        const SizedBox(height: 20),

                        // Submit Button
                        Center(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'SUBMIT REPORT',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const _GlassContainer({
    required this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}