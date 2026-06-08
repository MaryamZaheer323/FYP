// lib/Department Pages/department_reports_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepartmentReportsScreen extends StatefulWidget {
  final String department;
  final String departmentColor;
  final IconData departmentIcon;
  
  const DepartmentReportsScreen({
    super.key,
    required this.department,
    required this.departmentColor,
    required this.departmentIcon,
  });

  @override
  State<DepartmentReportsScreen> createState() => _DepartmentReportsScreenState();
}

class _DepartmentReportsScreenState extends State<DepartmentReportsScreen> {
  String _selectedFilter = 'pending';
  
  String get _collectionName {
    switch (widget.department) {
      case 'Police': return 'police_reports';
      case 'Traffic Police': return 'traffic_reports';
      case 'Fire Brigade': return 'fire_reports';
      case 'Rescue Service': return 'rescue_reports';
      default: return 'general_reports';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${widget.department} Reports'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0A0E21), Color(0xFF1A1A2E)],
          ),
        ),
        child: Column(
          children: [
            // Filter Chips
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterChip('Pending', 'pending'),
                  _buildFilterChip('In Progress', 'in-progress'),
                  _buildFilterChip('Resolved', 'resolved'),
                  _buildFilterChip('Rejected', 'rejected'),
                ],
              ),
            ),
            
            // Reports List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(_collectionName)
                    .where('status', isEqualTo: _selectedFilter)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white)),
                    );
                  }
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  }
                  
                  final reports = snapshot.data!.docs;
                  
                  if (reports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 80, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          Text(
                            'No $_selectedFilter reports',
                            style: TextStyle(color: Colors.grey[500], fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index].data() as Map<String, dynamic>;
                      return _buildReportCard(report, reports[index].id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String filter) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == filter,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
      },
      backgroundColor: Colors.white.withOpacity(0.1),
      selectedColor: Color(int.parse(widget.departmentColor)),
      labelStyle: TextStyle(
        color: _selectedFilter == filter ? Colors.white : Colors.white70,
      ),
      checkmarkColor: Colors.white,
    );
  }
  
  Widget _buildReportCard(Map<String, dynamic> report, String reportId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Color(int.parse(widget.departmentColor)),
          child: Icon(widget.departmentIcon, color: Colors.white),
        ),
        title: Text(
          report['type'] ?? 'Unknown Type',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By: ${report['citizenName']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              'Location: ${report['location']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(report['status']),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            report['status']?.toUpperCase() ?? 'PENDING',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.person, 'Citizen Name', report['citizenName'] ?? 'N/A'),
                _buildInfoRow(Icons.phone, 'Phone', report['citizenPhone'] ?? 'N/A'),
                _buildInfoRow(Icons.email, 'Email', report['citizenEmail'] ?? 'N/A'),
                _buildInfoRow(Icons.description, 'Description', report['description'] ?? 'N/A'),
                _buildInfoRow(Icons.people, 'Affected People', '${report['affectedPeople'] ?? 0}'),
                _buildInfoRow(Icons.location_on, 'Coordinates', report['location'] ?? 'N/A'),
                
                const Divider(color: Colors.white30, height: 20),
                
                // Status Update Dropdown
                const Text(
                  'Update Status:',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: report['status'],
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1A1A2E),
                  style: const TextStyle(color: Colors.white),
                  items: ['pending', 'in-progress', 'resolved', 'rejected'].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (newStatus) async {
                    await FirebaseFirestore.instance
                        .collection(_collectionName)
                        .doc(reportId)
                        .update({'status': newStatus});
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Status updated to ${newStatus?.toUpperCase()}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.check_circle,
                      label: 'Resolve',
                      color: Colors.green,
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection(_collectionName)
                            .doc(reportId)
                            .update({'status': 'resolved'});
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.close,
                      label: 'Reject',
                      color: Colors.red,
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection(_collectionName)
                            .doc(reportId)
                            .update({'status': 'rejected'});
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.message,
                      label: 'Message',
                      color: Colors.blue,
                      onTap: () {
                        _showMessageDialog(report['citizenName'], report['citizenEmail']);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'in-progress': return Colors.blue;
      case 'resolved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
  
  void _showMessageDialog(String citizenName, String citizenEmail) {
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message to $citizenName'),
        backgroundColor: const Color(0xFF1A1A2E),
        content: TextField(
          controller: messageController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Type your message here...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              // Here you can implement actual messaging system
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent!')),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}