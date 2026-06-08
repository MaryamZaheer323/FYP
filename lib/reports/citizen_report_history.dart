// lib/Citizens Pages/report_history.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  
  const ReportHistoryScreen({super.key, required this.userData});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  String _selectedFilter = 'all';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Report History'),
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
                  _buildFilterChip('All', 'all'),
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
                    .collection('citizen_reports')
                    .where('citizenEmail', isEqualTo: widget.userData['email'])
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
                  
                  var reports = snapshot.data!.docs;
                  
                  if (_selectedFilter != 'all') {
                    reports = reports.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['status'] == _selectedFilter;
                    }).toList();
                  }
                  
                  if (reports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 80, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          Text(
                            'No reports found',
                            style: TextStyle(color: Colors.grey[500], fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You haven\'t submitted any reports yet',
                            style: TextStyle(color: Colors.grey[600]),
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
      selectedColor: Colors.purple,
      labelStyle: TextStyle(
        color: _selectedFilter == filter ? Colors.white : Colors.white70,
      ),
      checkmarkColor: Colors.white,
    );
  }
  
  Widget _buildReportCard(Map<String, dynamic> report, String reportId) {
    // Parse timestamp
    String dateTime = _formatDateTime(report['timestamp']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getDepartmentColor(report['department']),
          child: Icon(_getDepartmentIcon(report['department']), color: Colors.white, size: 20),
        ),
        title: Text(
          report['type'] ?? 'Unknown Incident',
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department: ${report['department']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              'Date: $dateTime',
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
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 11, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report ID
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt, color: Colors.purple, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Report ID',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            Text(
                              reportId,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Description
                _buildInfoRow(Icons.description, 'Description', report['description'] ?? 'N/A'),
                const SizedBox(height: 10),
                
                // Location
                _buildInfoRow(Icons.location_on, 'Location', report['location'] ?? 'N/A'),
                const SizedBox(height: 10),
                
                // Affected People
                if (report['affectedPeople'] != null && report['affectedPeople'] > 0)
                  _buildInfoRow(Icons.people, 'Affected People', '${report['affectedPeople']}'),
                
                const SizedBox(height: 10),
                
                // Images
                if (report['imageCount'] != null && report['imageCount'] > 0)
                  _buildInfoRow(Icons.image, 'Images', '${report['imageCount']} photos attached'),
                
                const SizedBox(height: 15),
                const Divider(color: Colors.white30),
                const SizedBox(height: 10),
                
                // Status Timeline
                const Text(
                  'Status Timeline',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                _buildStatusTimeline(report['status']),
                
                const SizedBox(height: 15),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Track',
                      color: Colors.blue,
                      onTap: () {
                        _showTrackingDialog(report);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.message,
                      label: 'Message',
                      color: Colors.purple,
                      onTap: () {
                        _showMessageDialog(report);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      color: Colors.green,
                      onTap: () {
                        _shareReport(report, reportId);
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.purple),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusTimeline(String? currentStatus) {
    List<Map<String, dynamic>> statuses = [
      {'status': 'pending', 'label': 'Submitted', 'icon': Icons.send, 'completed': true},
      {'status': 'in-progress', 'label': 'In Progress', 'icon': Icons.hourglass_empty, 'completed': false},
      {'status': 'resolved', 'label': 'Resolved', 'icon': Icons.check_circle, 'completed': false},
    ];
    
    // Mark completed statuses
    for (var status in statuses) {
      if (status['status'] == currentStatus) {
        status['completed'] = true;
        break;
      }
      status['completed'] = true;
    }
    
    return Row(
      children: statuses.map((status) {
        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: status['completed'] ? Colors.green : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  status['icon'],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                status['label'],
                style: TextStyle(
                  color: status['completed'] ? Colors.white : Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Color _getDepartmentColor(String? department) {
    switch (department) {
      case 'Police': return Colors.blue;
      case 'Traffic Police': return Colors.orange;
      case 'Fire Brigade': return Colors.red;
      case 'Rescue Service': return Colors.green;
      default: return Colors.purple;
    }
  }
  
  IconData _getDepartmentIcon(String? department) {
    switch (department) {
      case 'Police': return Icons.local_police;
      case 'Traffic Police': return Icons.traffic;
      case 'Fire Brigade': return Icons.fire_truck;
      case 'Rescue Service': return Icons.medical_services;
      default: return Icons.report;
    }
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
  
  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    
    try {
      if (timestamp is Timestamp) {
        DateTime date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (timestamp is String) {
        DateTime date = DateTime.parse(timestamp);
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return 'Unknown date';
    }
    return 'Unknown date';
  }
  
  void _showTrackingDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Report'),
        backgroundColor: const Color(0xFF1A1A2E),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_searching, size: 50, color: Colors.purple),
            const SizedBox(height: 10),
            Text(
              'Report ID: ${report['reportId'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              'Status: ${report['status']?.toUpperCase() ?? 'PENDING'}',
              style: TextStyle(
                color: _getStatusColor(report['status']),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your report has been submitted to the concerned department. You will receive updates as they process your request.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  void _showMessageDialog(Map<String, dynamic> report) {
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message to ${report['department']}'),
        backgroundColor: const Color(0xFF1A1A2E),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Report ID: ${report['reportId']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              // Save message to Firestore
              FirebaseFirestore.instance.collection('messages').add({
                'reportId': report['reportId'],
                'citizenEmail': widget.userData['email'],
                'department': report['department'],
                'message': messageController.text,
                'timestamp': FieldValue.serverTimestamp(),
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent successfully!')),
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
  
  void _shareReport(Map<String, dynamic> report, String reportId) {
    String shareText = '''
🚨 DISASTER REPORT 🚨

Report ID: $reportId
Type: ${report['type']}
Department: ${report['department']}
Status: ${report['status']?.toUpperCase()}
Location: ${report['location']}
Date: ${_formatDateTime(report['timestamp'])}

Description: ${report['description']}

Reported via Smart Disaster Response System
    ''';
    
    // You can use share_plus package here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share feature coming soon!'),
        backgroundColor: Colors.purple,
      ),
    );
    
    // For actual sharing, add share_plus package:
    // Share.share(shareText);
  }
}