import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResolvedReportsScreen extends StatefulWidget {
  final String department;
  final String departmentColor;
  final IconData departmentIcon;
  final String collectionName;

  const ResolvedReportsScreen({
    super.key,
    required this.department,
    required this.departmentColor,
    required this.departmentIcon,
    required this.collectionName,
  });

  @override
  State<ResolvedReportsScreen> createState() => _ResolvedReportsScreenState();
}

class _ResolvedReportsScreenState extends State<ResolvedReportsScreen> {
  String _searchQuery = '';

  static const Color _bg       = Color(0xFF060B18);
  static const Color _surface  = Color(0xFF0D1526);
  static const Color _card     = Color(0xFF111C35);
  static const Color _border   = Color(0xFF1E2D50);
  static const Color _textPri  = Color(0xFFE8EDF7);
  static const Color _textSec  = Color(0xFF6B7FA3);
  static const Color _resolved = Color(0xFF10B981);
  static const Color _accent   = Color(0xFF3B82F6);
  static const Color _pending  = Color(0xFFF59E0B);

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
                  color: _resolved.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _resolved.withOpacity(0.4)),
                ),
                child: const Icon(Icons.verified_rounded,
                    color: _resolved, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resolved Reports',
                        style: TextStyle(
                            color: _textPri,
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                    Text('Successfully closed incidents',
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
          .where('status', isEqualTo: 'resolved')
          .snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _resolved.withOpacity(0.18),
                _resolved.withOpacity(0.04),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _resolved.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _resolved.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: _resolved.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                        color: _resolved,
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
                    Text('Cases Successfully Closed',
                        style: TextStyle(
                            color: _textPri,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text(
                      'These incidents have been fully addressed and resolved',
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
          hintText: 'Search resolved reports...',
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
            borderSide: const BorderSide(color: _resolved, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .where('status', isEqualTo: 'resolved')
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
                  color: _resolved, strokeWidth: 2));
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

        if (docs.isEmpty) return _buildEmpty();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final report = docs[i].data() as Map<String, dynamic>;
            return _buildResolvedCard(report, docs[i].id);
          },
        );
      },
    );
  }

  Widget _buildResolvedCard(Map<String, dynamic> report, String reportId) {
    final dateTime = _formatDateTime(report['timestamp']);
    final resolvedAt = _formatDateTime(report['statusUpdatedAt']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _resolved.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: _resolved.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _resolved.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: _resolved.withOpacity(0.35)),
                  ),
                  child: const Icon(Icons.verified_rounded,
                      color: _resolved, size: 22),
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
                    color: _resolved.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _resolved.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 10, color: _resolved),
                      SizedBox(width: 4),
                      Text('RESOLVED',
                          style: TextStyle(
                              color: _resolved,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: [
                  _detailRow(Icons.description_outlined,
                      report['description'] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _detailRow(Icons.location_on_outlined,
                      report['location'] ?? 'N/A'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _timeChip(
                    Icons.calendar_today_rounded, 'Reported', dateTime, _accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _timeChip(Icons.verified_rounded, 'Resolved',
                    resolvedAt, _resolved),
              ),
            ]),
            const SizedBox(height: 12),
            // Reopen button
            GestureDetector(
              onTap: () => _reopenReport(reportId),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _pending.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: _pending.withOpacity(0.25)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restart_alt_rounded,
                        size: 15, color: _pending),
                    SizedBox(width: 6),
                    Text('Reopen Report',
                        style: TextStyle(
                            color: _pending,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: _textSec),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value,
              style: const TextStyle(color: _textSec, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _timeChip(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color.withOpacity(0.7),
                      fontSize: 9,
                      letterSpacing: 0.5)),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> _reopenReport(String reportId) async {
    await FirebaseFirestore.instance
        .collection(widget.collectionName)
        .doc(reportId)
        .update({
      'status': 'pending',
      'statusUpdatedAt': FieldValue.serverTimestamp(),
    });

    final citizenReports = await FirebaseFirestore.instance
        .collection('citizen_reports')
        .where('reportId', isEqualTo: reportId)
        .get();
    for (var doc in citizenReports.docs) {
      await doc.reference.update({
        'status': 'pending',
        'statusUpdatedAt': FieldValue.serverTimestamp(),
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Report reopened as pending'),
        backgroundColor: Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
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
              color: _resolved.withOpacity(0.1),
              shape: BoxShape.circle,
              border:
                  Border.all(color: _resolved.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.hourglass_empty_rounded,
                color: _resolved, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('No Resolved Reports Yet',
              style: TextStyle(
                  color: _textPri,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Resolved cases will appear here',
              style: TextStyle(color: _textSec, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      if (timestamp is Timestamp) {
        final d = timestamp.toDate();
        return '${d.day}/${d.month}/${d.year}';
      } else if (timestamp is String) {
        final d = DateTime.parse(timestamp);
        return '${d.day}/${d.month}/${d.year}';
      }
    } catch (_) {}
    return 'N/A';
  }
}
