import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userRole;

  const HelpSupportScreen({
    super.key,
    required this.userData,
    required this.userRole,
  });

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How to report an emergency?',
      'answer': 'Tap on the "Report Emergency" button on the home screen, fill in the details, and submit. Your report will be sent to the concerned authorities immediately.',
      'icon': Icons.report_problem,
    },
    {
      'question': 'How to track my incident report?',
      'answer': 'Go to "My Reports" section from the drawer menu. You can see the status of all your reported incidents there.',
      'icon': Icons.track_changes,
    },
    {
      'question': 'What is the average response time?',
      'answer': 'Our average response time is 2-5 minutes for critical emergencies. We strive to reach as quickly as possible.',
      'icon': Icons.timer,
    },
    {
      'question': 'How to update my profile information?',
      'answer': 'Go to Profile tab and click on the edit icon to update your personal and professional information.',
      'icon': Icons.person,
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, we use advanced encryption to protect your personal information and incident reports.',
      'icon': Icons.security,
    },
    {
      'question': 'How to change my password?',
      'answer': 'Go to Settings > Security > Change Password to update your password.',
      'icon': Icons.lock,
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showMessage('Could not launch dialer');
      }
    } catch (e) {
      _showMessage('Error making call');
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@disasterwatch.com',
      query: 'subject=Help & Support Request - ${widget.userData['name'] ?? 'User'}',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showMessage('Could not launch email app');
      }
    } catch (e) {
      _showMessage('Error sending email');
    }
  }

  Future<void> _openLocation() async {
    final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=31.5204,74.3587');
    try {
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri);
      } else {
        _showMessage('Could not open maps');
      }
    } catch (e) {
      _showMessage('Error opening location');
    }
  }

  Future<void> _submitFeedback() async {
    if (_messageController.text.isEmpty) {
      _showMessage('Please enter your message');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
    _showMessage('Thank you for your feedback!');
    _messageController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Card with login name
            _buildUserInfoCard(themeColor),

            // FAQ Section
            _buildSectionTitle('Frequently Asked Questions', Icons.help, themeColor),
            _buildFAQCard(themeColor),

            // Contact Support Section
            _buildSectionTitle('Contact Support', Icons.contact_support, themeColor),
            _buildContactSupportCard(themeColor),

            // Send Feedback Section
            _buildSectionTitle('Send Feedback', Icons.feedback, themeColor),
            _buildFeedbackCard(themeColor),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(Color themeColor) {
    String userName = widget.userData['name'] ?? 'User';

    return _GlassContainer(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: themeColor.withOpacity(0.2),
            child: Icon(
              Icons.support_agent,
              color: themeColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userRole,
                  style: TextStyle(
                    fontSize: 14,
                    color: themeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Verified',
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: themeColor, size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(Color themeColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            colorScheme: ColorScheme.dark().copyWith(
              surface: Colors.transparent,
              onSurface: Colors.white,
            ),
            cardColor: Colors.transparent,
          ),
          child: ExpansionPanelList.radio(
            elevation: 0,
            dividerColor: Colors.transparent,
            expandedHeaderPadding: EdgeInsets.zero,
            children: _faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;
              return ExpansionPanelRadio(
                value: index,
                headerBuilder: (context, isExpanded) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(faq['icon'] as IconData, color: themeColor, size: 20),
                      ),
                      title: Text(
                        faq['question'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                body: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      faq['answer'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupportCard(Color themeColor) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildContactItem(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@disasterwatch.com',
            color: Colors.blue,
            onTap: _sendEmail,
          ),
          _buildDivider(),
          _buildContactItem(
            icon: Icons.phone,
            title: 'Helpline',
            subtitle: '0326 0475461 - Call for immediate support',
            color: Colors.green,
            onTap: () => _makePhoneCall('03260475461'),
          ),
          _buildDivider(),
          _buildContactItem(
            icon: Icons.location_on,
            title: 'Head Office',
            subtitle: '23-D, Main Boulevard, Gulberg III, Lahore, Pakistan',
            color: Colors.orange,
            onTap: _openLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white70,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }

  Widget _buildFeedbackCard(Color themeColor) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your message here...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                'Submit Feedback',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white24,
      height: 1,
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