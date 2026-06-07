import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String userRole;

  const PrivacyPolicyScreen({
    super.key,
    required this.userData,
    required this.userRole,
  });

  Color _getThemeColor() {
    switch (userRole) {
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
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
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
            _buildHeader(themeColor),
            _buildSection(
              title: 'Information We Collect',
              icon: Icons.info,
              color: themeColor,
              items: [
                'Personal information (name, email, phone number, CNIC)',
                'Location data for incident reporting',
                'Device information and app usage data',
                'Incident reports and uploaded media',
                'Professional credentials (for authorized personnel)',
              ],
            ),
            _buildSection(
              title: 'How We Use Your Information',
              icon: Icons.analytics,
              color: themeColor,
              items: [
                'To process and respond to emergency reports',
                'To verify user identity and credentials',
                'To improve our emergency response services',
                'To communicate important updates',
                'To maintain service records and analytics',
              ],
            ),
            _buildSection(
              title: 'Data Security',
              icon: Icons.security,
              color: themeColor,
              items: [
                'End-to-end encryption for all communications',
                'Secure servers with regular security audits',
                'Access controls and authentication protocols',
                'Regular data backups and disaster recovery',
                'Compliance with data protection regulations',
              ],
            ),
            _buildSection(
              title: 'Data Sharing',
              icon: Icons.share,
              color: themeColor,
              items: [
                'Information shared with relevant emergency services',
                'Anonymous data for research and improvement',
                'Legal compliance when required by law',
                'Never sell your personal information to third parties',
              ],
            ),
            _buildSection(
              title: 'Your Rights',
              icon: Icons.gavel,
              color: themeColor,
              items: [
                'Access your personal data anytime',
                'Request corrections to your information',
                'Delete your account and associated data',
                'Opt-out of non-essential communications',
                'Withdraw consent for data processing',
              ],
            ),
            _buildSection(
              title: 'Data Retention',
              icon: Icons.history,
              color: themeColor,
              items: [
                'Active accounts: Data retained while account is active',
                'Incident reports: Retained for 7 years for legal compliance',
                'Deleted accounts: Data removed within 30 days',
                'Anonymous analytics: Retained indefinitely',
              ],
            ),
            _buildSection(
              title: 'Children\'s Privacy',
              icon: Icons.child_care,
              color: themeColor,
              items: [
                'Service is not intended for users under 13',
                'We do not knowingly collect data from children',
                'Parental consent required for users 13-18',
                'Immediate deletion if underage user detected',
              ],
            ),
            _buildSection(
              title: 'Updates to Privacy Policy',
              icon: Icons.update,
              color: themeColor,
              items: [
                'Policy reviewed and updated regularly',
                'Users notified of significant changes',
                'Continued use implies acceptance of updates',
                'Previous versions available upon request',
              ],
            ),
            _buildContactSection(themeColor),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color themeColor) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [themeColor, themeColor.withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.privacy_tip,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          Text(
            'Your Privacy Matters',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last Updated: ${_getCurrentDate()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'At Disaster Watch, we are committed to protecting your personal information and ensuring your data remains secure.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContactSection(Color themeColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.contact_support,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you have any questions about this Privacy Policy, please contact us:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: themeColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'privacy@disasterwatch.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: themeColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '+92 321 1234567',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: themeColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '23-D, Main Boulevard, Gulberg III, Lahore',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeColor,
                      ),
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

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }
}