import 'dart:async';
import 'package:flutter/material.dart';
import '../Login/login.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(String)? onLanguageChanged;
  final Function(double)? onFontSizeChanged;
  final Function(bool)? onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.userData,
    this.onLanguageChanged,
    this.onFontSizeChanged,
    this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _locationTrackingEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedRefreshInterval = '30 seconds';
  Timer? _autoRefreshTimer;

  final List<String> _languages = ['English', 'Urdu', 'Roman Urdu'];
  final List<String> _refreshIntervals = ['15 seconds', '30 seconds', '1 minute', '5 minutes', 'Never'];

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();

    if (_selectedRefreshInterval == 'Never') return;

    int seconds = 30;
    if (_selectedRefreshInterval == '15 seconds') seconds = 15;
    else if (_selectedRefreshInterval == '30 seconds') seconds = 30;
    else if (_selectedRefreshInterval == '1 minute') seconds = 60;
    else if (_selectedRefreshInterval == '5 minutes') seconds = 300;

    _autoRefreshTimer = Timer.periodic(Duration(seconds: seconds), (timer) {
      _performAutoRefresh();
    });
  }

  void _performAutoRefresh() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto refreshed at ${DateTime.now().hour}:${DateTime.now().minute}'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmDialog(String title, String message, VoidCallback onConfirm, {bool isDanger = false}) {
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
            child: Text(
              title == 'Logout' ? 'Logout' : (title == 'Delete Account' ? 'Delete' : 'Confirm'),
              style: TextStyle(color: isDanger ? Colors.red : Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  // YAHAN LOGOUT FUNCTION CHANGE KIYA HAI
  void _performLogout() {
    _showConfirmDialog(
      'Logout',
      'Are you sure you want to logout?',
          () {
        // Directly navigate to LoginScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false, // This removes all previous routes
        );
      },
      isDanger: true,
    );
  }

  void _performDeleteAccount() {
    _showConfirmDialog(
      'Delete Account',
      'This action cannot be undone. Are you sure you want to permanently delete your account?',
          () {
        _showMessage('Account deleted successfully!');
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        });
      },
      isDanger: true,
    );
  }

  void _performSyncData() {
    _showMessage('Syncing data...');
    Future.delayed(const Duration(seconds: 2), () {
      _showMessage('Data synced successfully!');
    });
  }

  void _performDownloadOfflineData() {
    _showMessage('Downloading offline data...');
    Future.delayed(const Duration(seconds: 3), () {
      _showMessage('Offline data downloaded successfully!');
    });
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

  void _performRateUs() {
    _showMessage('Thank you for rating!');
  }

  void _performShareApp() {
    _showMessage('Share option opened');
  }

  void _performEditProfile() {
    _showMessage('Edit Profile clicked');
  }

  void _applyLanguageChange(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!(language);
    }
    _showMessage('Language changed to $language (Demo only)');
  }

  void _applyRefreshInterval(String interval) {
    setState(() {
      _selectedRefreshInterval = interval;
    });
    _startAutoRefresh();
    _showMessage('Auto Refresh set to $interval');
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _performEditProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoCard(),
            _buildSectionTitle('Preferences'),
            _buildPreferenceCard(),
            _buildSectionTitle('Notifications'),
            _buildNotificationsCard(),
            _buildSectionTitle('Data & Sync'),
            _buildDataSyncCard(),
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
          GestureDetector(
            onTap: _performEditProfile,
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userData['name'] ?? 'Police Officer',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userData['email'] ?? 'police@example.com',
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
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.userData['rank'] ?? 'Officer',
              style: const TextStyle(
                color: Colors.blueAccent,
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

  Widget _buildPreferenceCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildDropdownTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Select your preferred language',
            value: _selectedLanguage,
            items: _languages,
            onChanged: _applyLanguageChange,
          ),
          _buildDivider(),
          _buildDropdownTile(
            icon: Icons.refresh,
            title: 'Auto Refresh',
            subtitle: 'Refresh data automatically',
            value: _selectedRefreshInterval,
            items: _refreshIntervals,
            onChanged: _applyRefreshInterval,
          ),
        ],
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
            subtitle: 'Receive incident alerts',
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
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.location_on,
            title: 'Location Tracking',
            subtitle: 'Enable location for incidents',
            value: _locationTrackingEnabled,
            onChanged: (value) {
              setState(() {
                _locationTrackingEnabled = value;
              });
              _showMessage('Location Tracking ${value ? 'Enabled' : 'Disabled'}');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSyncCard() {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.sync,
            title: 'Sync Now',
            subtitle: 'Manually sync data with server',
            color: Colors.blue,
            onTap: _performSyncData,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.cloud_download,
            title: 'Download Offline Data',
            subtitle: 'Save data for offline use',
            color: Colors.green,
            onTap: _performDownloadOfflineData,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.delete_sweep,
            title: 'Clear Cache',
            subtitle: 'Clear temporary files',
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
            onTap: _performRateUs,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share with friends and family',
            color: Colors.teal,
            onTap: _performShareApp,
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
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blueAccent, size: 24),
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
        activeColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blueAccent, size: 24),
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
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: const Color(0xFF0A0E21),
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
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
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blueAccent, size: 24),
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
          color: Colors.blueAccent,
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