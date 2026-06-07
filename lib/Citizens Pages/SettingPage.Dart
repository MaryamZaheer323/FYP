import 'package:flutter/material.dart';
import '../Login/login.dart'; // Add this import

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onUpdateUserData;

  const SettingsScreen({
    super.key,
    required this.userData,
    required this.onUpdateUserData,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _locationTrackingEnabled = true;

  // Change Password Controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Two-Factor Authentication
  bool _is2FAEnabled = false;
  String _twoFAMethod = 'SMS';
  final List<String> _twoFAMethods = ['SMS', 'Email', 'Authenticator App'];

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: const Color(0xFF0A0E21),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _performClearCache() {
    _showConfirmDialog(
      'Clear Cache',
      'Are you sure you want to clear cache?',
          () {
        _showMessage('Cache cleared successfully!');
      },
    );
  }

  void _performLogout() {
    _showConfirmDialog(
      'Logout',
      'Are you sure you want to logout?',
          () {
        _showMessage('Logged out successfully!');
        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigate to LoginScreen and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        });
      },
    );
  }

  void _performDeleteAccount() {
    _showConfirmDialog(
      'Delete Account',
      'This action cannot be undone. Are you sure you want to permanently delete your account?',
          () {
        _showMessage('Account deleted successfully!');
        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigate to LoginScreen and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        });
      },
    );
  }

  void _showChangePasswordDialog() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        backgroundColor: const Color(0xFF0A0E21),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              _changePassword();
            },
            child: const Text('Update', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      _showMessage('Please enter current password', isError: true);
      return;
    }

    if (newPassword.isEmpty) {
      _showMessage('Please enter new password', isError: true);
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('New password must be at least 6 characters', isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('New passwords do not match', isError: true);
      return;
    }

    _showMessage('Password changed successfully!');
    Navigator.pop(context);
  }

  void _showTwoFADialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Two-Factor Authentication'),
            backgroundColor: const Color(0xFF0A0E21),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Enable 2FA', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Add extra security to your account', style: TextStyle(color: Colors.white70)),
                    value: _is2FAEnabled,
                    activeColor: Colors.purple,
                    onChanged: (value) {
                      setStateDialog(() {
                        _is2FAEnabled = value;
                      });
                    },
                  ),
                  if (_is2FAEnabled) ...[
                    const SizedBox(height: 15),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),
                    const Text(
                      'Select verification method',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    ..._twoFAMethods.map((method) {
                      return RadioListTile<String>(
                        title: Text(method, style: const TextStyle(color: Colors.white)),
                        value: method,
                        groupValue: _twoFAMethod,
                        activeColor: Colors.purple,
                        onChanged: (value) {
                          setStateDialog(() {
                            _twoFAMethod = value!;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.purple, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You will receive verification codes via your selected method',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () {
                  if (_is2FAEnabled) {
                    _showMessage('2FA enabled with $_twoFAMethod method');
                  } else {
                    _showMessage('2FA disabled');
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save', style: TextStyle(color: Colors.purple)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Settings',
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
            _buildUserInfoCard(),
            _buildSectionTitle('Notifications'),
            _buildNotificationsCard(),
            _buildSectionTitle('Privacy & Security'),
            _buildPrivacySecurityCard(),
            _buildSectionTitle('Data & Storage'),
            _buildDataStorageCard(),
            _buildSectionTitle('About'),
            _buildAboutCard(),
            _buildSectionTitle('Danger Zone'),
            _buildDangerZoneCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return _GlassContainer(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userData['name'] ?? 'Citizen User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userData['email'] ?? 'citizen@example.com',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
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
            child: Text(
              widget.userData['role'] ?? 'CITIZEN',
              style: const TextStyle(
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive incident alerts and updates',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _showMessage('Push Notifications ${value ? 'Enabled' : 'Disabled'}');
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'Sound Alerts',
            subtitle: 'Play sound for notifications',
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
              _showMessage('Sound Alerts ${value ? 'Enabled' : 'Disabled'}');
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: 'Vibration',
            subtitle: 'Vibrate on notifications',
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
              _showMessage('Vibration ${value ? 'Enabled' : 'Disabled'}');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySecurityCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.location_on,
            title: 'Location Tracking',
            subtitle: 'Allow app to access your location',
            value: _locationTrackingEnabled,
            onChanged: (value) {
              setState(() {
                _locationTrackingEnabled = value;
              });
              _showMessage('Location Tracking ${value ? 'Enabled' : 'Disabled'}');
            },
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your account password',
            color: Colors.blue,
            onTap: _showChangePasswordDialog,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.security,
            title: 'Two-Factor Authentication',
            subtitle: 'Add extra security to your account',
            color: Colors.green,
            onTap: _showTwoFADialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDataStorageCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.download,
            title: 'Download My Data',
            subtitle: 'Export your account data',
            color: Colors.purple,
            onTap: () {
              _showMessage('Downloading your data...');
            },
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.delete_sweep,
            title: 'Clear Cache',
            subtitle: 'Clear temporary files and data',
            color: Colors.orange,
            onTap: _performClearCache,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.info,
            title: 'App Version',
            value: '2.0.0',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.build,
            title: 'Build Number',
            value: '2024.01',
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.star,
            title: 'Rate Us',
            subtitle: 'Rate this app on Play Store',
            color: Colors.yellow,
            onTap: () {
              _showMessage('Thank you for rating!');
            },
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share with friends and family',
            color: Colors.teal,
            onTap: () {
              _showMessage('Share option opened');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            color: Colors.red,
            onTap: _performLogout,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            color: Colors.red,
            onTap: _performDeleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.purple, size: 24),
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purple,
      ),
    );
  }

  Widget _buildActionTile({
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.purple, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.purple,
          fontWeight: FontWeight.w500,
        ),
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