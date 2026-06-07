import 'package:flutter/material.dart';
import '../Setting/Setting_Police.dart';
import '../Setting/help_support.dart';
import '../Setting/privacy_policy.dart';
import '../Setting/edit_profile.dart';

class PoliceDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PoliceDashboard({super.key, required this.userData});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    userData = widget.userData;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateUserData(Map<String, dynamic> updatedData) {
    setState(() {
      userData = updatedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: _tabController,
        children: [
          _IncidentsTab(userData: userData),
          _AllIncidentsTab(),
          _MapTab(),
          _ProfileTab(userData: userData, onUpdateUserData: _updateUserData),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blueAccent.withOpacity(0.2),
        buttonBackgroundColor: Colors.blueAccent,
        height: 60,
        items: const [
          Icon(Icons.warning, size: 30, color: Colors.white),
          Icon(Icons.assignment_turned_in, size: 30, color: Colors.white),
          Icon(Icons.map, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _tabController.animateTo(index);
          });
        },
      ),
    );
  }
}

class CurvedNavigationBar extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final Color buttonBackgroundColor;
  final double height;
  final List<Widget> items;
  final Function(int) onTap;

  const CurvedNavigationBar({
    super.key,
    required this.backgroundColor,
    required this.color,
    required this.buttonBackgroundColor,
    required this.height,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: buttonBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: items[index],
            ),
          );
        }),
      ),
    );
  }
}

class _IncidentsTab extends StatelessWidget {
  final Map<String, dynamic> userData;

