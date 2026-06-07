import 'dart:io';

import 'package:disaster_watch/Dashboard/document_preview_screen.dart';
import 'package:flutter/material.dart';
import '../Citizens Pages/report_incident.dart';
import '../Citizens Pages/editprofile.dart';
import '../Citizens Pages/settingPage.dart';
import '../Citizens Pages/help_support.dart';
import '../Login/login.dart';

class CitizenDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CitizenDashboard({super.key, required this.userData});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        backgroundColor: Colors.purple,
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
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          userData['name']?.split(' ').first ?? 'Citizen',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              _showMessage(context, 'Notifications clicked');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _HomeTab(userData: userData),
          _ReportTab(userData: userData),
          _ProfileTab(userData: userData, onUpdateUserData: _updateUserData),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.purple.withOpacity(0.2),
        buttonBackgroundColor: Colors.purple,
        height: 60,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.add_alert, size: 30, color: Colors.white),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0E21),
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.deepPurple],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.purple),
                ),
                const SizedBox(height: 15),
                Text(
                  userData['name'] ?? 'John Citizen',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  userData['email'] ?? 'citizen@example.com',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                _RoleBadge(role: userData['role'] ?? 'CITIZEN'),
              ],
            ),
          ),
          _buildDrawerSection('Navigation', [
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                _tabController.animateTo(0);
                Navigator.pop(context);
              },
              isSelected: _currentIndex == 0,
            ),
            _buildDrawerItem(
              icon: Icons.report,
              title: 'My Reports',
              onTap: () {
                _showMessage(context, 'My Reports clicked');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.history,
              title: 'Report History',
              onTap: () {
                _showMessage(context, 'Report History clicked');
                Navigator.pop(context);
              },
            ),
          ]),
          _buildDrawerSection('Emergency', [
            _buildDrawerItem(
              icon: Icons.local_police,
              title: 'Police Stations',
              onTap: () {
                _showMessage(context, 'Police Stations clicked');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.local_hospital,
              title: 'Hospitals',
              onTap: () {
                _showMessage(context, 'Hospitals clicked');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.fire_truck,
              title: 'Fire Stations',
              onTap: () {
                _showMessage(context, 'Fire Stations clicked');
                Navigator.pop(context);
              },
            ),
          ]),
          _buildDrawerSection('Settings', [
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'App Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      userData: userData,
                      onUpdateUserData: _updateUserData,
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpSupportScreen(userData: userData),
                  ),
                );
              },
            ),
               _buildDrawerItem(
              icon: Icons.info,
              title: 'Document',
              onTap: () {
                _showMessage(context, 'Document clicked');

                // Convert documents from Firestore to File objects
                Map<String, File?> documents = {};

                if (userData['documents'] != null) {
                  Map<String, dynamic> docs = userData['documents'];
                  docs.forEach((key, value) {
                    if (value != null && value is String && value.isNotEmpty) {
                      // Check if file exists at the path
                      File file = File(value);
                      if (file.existsSync()) {
                        documents[key] = file;
                      }
                    }
                  });
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentPreviewScreen(
                      documents: documents,
                      userType: 'Citizen',
                      userName: userData['name'] ?? 'Citizen',
                    ),
                  ),
                );
              },
            ),
         
            _buildDrawerItem(
              icon: Icons.info,
              title: 'About App',
              onTap: () {
                _showMessage(context, 'About App clicked');
                Navigator.pop(context);
              },
            ),
         
         
          ]),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade700, Colors.red.shade900],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.purple.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white54,
          size: 20,
        ),
        tileColor: isSelected ? Colors.white.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
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
      decoration: BoxDecoration(color: backgroundColor),
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

class _HomeTab extends StatelessWidget {
  final Map<String, dynamic> userData;

