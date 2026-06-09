 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepartmentReportsScreen extends StatefulWidget {
  final String department;
  final String departmentColor;
  final IconData departmentIcon;
  final String collectionName;
  
  const DepartmentReportsScreen({
    super.key,
    required this.department,
    required this.departmentColor,
    required this.departmentIcon,
    required this.collectionName,
  });

  @override
  State<DepartmentReportsScreen> createState() => _DepartmentReportsScreenState();
}

class _DepartmentReportsScreenState extends State<DepartmentReportsScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
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
            // Stats Cards
            _buildStatsRow(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Filter Chips
            _buildFilterChips(),
            
            // Reports List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(widget.collectionName)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  }
                  
                  var reports = snapshot.data!.docs;
                  
                  // Apply filter
                  if (_selectedFilter != 'all') {
                    reports = reports.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['status'] == _selectedFilter;
                    }).toList();
                  }
                  
                  // Apply search
                  if (_searchQuery.isNotEmpty) {
                    reports = reports.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['citizenName']
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                          data['type']
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                    }).toList();
                  }
                  
                  if (reports.isEmpty) {
                    return _buildEmptyState();
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
  
  Widget _buildStatsRow() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildStatCard('Total', '0', Icons.report, Colors.purple);
        }
        
        final reports = snapshot.data!.docs;
        int total = reports.length;
        int pending = reports.where((doc) => 
          (doc.data() as Map<String, dynamic>)['status'] == 'pending').length;
        int resolved = reports.where((doc) => 
          (doc.data() as Map<String, dynamic>)['status'] == 'resolved').length;
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: _buildStatCard('Total', total.toString(), Icons.report, Colors.purple)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Pending', pending.toString(), Icons.pending, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Resolved', resolved.toString(), Icons.check_circle, Colors.green)),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by citizen name or incident type...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
  
  Widget _buildFilterChips() {
    final filters = ['all', 'pending', 'in-progress', 'resolved', 'rejected'];
    final labels = ['All', 'Pending', 'In Progress', 'Resolved', 'Rejected'];
    final colors = [Colors.purple, Colors.orange, Colors.blue, Colors.green, Colors.red];
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(labels[index]),
              selected: _selectedFilter == filters[index],
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filters[index];
                });
              },
              backgroundColor: Colors.white.withOpacity(0.1),
              selectedColor: colors[index],
              labelStyle: TextStyle(
                color: _selectedFilter == filters[index] ? Colors.white : Colors.white70,
              ),
              checkmarkColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState() {
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
          const SizedBox(height: 8),
          Text(
            'Reports will appear here when citizens submit them',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportCard(Map<String, dynamic> report, String reportId) {
    String dateTime = _formatDateTime(report['timestamp']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Color(int.parse(widget.departmentColor)),
          child: Icon(widget.departmentIcon, color: Colors.white, size: 20),
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
              'By: ${report['citizenName']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              'Location: ${report['location']}',
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
                // Citizen Info Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.person, 'Citizen Name', report['citizenName'] ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.phone, 'Phone', report['citizenPhone'] ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.email, 'Email', report['citizenEmail'] ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.badge, 'CNIC', report['citizenCNIC'] ?? 'N/A'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Incident Details
                const Text(
                  'Incident Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.description, 'Description', report['description'] ?? 'N/A'),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.location_on, 'Location', report['location'] ?? 'N/A'),
                const SizedBox(height: 10),
                if (report['affectedPeople'] != null && report['affectedPeople'] > 0)
                  _buildInfoRow(Icons.people, 'Affected People', '${report['affectedPeople']}'),
                const SizedBox(height: 10),
                if (report['imageCount'] != null && report['imageCount'] > 0)
                  _buildInfoRow(Icons.image, 'Images', '${report['imageCount']} photos attached'),
                
                const SizedBox(height: 15),
                const Divider(color: Colors.white30),
                const SizedBox(height: 15),
                
                // Status Update Section
                const Text(
                  'Update Report Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: report['status'] ?? 'pending',
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A2E),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'pending', child: Text('📋 Pending')),
                      DropdownMenuItem(value: 'in-progress', child: Text('🔄 In Progress')),
                      DropdownMenuItem(value: 'resolved', child: Text('✅ Resolved')),
                      DropdownMenuItem(value: 'rejected', child: Text('❌ Rejected')),
                    ],
                    onChanged: (newStatus) async {
                      await FirebaseFirestore.instance
                          .collection(widget.collectionName)
                          .doc(reportId)
                          .update({
                            'status': newStatus,
                            'statusUpdatedAt': FieldValue.serverTimestamp(),
                          });
                      
                      // Also update in citizen_reports collection
                      final citizenReports = await FirebaseFirestore.instance
                          .collection('citizen_reports')
                          .where('reportId', isEqualTo: reportId)
                          .get();
                      
                      for (var doc in citizenReports.docs) {
                        await doc.reference.update({
                          'status': newStatus,
                          'statusUpdatedAt': FieldValue.serverTimestamp(),
                        });
                      }
                      
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
                ),
                
                const SizedBox(height: 15),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.message,
                      label: 'Message',
                      color: Colors.purple,
                      onTap: () {
                        _showMessageDialog(report);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.location_on,
                      label: 'View Location',
                      color: Colors.blue,
                      onTap: () {
                        _showLocationDialog(report);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.assignment_turned_in,
                      label: 'Resolve',
                      color: Colors.green,
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection(widget.collectionName)
                            .doc(reportId)
                            .update({'status': 'resolved'});
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report marked as resolved'),
                            backgroundColor: Colors.green,
                          ),
                        );
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
  
  void _showMessageDialog(Map<String, dynamic> report) {
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message to ${report['citizenName']}'),
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
                hintText: 'Type your response here...',
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
              FirebaseFirestore.instance.collection('department_messages').add({
                'reportId': report['reportId'],
                'citizenEmail': report['citizenEmail'],
                'department': widget.department,
                'message': messageController.text,
                'sender': 'department',
                'timestamp': FieldValue.serverTimestamp(),
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent to citizen!')),
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
  
  void _showLocationDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Location'),
        backgroundColor: const Color(0xFF1A1A2E),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              'Coordinates: ${report['location']}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'You can use these coordinates to navigate to the incident location.',
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
          ElevatedButton.icon(
            onPressed: () {
              // Open Google Maps with coordinates
              String location = report['location'] ?? '';
              Navigator.pop(context);
            },
            icon: const Icon(Icons.map),
            label: const Text('Open Maps'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          ),
        ],
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
}