  const _IncidentsTab({required this.userData});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF0A0E21)],
        ),
      ),
      child: Column(
        children: [
          _GlassContainer(
            margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Police Dashboard',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Welcome, ${userData['name']?.split(' ').first ?? 'Officer'}',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _showMessage(context, 'Notifications clicked');
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showMessage(context, 'Pending incidents clicked');
                    },
                    child: _GlassContainer(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: const [
                          Icon(Icons.pending_actions, color: Colors.orange, size: 30),
                          SizedBox(height: 8),
                          Text('Pending', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          SizedBox(height: 5),
                          Text('3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showMessage(context, 'Action incidents clicked');
                    },
                    child: _GlassContainer(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: const [
                          Icon(Icons.play_circle_fill, color: Colors.blue, size: 30),
                          SizedBox(height: 8),
                          Text('Action', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          SizedBox(height: 5),
                          Text('5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showMessage(context, 'Completed incidents clicked');
                    },
                    child: _GlassContainer(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green, size: 30),
                          SizedBox(height: 8),
                          Text('Completed', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          SizedBox(height: 5),
                          Text('12', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Incidents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('View All', style: TextStyle(fontSize: 14, color: Colors.blueAccent)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildIncidentCard(context, type: 'Road Accident', location: '📍 31.5204, 74.3587', time: '10:30 AM', status: 'Pending', statusColor: Colors.orange, statusIcon: Icons.pending, priority: 'High'),
                _buildIncidentCard(context, type: 'Fire Breakout', location: '📍 31.5204, 74.3587', time: '09:45 AM', status: 'Action', statusColor: Colors.blue, statusIcon: Icons.play_circle_fill, priority: 'High'),
                _buildIncidentCard(context, type: 'Medical Emergency', location: '📍 31.5204, 74.3587', time: '08:15 AM', status: 'Completed', statusColor: Colors.green, statusIcon: Icons.check_circle, priority: 'Medium'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, {required String type, required String location, required String time, required String status, required Color statusColor, required IconData statusIcon, required String priority}) {
    return GestureDetector(
      onTap: () {
        _showMessage(context, '$type incident clicked');
      },
      child: _GlassContainer(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(statusIcon, color: statusColor),
                    ),
                    const SizedBox(width: 10),
                    Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.white70),
                const SizedBox(width: 5),
                Expanded(child: Text(location, style: const TextStyle(color: Colors.white70))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.white70),
                const SizedBox(width: 5),
                Text(time, style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                Text('Priority: $priority', style: TextStyle(color: priority == 'High' ? Colors.red : Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllIncidentsTab extends StatelessWidget {
  const _AllIncidentsTab();

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF0A0E21)],
        ),
      ),
      child: Column(
        children: [
          _GlassContainer(
            margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: const Text('All Incidents', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildIncidentCard(context, type: 'Road Accident', location: '📍 31.5204, 74.3587', time: '10:30 AM', status: 'Pending', statusColor: Colors.orange, priority: 'High'),
                _buildIncidentCard(context, type: 'Fire Breakout', location: '📍 31.5204, 74.3587', time: '09:45 AM', status: 'Action', statusColor: Colors.blue, priority: 'High'),
                _buildIncidentCard(context, type: 'Medical Emergency', location: '📍 31.5204, 74.3587', time: '08:15 AM', status: 'Completed', statusColor: Colors.green, priority: 'Medium'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, {required String type, required String location, required String time, required String status, required Color statusColor, required String priority}) {
    return GestureDetector(
      onTap: () {
        _showMessage(context, '$type incident details');
      },
      child: _GlassContainer(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(status == 'Pending' ? Icons.pending : status == 'Action' ? Icons.play_circle_fill : Icons.check_circle, color: statusColor),
                    ),
                    const SizedBox(width: 10),
                    Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.white70),
                const SizedBox(width: 5),
                Expanded(child: Text(location, style: const TextStyle(color: Colors.white70))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.white70),
                const SizedBox(width: 5),
                Text(time, style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                Text('Priority: $priority', style: TextStyle(color: priority == 'High' ? Colors.red : Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab();

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF0A0E21)],
        ),
      ),
      child: Column(
        children: [
          _GlassContainer(
            margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: const Text('Live Incident Map', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: Center(
              child: _GlassContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.map, size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 20),
                    const Text('Map View', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text('Live incident locations will appear here', style: TextStyle(fontSize: 14, color: Colors.white70), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showMessage(context, 'Refresh map clicked');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Refresh Map'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onUpdateUserData;

  const _ProfileTab({
    required this.userData,
    required this.onUpdateUserData,
  });

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userData: userData,
          userRole: 'Police',
        ),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      onUpdateUserData(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF0A0E21)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () => _editProfile(context),
            child: _GlassContainer(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['name'] ?? 'John Doe',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userData['role'] ?? 'POLICE OFFICER',
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to edit profile',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          _GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                      onPressed: () => _editProfile(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildProfileItem(Icons.email, 'Email', userData['email'] ?? 'Not provided'),
                _buildProfileItem(Icons.phone, 'Phone', userData['phone'] ?? 'Not provided'),
                _buildProfileItem(Icons.badge, 'CNIC', userData['cnic'] ?? 'Not provided'),
                _buildProfileItem(Icons.family_restroom, 'Father Name', userData['fatherName'] ?? 'Not provided'),
                _buildProfileItem(Icons.cake, 'Date of Birth', userData['dateOfBirth'] ?? 'Not provided'),
              ],
            ),
          ),

          const SizedBox(height: 15),

          _GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Professional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                      onPressed: () => _editProfile(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildProfileItem(Icons.military_tech, 'Rank', userData['rank'] ?? 'Not provided'),
                _buildProfileItem(Icons.confirmation_number, 'Badge Number', userData['badgeNumber'] ?? 'Not provided'),
                _buildProfileItem(Icons.assignment_ind, 'Service ID', userData['serviceId'] ?? 'Not provided'),
                _buildProfileItem(Icons.calendar_today, 'Joining Date', userData['joiningDate'] ?? 'Not provided'),
                _buildProfileItem(Icons.location_on, 'Station', userData['station'] ?? 'Not provided'),
                _buildProfileItem(Icons.business, 'Department', userData['department'] ?? 'Not provided'),
              ],
            ),
          ),

          const SizedBox(height: 15),

          _GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                _buildActionButton(context, Icons.settings, 'Settings', isSettings: true),
                _buildActionButton(context, Icons.help, 'Help & Support', isHelp: true),
                _buildActionButton(context, Icons.private_connectivity, 'Privacy Policy', isPrivacy: true),
              ],
            ),
          ),

          const SizedBox(height: 15),

          _GlassContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.calendar_month, size: 14, color: Colors.white70),
                SizedBox(width: 8),
                Text('Account created: 01/01/2024', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String title, {bool isSettings = false, bool isHelp = false, bool isPrivacy = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: () {
        if (isSettings) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(userData: userData),
            ),
          );
        } else if (isHelp) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HelpSupportScreen(
                userData: userData,
                userRole: 'Police',
              ),
            ),
          );
        } else if (isPrivacy) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivacyPolicyScreen(
                userData: userData,
                userRole: 'Police',
              ),
            ),
          );
        } else {
          _showMessage(context, '$title clicked');
        }
      },
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
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: child,
    );
  }
}