  const _HomeTab({required this.userData});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _navigateToReportIncident(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportIncidentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color(0xFF0A0E21)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, isTablet),
                _buildStatsSection(context, isTablet),
                _buildQuickActionsSection(context, isTablet),
                _buildRecentIncidentsSection(context, isTablet),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return _GlassContainer(
      margin: EdgeInsets.only(
        top: 20,
        left: isTablet ? 30 : 20,
        right: isTablet ? 30 : 20,
      ),
      padding: isTablet ? const EdgeInsets.all(25) : const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back,',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userData['name']?.split(' ').first ?? 'John',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.white70),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  userData['address'] ?? "Lahore, Pakistan",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Colors.white70),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  userData['email'] ?? "john.citizen@example.com",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 30 : 20,
        vertical: 15,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 1.2 : 0.95,
        children: [
          _buildStatCard(
            context,
            title: 'Emergency Report',
            value: '5',
            icon: Icons.warning,
            color: Colors.red,
            isTablet: isTablet,
          ),
          _buildStatCard(
            context,
            title: 'My Reports',
            value: '12',
            icon: Icons.report,
            color: Colors.purple,
            isTablet: isTablet,
          ),
          _buildStatCard(
            context,
            title: 'Resolved',
            value: '9',
            icon: Icons.check_circle,
            color: Colors.green,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title clicked'),
            backgroundColor: Colors.purple,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: _GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: isTablet ? 28 : 22),
            ),
            FittedBox(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 30 : 20,
        vertical: 10,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: isTablet ? 1.15 : 0.95,
        children: [
          _buildQuickActionCard(
            context,
            icon: Icons.warning,
            title: 'Report Emergency',
            color: Colors.red,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: () {
        _navigateToReportIncident(context);
      },
      child: _GlassContainer(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 14 : 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: isTablet ? 30 : 24),
            ),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 15 : 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            FittedBox(
              child: Text(
                'Tap to open',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentIncidentsSection(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 30 : 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Incidents',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showMessage(context, 'View All clicked');
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 30 : 20),
          child: Column(
            children: [
              _buildIncidentCard(
                context,
                type: 'Medical Emergency',
                location: '📍 Civil Hospital, Karachi',
                time: '10:30 AM',
                status: 'Pending',
                typeColor: Colors.green,
                typeIcon: Icons.medical_services,
                description: 'Emergency medical assistance required',
              ),
              const SizedBox(height: 12),
              _buildIncidentCard(
                context,
                type: 'Road Accident',
                location: '📍 Motorway M2, Lahore',
                time: '09:45 AM',
                status: 'Active',
                typeColor: Colors.orange,
                typeIcon: Icons.car_crash,
                description: 'Multiple vehicles involved',
              ),
              const SizedBox(height: 12),
              _buildIncidentCard(
                context,
                type: 'Fire Breakout',
                location: '📍 Mall Road, Lahore',
                time: '08:15 AM',
                status: 'Resolved',
                typeColor: Colors.red,
                typeIcon: Icons.fireplace,
                description: 'Fire has been contained',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIncidentCard(
    BuildContext context, {
    required String type,
    required String location,
    required String time,
    required String status,
    required Color typeColor,
    required IconData typeIcon,
    required String description,
  }) {
    return _GlassContainer(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Reported by: ${userData['name'] ?? 'John Citizen'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Resolved' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
              Icon(Icons.access_time, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportTab extends StatelessWidget {
  final Map<String, dynamic> userData;

  const _ReportTab({required this.userData});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color(0xFF0A0E21)],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 30 : 20),
            child: Column(
              children: [
                _buildReportHeader(context, isTablet),
                const SizedBox(height: 30),
                _buildEmergencyContacts(context, isTablet),
                const SizedBox(height: 30),
                _buildQuickTips(isTablet),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader(BuildContext context, bool isTablet) {
    return _GlassContainer(
      padding: EdgeInsets.all(isTablet ? 30 : 20),
      child: Column(
        children: [
          const Icon(Icons.emergency, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'Hello, ${userData['name']?.split(' ').first ?? 'John'}!',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Report any emergency incident quickly and efficiently',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportIncidentScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'REPORT EMERGENCY',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(BuildContext context, bool isTablet) {
    return _GlassContainer(
      padding: EdgeInsets.all(isTablet ? 25 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contacts',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isTablet ? 3 : 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: isTablet ? 3 : 2.5,
            children: [
              _buildEmergencyContactCard(
                context,
                icon: Icons.local_police,
                name: 'Police',
                number: '15',
                color: Colors.blue,
              ),
              _buildEmergencyContactCard(
                context,
                icon: Icons.fire_truck,
                name: 'Fire Brigade',
                number: '16',
                color: Colors.red,
              ),
              _buildEmergencyContactCard(
                context,
                icon: Icons.medical_services,
                name: 'Rescue 1122',
                number: '1122',
                color: Colors.green,
              ),
              _buildEmergencyContactCard(
                context,
                icon: Icons.local_hospital,
                name: 'Ambulance',
                number: '115',
                color: Colors.purple,
              ),
              _buildEmergencyContactCard(
                context,
                icon: Icons.traffic,
                name: 'Traffic Police',
                number: '1915',
                color: Colors.orange,
              ),
              _buildEmergencyContactCard(
                context,
                icon: Icons.security,
                name: 'Anti-Terrorism',
                number: '1717',
                color: Colors.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(
    BuildContext context, {
    required IconData icon,
    required String name,
    required String number,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        _showMessage(context, 'Calling $name at $number');
      },
      child: _GlassContainer(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              number,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTips(bool isTablet) {
    return _GlassContainer(
      padding: EdgeInsets.all(isTablet ? 25 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Tips for Reporting',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const _QuickTipItem(
            icon: Icons.location_on,
            title: 'Accurate Location',
            description: 'Enable GPS for precise location',
          ),
          const _QuickTipItem(
            icon: Icons.description,
            title: 'Clear Description',
            description: 'Describe the incident briefly',
          ),
          const _QuickTipItem(
            icon: Icons.photo,
            title: 'Add Photos',
            description: 'Upload photos if safe to do so',
          ),
          const _QuickTipItem(
            icon: Icons.safety_check,
            title: 'Stay Safe',
            description: 'Ensure your safety first',
          ),
        ],
      ),
    );
  }
}

class _QuickTipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _QuickTipItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.purple, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
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

  const _ProfileTab({required this.userData, required this.onUpdateUserData});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple,
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
          onUpdateUserData: onUpdateUserData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color(0xFF0A0E21)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(isTablet, context),
                const SizedBox(height: 15),
                _buildPersonalInfo(isTablet, context),
                const SizedBox(height: 15),
                _buildAccountInfo(isTablet),
                const SizedBox(height: 15),
                _buildQuickActions(context, isTablet),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(bool isTablet, BuildContext context) {
    return GestureDetector(
      onTap: () => _editProfile(context),
      child: _GlassContainer(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: isTablet ? 120 : 100,
                  height: isTablet ? 120 : 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.deepPurple],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.purple,
                      size: isTablet ? 18 : 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              userData['name'] ?? 'John Citizen',
              style: TextStyle(
                fontSize: isTablet ? 26 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              userData['email'] ?? 'john.citizen@example.com',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                userData['role'] ?? 'CITIZEN',
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: isTablet ? 20 : 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(bool isTablet, BuildContext context) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(isTablet ? 25 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.purple, size: 20),
                onPressed: () => _editProfile(context),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            icon: Icons.phone,
            label: 'Phone',
            value: userData['phone'] ?? '+92 300 1234567',
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            icon: Icons.badge,
            label: 'CNIC',
            value: userData['cnic'] ?? '12345-6789012-3',
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            icon: Icons.family_restroom,
            label: 'Father Name',
            value: userData['fatherName'] ?? 'Robert Citizen',
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            icon: Icons.cake,
            label: 'Date of Birth',
            value: userData['dateOfBirth'] ?? '15/08/1990',
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            icon: Icons.home,
            label: 'Address',
            value: userData['address'] ?? 'Lahore, Pakistan',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.purple, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(bool isTablet) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(isTablet ? 25 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _buildAccountInfoItem(
            icon: Icons.calendar_today,
            label: 'Member Since',
            value: '01 Jan 2024',
          ),
          const SizedBox(height: 15),
          _buildAccountInfoItem(
            icon: Icons.verified,
            label: 'Verification Status',
            value: 'Verified',
            valueColor: Colors.green,
          ),
          const SizedBox(height: 15),
          _buildAccountInfoItem(
            icon: Icons.security,
            label: 'Account Type',
            value: userData['role'] ?? 'Citizen',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isTablet) {
    return _GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(isTablet ? 25 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isTablet ? 3 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isTablet ? 1.1 : 0.95,
            children: [
              _buildQuickActionButton(
                context,
                icon: Icons.edit,
                label: 'Edit Profile',
                color: Colors.green,
                isEditProfile: true,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.settings,
                label: 'Settings',
                color: Colors.orange,
                isSettings: true,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.help,
                label: 'Help',
                color: Colors.purple,
                isHelp: true,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.logout,
                label: 'Logout',
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    bool isEditProfile = false,
    bool isSettings = false,
    bool isHelp = false,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isEditProfile) {
          await _editProfile(context);
        } else if (isSettings) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(
                userData: userData,
                onUpdateUserData: onUpdateUserData,
              ),
            ),
          );
        } else if (isHelp) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HelpSupportScreen(userData: userData),
            ),
          );
        } else if (label == 'Logout') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          _showMessage(context, '$label clicked');
        }
      },
      child: _GlassContainer(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const _GlassContainer({required this.child, this.margin, this.padding});

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
