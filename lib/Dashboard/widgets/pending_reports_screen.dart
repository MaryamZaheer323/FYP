import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingReportsScreen extends StatefulWidget {
  final String department;
  final String departmentColor;
  final IconData departmentIcon;
  final String collectionName;

  const PendingReportsScreen({
    super.key,
    required this.department,
    required this.departmentColor,
    required this.departmentIcon,
    required this.collectionName,
  });

  @override
  State<PendingReportsScreen> createState() => _PendingReportsScreenState();
}

class _PendingReportsScreenState extends State<PendingReportsScreen> {
  String _searchQuery = '';

  static const Color _bg      = Color(0xFF060B18);
  static const Color _surface = Color(0xFF0D1526);
  static const Color _card    = Color(0xFF111C35);
  static const Color _border  = Color(0xFF1E2D50);
  static const Color _textPri = Color(0xFFE8EDF7);
  static const Color _textSec = Color(0xFF6B7FA3);
  static const Color _pending = Color(0xFFF59E0B);
  static const Color _resolved= Color(0xFF10B981);
  static const Color _accent  = Color(0xFF3B82F6);
  static const Color _inProg  = Color(0xFF6366F1);
  static const Color _rejected= Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          _buildBanner(),
          _buildSearch(),
          Expanded(child: _buildStream()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: _textSec, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _pending.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _pending.withOpacity(0.4)),
                ),
                child: const Icon(Icons.hourglass_top_rounded,
                    color: _pending, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pending Reports',
                        style: TextStyle(
                            color: _textPri,
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                    Text('Awaiting department action',
                        style: TextStyle(color: _textSec, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: _textSec),
                onPressed: () => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _pending.withOpacity(0.2),
                _pending.withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _pending.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _pending.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: _pending.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                        color: _pending,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reports Awaiting Action',
                        style: TextStyle(
                            color: _textPri,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text(
                      'These incidents require immediate attention and status update',
                      style: TextStyle(color: _textSec, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        style: const TextStyle(color: _textPri, fontSize: 14),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search pending reports...',
          hintStyle: const TextStyle(color: _textSec, fontSize: 13),
          prefixIcon:
              const Icon(Icons.search_rounded, color: _textSec, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: _textSec, size: 18),
                  onPressed: () => setState(() => _searchQuery = ''))
              : null,
          filled: true,
          fillColor: _card,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _pending, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .where('status', isEqualTo: 'pending')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: _textSec)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: _pending, strokeWidth: 2));
        }

        var docs = snapshot.data!.docs;

        if (_searchQuery.isNotEmpty) {
          docs = docs.where((d) {
            final data = d.data() as Map<String, dynamic>;
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

        if (docs.isEmpty) {
          return _buildEmpty();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final report = docs[i].data() as Map<String, dynamic>;
            return _buildPendingCard(report, docs[i].id);
          },
        );
      },
    );
  }

  Widget _buildPendingCard(Map<String, dynamic> report, String reportId) {
    final dateTime = _formatDateTime(report['timestamp']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _pending.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
              color: _pending.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _pending.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _pending.withOpacity(0.4)),
                  ),
                  child: Icon(widget.departmentIcon,
                      color: _pending, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['type'] ?? 'Unknown Incident',
                        style: const TextStyle(
                            color: _textPri,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 12, color: _textSec),
                        const SizedBox(width: 4),
                        Text(report['citizenName'] ?? 'N/A',
                            style: const TextStyle(
                                color: _textSec, fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _pending.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _pending.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_top_rounded,
                          size: 10, color: _pending),
                      SizedBox(width: 4),
                      Text('PENDING',
                          style: TextStyle(
                              color: _pending,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info strip
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(top: BorderSide(color: _pending.withOpacity(0.15))),
            ),
            child: Column(
              children: [
                Row(children: [
                  _infoChip(Icons.location_on_rounded,
                      report['location'] ?? 'N/A', _accent),
                  const SizedBox(width: 10),
                  _infoChip(Icons.schedule_rounded, dateTime, _textSec),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: _quickActionBtn(
                      icon: Icons.bolt_rounded,
                      label: 'Mark In Progress',
                      color: _inProg,
                      onTap: () => _updateStatus(reportId, 'in-progress'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _quickActionBtn(
                      icon: Icons.verified_rounded,
                      label: 'Mark Resolved',
                      color: _resolved,
                      onTap: () => _updateStatus(reportId, 'resolved'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _quickIconBtn(
                    icon: Icons.cancel_rounded,
                    color: _rejected,
                    onTap: () => _updateStatus(reportId, 'rejected'),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(label,
                style: TextStyle(color: color, fontSize: 11),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _quickActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _quickIconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Future<void> _updateStatus(String reportId, String status) async {
    await FirebaseFirestore.instance
        .collection(widget.collectionName)
        .doc(reportId)
        .update({
      'status': status,
      'statusUpdatedAt': FieldValue.serverTimestamp(),
    });

    final citizenReports = await FirebaseFirestore.instance
        .collection('citizen_reports')
        .where('reportId', isEqualTo: reportId)
        .get();
    for (var doc in citizenReports.docs) {
      await doc.reference.update({
        'status': status,
        'statusUpdatedAt': FieldValue.serverTimestamp(),
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status updated to ${status.toUpperCase()}'),
        backgroundColor: _resolved,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _pending.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _pending.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: _pending, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('No Pending Reports',
              style: TextStyle(
                  color: _textPri,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('All reports have been actioned',
              style: TextStyle(color: _textSec, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      if (timestamp is Timestamp) {
        final d = timestamp.toDate();
        return '${d.day}/${d.month}/${d.year}';
      } else if (timestamp is String) {
        final d = DateTime.parse(timestamp);
        return '${d.day}/${d.month}/${d.year}';
      }
    } catch (_) {}
    return 'Unknown';
  }
}
