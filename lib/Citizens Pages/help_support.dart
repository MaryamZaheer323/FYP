import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HelpSupportScreen({
    super.key,
    required this.userData,
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
      'answer': 'Tap on the "Report Emergency" button on the home screen or Report tab, fill in the incident details (type, description, location), add photos if possible, and submit. Your report will be sent to the concerned authorities immediately.',
      'icon': Icons.report_problem,
    },
    {
      'question': 'How to track my incident report?',
      'answer': 'Go to "My Reports" section from the drawer menu. You can see the status of all your reported incidents there (Pending, Active, Resolved).',
      'icon': Icons.track_changes,
    },
    {
      'question': 'What is the average response time?',
      'answer': 'Our average response time is 2-5 minutes for critical emergencies. We strive to reach as quickly as possible.',
      'icon': Icons.timer,
    },
    {
      'question': 'How to update my profile information?',
      'answer': 'Go to Profile tab and click on the edit icon (pencil icon) or tap on "Edit Profile" in Quick Actions to update your personal information.',
      'icon': Icons.person,
    },
    {
      'question': 'How to change my password?',
      'answer': 'Go to Settings > Privacy & Security > Change Password. Enter your current password and new password to update.',
      'icon': Icons.lock,
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, we use advanced encryption to protect your personal information and incident reports. Your data is never shared with third parties without your consent.',
      'icon': Icons.security,
    },
    {
      'question': 'Can I upload photos with my report?',
      'answer': 'Yes, you can upload multiple photos while reporting an incident. This helps authorities understand the situation better.',
      'icon': Icons.camera_alt,
    },
    {
      'question': 'What happens after I submit a report?',
      'answer': 'After submission, your report is sent to the concerned department. You will receive updates on the status of your report.',
      'icon': Icons.check_circle,
    },
  ];

  final List<Map<String, String>> _emergencyContacts = [
    {'name': 'Police', 'number': '15', 'icon': '👮'},
    {'name': 'Fire Brigade', 'number': '16', 'icon': '🚒'},
    {'name': 'Rescue 1122', 'number': '1122', 'icon': '🚑'},
    {'name': 'Ambulance', 'number': '115', 'icon': '🏥'},
    {'name': 'Traffic Police', 'number': '1915', 'icon': '🚦'},
    {'name': 'Anti-Terrorism', 'number': '1717', 'icon': '🛡️'},
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

  void _showLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Head Office Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 10),
                Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 5),
            Text('123 Emergency Response Complex'),
            Text('Main Boulevard, Gulberg III'),
            Text('Lahore, Punjab 54000'),
            Text('Pakistan'),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 10),
                Text('Office Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 5),
            Text('Monday - Friday: 9:00 AM - 6:00 PM'),
            Text('Saturday: 10:00 AM - 2:00 PM'),
            Text('Sunday: Closed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.userData['name'] ?? 'Citizen';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Card
            _buildUserInfoCard(userName),
            // Emergency Contacts Section
            _buildSectionTitle('Emergency Contacts', Icons.emergency),
            _buildEmergencyContactsCard(),
            // FAQ Section
            _buildSectionTitle('Frequently Asked Questions', Icons.help),
            _buildFAQCard(),
            // Contact Support Section
            _buildSectionTitle('Contact Support', Icons.contact_support),
            _buildContactSupportCard(),
            // Send Feedback Section
            _buildSectionTitle('Send Feedback', Icons.feedback),
            _buildFeedbackCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(String userName) {
    return _GlassContainer(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple,
            child: Icon(Icons.support_agent, size: 30, color: Colors.white),
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
                const Text(
                  'Citizen',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Verified',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 24),
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

  Widget _buildEmergencyContactsCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3,
        children: _emergencyContacts.map((contact) {
          return _buildEmergencyContactItem(
            contact['name']!,
            contact['number']!,
            contact['icon']!,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmergencyContactItem(String name, String number, String icon) {
    return GestureDetector(
      onTap: () => _makePhoneCall(number),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    number,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.call, color: Colors.purple, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard() {
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
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(faq['icon'] as IconData, color: Colors.purple, size: 20),
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

  Widget _buildContactSupportCard() {
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
            onTap: _showLocation,
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

  Widget _buildFeedbackCard() {
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
                backgroundColor: Colors.purple,
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