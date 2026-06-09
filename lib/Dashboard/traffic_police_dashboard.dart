// import 'package:flutter/material.dart';
// import '../Setting/Setting_Police.dart';
// import '../Setting/help_support.dart';
// import '../Setting/privacy_policy.dart';
// import '../Setting/edit_profile.dart';

// class TrafficPoliceDashboard extends StatefulWidget {
//   final Map<String, dynamic> userData;

//   const TrafficPoliceDashboard({super.key, required this.userData});

//   @override
//   State<TrafficPoliceDashboard> createState() => _TrafficPoliceDashboardState();
// }

// class _TrafficPoliceDashboardState extends State<TrafficPoliceDashboard>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _currentIndex = 0;
//   late Map<String, dynamic> userData;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     userData = widget.userData;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _updateUserData(Map<String, dynamic> updatedData) {
//     setState(() {
//       userData = updatedData;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _TrafficIncidentsTab(userData: userData),
//           _TrafficAllIncidentsTab(),
//           _TrafficMapTab(),
//           _TrafficProfileTab(userData: userData, onUpdateUserData: _updateUserData),
//         ],
//       ),
//       bottomNavigationBar: _TrafficCurvedNavigationBar(
//         backgroundColor: Colors.transparent,
//         color: Colors.orange.withOpacity(0.2),
//         buttonBackgroundColor: Colors.orange,
//         height: 60,
//         items: const [
//           Icon(Icons.traffic, size: 30, color: Colors.white),
//           Icon(Icons.assignment_turned_in, size: 30, color: Colors.white),
//           Icon(Icons.map, size: 30, color: Colors.white),
//           Icon(Icons.person, size: 30, color: Colors.white),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             _tabController.animateTo(index);
//           });
//         },
//       ),
//     );
//   }
// }

// class _TrafficCurvedNavigationBar extends StatelessWidget {
//   final Color backgroundColor;
//   final Color color;
//   final Color buttonBackgroundColor;
//   final double height;
//   final List<Widget> items;
//   final Function(int) onTap;

//   const _TrafficCurvedNavigationBar({
//     required this.backgroundColor,
//     required this.color,
//     required this.buttonBackgroundColor,
//     required this.height,
//     required this.items,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: backgroundColor,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(items.length, (index) {
//           return GestureDetector(
//             onTap: () => onTap(index),
//             child: Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: buttonBackgroundColor,
//                 shape: BoxShape.circle,
//               ),
//               child: items[index],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class _TrafficIncidentsTab extends StatelessWidget {
//   final Map<String, dynamic> userData;

//   const _TrafficIncidentsTab({required this.userData});

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.black, Color(0xFF0A0E21)],
//         ),
//       ),
//       child: Column(
//         children: [
//           _TrafficGlassContainer(
//             margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Traffic Police Dashboard',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Welcome, ${userData['name']?.split(' ').first ?? 'Officer'}',
//                       style: const TextStyle(fontSize: 14, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _showMessage(context, 'Notifications clicked');
//                   },
//                   child: const CircleAvatar(
//                     radius: 25,
//                     backgroundColor: Colors.orange,
//                     child: Icon(Icons.notifications, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _showMessage(context, 'Pending traffic incidents clicked');
//                     },
//                     child: _TrafficGlassContainer(
//                       padding: const EdgeInsets.all(5),
//                       child: Column(
//                         children: const [
//                           Icon(Icons.pending_actions, color: Colors.orange, size: 30),
//                           SizedBox(height: 8),
//                           Text('Pending', style: TextStyle(fontSize: 12, color: Colors.white70)),
//                           SizedBox(height: 5),
//                           Text('8', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _showMessage(context, 'Active traffic incidents clicked');
//                     },
//                     child: _TrafficGlassContainer(
//                       padding: const EdgeInsets.all(5),
//                       child: Column(
//                         children: const [
//                           Icon(Icons.play_circle_fill, color: Colors.orange, size: 30),
//                           SizedBox(height: 8),
//                           Text('Active', style: TextStyle(fontSize: 12, color: Colors.white70)),
//                           SizedBox(height: 5),
//                           Text('5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _showMessage(context, 'Completed traffic incidents clicked');
//                     },
//                     child: _TrafficGlassContainer(
//                       padding: const EdgeInsets.all(5),
//                       child: Column(
//                         children: const [
//                           Icon(Icons.check_circle, color: Colors.green, size: 30),
//                           SizedBox(height: 8),
//                           Text('Completed', style: TextStyle(fontSize: 12, color: Colors.white70)),
//                           SizedBox(height: 5),
//                           Text('15', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const Padding(
//             padding: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Recent Traffic Incidents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                 Text('View All', style: TextStyle(fontSize: 14, color: Colors.orange)),
//               ],
//             ),
//           ),

//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               children: [
//                 _buildIncidentCard(context, type: 'Traffic Jam', location: '📍 Mall Road, Lahore', time: '10:30 AM', status: 'Pending', statusColor: Colors.orange, statusIcon: Icons.pending, priority: 'High'),
//                 _buildIncidentCard(context, type: 'Road Accident', location: '📍 Motorway M2, Lahore', time: '09:45 AM', status: 'Active', statusColor: Colors.orange, statusIcon: Icons.play_circle_fill, priority: 'Critical'),
//                 _buildIncidentCard(context, type: 'Signal Malfunction', location: '📍 Faisal Chowk, Rawalpindi', time: '08:15 AM', status: 'Active', statusColor: Colors.orange, statusIcon: Icons.play_circle_fill, priority: 'High'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIncidentCard(BuildContext context, {required String type, required String location, required String time, required String status, required Color statusColor, required IconData statusIcon, required String priority}) {
//     return GestureDetector(
//       onTap: () {
//         _showMessage(context, '$type incident clicked');
//       },
//       child: _TrafficGlassContainer(
//         margin: const EdgeInsets.only(bottom: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(statusIcon, color: statusColor),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 16, color: Colors.white70),
//                 const SizedBox(width: 5),
//                 Expanded(child: Text(location, style: const TextStyle(color: Colors.white70))),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Icon(Icons.access_time, size: 16, color: Colors.white70),
//                 const SizedBox(width: 5),
//                 Text(time, style: const TextStyle(color: Colors.white70)),
//                 const Spacer(),
//                 Text('Priority: $priority', style: TextStyle(color: priority == 'Critical' ? Colors.red : Colors.orange, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TrafficAllIncidentsTab extends StatelessWidget {
//   const _TrafficAllIncidentsTab();

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.black, Color(0xFF0A0E21)],
//         ),
//       ),
//       child: Column(
//         children: [
//           _TrafficGlassContainer(
//             margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
//             child: const Text('All Traffic Incidents', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               children: [
//                 _buildIncidentCard(context, type: 'Traffic Jam', location: '📍 Mall Road, Lahore', time: '10:30 AM', status: 'Pending', statusColor: Colors.orange, priority: 'High'),
//                 _buildIncidentCard(context, type: 'Road Accident', location: '📍 Motorway M2, Lahore', time: '09:45 AM', status: 'Active', statusColor: Colors.orange, priority: 'Critical'),
//                 _buildIncidentCard(context, type: 'Signal Malfunction', location: '📍 Faisal Chowk, Rawalpindi', time: '08:15 AM', status: 'Active', statusColor: Colors.orange, priority: 'High'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIncidentCard(BuildContext context, {required String type, required String location, required String time, required String status, required Color statusColor, required String priority}) {
//     return GestureDetector(
//       onTap: () {
//         _showMessage(context, '$type incident details');
//       },
//       child: _TrafficGlassContainer(
//         margin: const EdgeInsets.only(bottom: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(status == 'Pending' ? Icons.pending : status == 'Active' ? Icons.play_circle_fill : Icons.check_circle, color: statusColor),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 16, color: Colors.white70),
//                 const SizedBox(width: 5),
//                 Expanded(child: Text(location, style: const TextStyle(color: Colors.white70))),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Icon(Icons.access_time, size: 16, color: Colors.white70),
//                 const SizedBox(width: 5),
//                 Text(time, style: const TextStyle(color: Colors.white70)),
//                 const Spacer(),
//                 Text('Priority: $priority', style: TextStyle(color: priority == 'Critical' ? Colors.red : Colors.orange, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TrafficMapTab extends StatelessWidget {
//   const _TrafficMapTab();

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.black, Color(0xFF0A0E21)],
//         ),
//       ),
//       child: Column(
//         children: [
//           _TrafficGlassContainer(
//             margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
//             child: const Text('Live Traffic Map', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//           ),
//           Expanded(
//             child: Center(
//               child: _TrafficGlassContainer(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.map, size: 80, color: Colors.orange),
//                     const SizedBox(height: 20),
//                     const Text('Traffic Control Map View', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                     const SizedBox(height: 10),
//                     const Text('Live traffic incident locations will appear here', style: TextStyle(fontSize: 14, color: Colors.white70), textAlign: TextAlign.center),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         _showMessage(context, 'Refresh map clicked');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: const Text('Refresh Map'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TrafficProfileTab extends StatelessWidget {
//   final Map<String, dynamic> userData;
//   final Function(Map<String, dynamic>) onUpdateUserData;

//   const _TrafficProfileTab({
//     required this.userData,
//     required this.onUpdateUserData,
//   });

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Future<void> _editProfile(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditProfileScreen(
//           userData: userData,
//           userRole: 'Traffic Police',
//         ),
//       ),
//     );
//     if (result != null && result is Map<String, dynamic>) {
//       onUpdateUserData(result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.black, Color(0xFF0A0E21)],
//         ),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           GestureDetector(
//             onTap: () => _editProfile(context),
//             child: _TrafficGlassContainer(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       const CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.orange,
//                         child: Icon(Icons.traffic, size: 40, color: Colors.white),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.edit,
//                             size: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     userData['name'] ?? 'Bilal Ahmed',
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   const SizedBox(height: 5),
//                   Container(
//                     margin: const EdgeInsets.only(top: 5),
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       userData['role'] ?? 'TRAFFIC OFFICER',
//                       style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Tap to edit profile',
//                     style: TextStyle(fontSize: 12, color: Colors.white54),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 15),

//           _TrafficGlassContainer(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
//                       onPressed: () => _editProfile(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 _buildProfileItem(Icons.email, 'Email', userData['email'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.phone, 'Phone', userData['phone'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.badge, 'CNIC', userData['cnic'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.family_restroom, 'Father Name', userData['fatherName'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.cake, 'Date of Birth', userData['dateOfBirth'] ?? 'Not provided'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 15),

//           _TrafficGlassContainer(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Professional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
//                       onPressed: () => _editProfile(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 _buildProfileItem(Icons.military_tech, 'Rank', userData['rank'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.confirmation_number, 'Badge Number', userData['badgeNumber'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.assignment_ind, 'Service ID', userData['serviceId'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.calendar_today, 'Joining Date', userData['joiningDate'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.location_on, 'Station', userData['station'] ?? 'Not provided'),
//                 _buildProfileItem(Icons.business, 'Department', userData['department'] ?? 'Not provided'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 15),

//           _TrafficGlassContainer(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                 const SizedBox(height: 20),
//                 _buildActionButton(context, Icons.settings, 'Settings', isSettings: true),
//                 _buildActionButton(context, Icons.help, 'Help & Support', isHelp: true),
//                 _buildActionButton(context, Icons.private_connectivity, 'Privacy Policy', isPrivacy: true),
//               ],
//             ),
//           ),

//           const SizedBox(height: 15),

//           _TrafficGlassContainer(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.calendar_month, size: 14, color: Colors.white70),
//                 SizedBox(width: 8),
//                 Text('Account created: 01/01/2024', style: TextStyle(fontSize: 12, color: Colors.white70)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileItem(IconData icon, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.orange, size: 22),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
//                 const SizedBox(height: 4),
//                 Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(BuildContext context, IconData icon, String title, {bool isSettings = false, bool isHelp = false, bool isPrivacy = false}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.orange),
//       title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
//       trailing: const Icon(Icons.chevron_right, color: Colors.white70),
//       onTap: () {
//         if (isSettings) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SettingsScreen(userData: userData),
//             ),
//           );
//         } else if (isHelp) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HelpSupportScreen(
//                 userData: userData,
//                 userRole: 'Traffic Police',
//               ),
//             ),
//           );
//         } else if (isPrivacy) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PrivacyPolicyScreen(
//                 userData: userData,
//                 userRole: 'Traffic Police',
//               ),
//             ),
//           );
//         } else {
//           _showMessage(context, '$title clicked');
//         }
//       },
//     );
//   }
// }

// class _TrafficGlassContainer extends StatelessWidget {
//   final Widget child;
//   final EdgeInsetsGeometry? margin;
//   final EdgeInsetsGeometry? padding;

//   const _TrafficGlassContainer({
//     required this.child,
//     this.margin,
//     this.padding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: margin ?? const EdgeInsets.all(16),
//       padding: padding ?? const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
//       ),
//       child: child,
//     );
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_watch/Dashboard/widgets/pending_reports_screen.dart';
import 'package:disaster_watch/Dashboard/widgets/resolved_reports_screen.dart';
import 'package:flutter/material.dart';
 

class TrafficPoliceDepartmentDashboardScreen extends StatefulWidget {
  final String department;
  final String departmentColor;
  final IconData departmentIcon;
  final String collectionName;

  const TrafficPoliceDepartmentDashboardScreen({
    super.key,
    required this.department,
    required this.departmentColor,
    required this.departmentIcon,
    required this.collectionName,
  });

  @override
  State<TrafficPoliceDepartmentDashboardScreen> createState() => _TrafficPoliceDepartmentDashboardScreenState();
}

class _TrafficPoliceDepartmentDashboardScreenState extends State<TrafficPoliceDepartmentDashboardScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color _bg        = Color(0xFF060B18);
  static const Color _surface   = Color(0xFF0D1526);
  static const Color _card      = Color(0xFF111C35);
  static const Color _border    = Color(0xFF1E2D50);
  static const Color _accent    = Color(0xFF3B82F6);   // police blue
  static const Color _accentGlow= Color(0xFF1D4ED8);
  static const Color _textPri   = Color(0xFFE8EDF7);
  static const Color _textSec   = Color(0xFF6B7FA3);
  static const Color _pending   = Color(0xFFF59E0B);
  static const Color _resolved  = Color(0xFF10B981);
  static const Color _rejected  = Color(0xFFEF4444);
  static const Color _inProg    = Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsRow(),
            _buildQuickNavRow(context),
            _buildSearchAndFilter(),
            Expanded(child: _buildReportStream()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Badge icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_accent, _accentGlow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: _accent.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Icon(widget.departmentIcon,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.department,
                      style: const TextStyle(
                        color: _textPri,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Text(
                      'Traffic Police',
                      style: TextStyle(
                          color: _textSec, fontSize: 12, letterSpacing: 0.2),
                    ),
                  ],
                ),
              ),
              // Live badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _resolved.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _resolved.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _resolved,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: _resolved.withOpacity(0.6),
                              blurRadius: 4)
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('LIVE',
                        style: TextStyle(
                            color: _resolved,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: _textSec, size: 22),
                onPressed: () => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .snapshots(),
      builder: (context, snapshot) {
        int total    = 0;
        int pending  = 0;
        int resolved = 0;
        int inProg   = 0;

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          total    = docs.length;
          pending  = docs.where((d) =>
              (d.data() as Map<String, dynamic>)['status'] == 'pending').length;
          resolved = docs.where((d) =>
              (d.data() as Map<String, dynamic>)['status'] == 'resolved').length;
          inProg   = docs.where((d) =>
              (d.data() as Map<String, dynamic>)['status'] == 'in-progress').length;
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              _statTile('Total',      total.toString(),    Icons.folder_open_rounded,   _accent),
              const SizedBox(width: 10),
              _statTile('Pending',    pending.toString(),  Icons.hourglass_top_rounded, _pending),
              const SizedBox(width: 10),
              _statTile('Active',     inProg.toString(),   Icons.bolt_rounded,          _inProg),
              const SizedBox(width: 10),
              _statTile('Resolved',   resolved.toString(), Icons.verified_rounded,      _resolved),
            ],
          ),
        );
      },
    );
  }

  Widget _statTile(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: _textSec, fontSize: 10, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  // ── Quick Nav Row ─────────────────────────────────────────────────────────
  Widget _buildQuickNavRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _navButton(
              icon: Icons.hourglass_top_rounded,
              label: 'Pending Reports',
              color: _pending,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PendingReportsScreen(
                    department:      widget.department,
                    departmentColor: widget.departmentColor,
                    departmentIcon:  widget.departmentIcon,
                    collectionName:  widget.collectionName,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _navButton(
              icon: Icons.verified_rounded,
              label: 'Resolved Reports',
              color: _resolved,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResolvedReportsScreen(
                    department:      widget.department,
                    departmentColor: widget.departmentColor,
                    departmentIcon:  widget.departmentIcon,
                    collectionName:  widget.collectionName,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.18), color.withOpacity(0.06)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: color.withOpacity(0.6), size: 13),
          ],
        ),
      ),
    );
  }

  // ── Search + Filter ───────────────────────────────────────────────────────
  Widget _buildSearchAndFilter() {
    final filters = ['all', 'pending', 'in-progress', 'resolved', 'rejected'];
    final labels  = ['All', 'Pending', 'Active', 'Resolved', 'Rejected'];
    final colors  = [_accent, _pending, _inProg, _resolved, _rejected];

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: TextField(
            style: const TextStyle(color: _textPri, fontSize: 14),
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search by citizen name or incident type...',
              hintStyle:
                  const TextStyle(color: _textSec, fontSize: 13),
              prefixIcon:
                  const Icon(Icons.search_rounded, color: _textSec, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: _textSec, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
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
                borderSide:
                    const BorderSide(color: _accent, width: 1.5),
              ),
            ),
          ),
        ),
        // Filter chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filters.length,
            itemBuilder: (_, i) {
              final selected = _selectedFilter == filters[i];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedFilter = filters[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? colors[i].withOpacity(0.2)
                        : _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? colors[i]
                          : _border,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: selected ? colors[i] : _textSec,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ── Report Stream ─────────────────────────────────────────────────────────
  Widget _buildReportStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: _accent, strokeWidth: 2));
        }

        var reports = snapshot.data!.docs;

        if (_selectedFilter != 'all') {
          reports = reports.where((d) {
            final data = d.data() as Map<String, dynamic>;
            return data['status'] == _selectedFilter;
          }).toList();
        }

        if (_searchQuery.isNotEmpty) {
          reports = reports.where((d) {
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

        if (reports.isEmpty) return _buildEmptyState();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: reports.length,
          itemBuilder: (_, i) {
            final report =
                reports[i].data() as Map<String, dynamic>;
            return _buildReportCard(report, reports[i].id);
          },
        );
      },
    );
  }

  // ── Report Card ───────────────────────────────────────────────────────────
// ── Report Card ───────────────────────────────────────────────────────────
Widget _buildReportCard(
    Map<String, dynamic> report, String reportId) {
  final statusColor = _getStatusColor(report['status']);
  final dateTime = _formatDateTime(report['timestamp']);

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        childrenPadding: EdgeInsets.zero,

        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                statusColor.withOpacity(0.30),
                statusColor.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: statusColor.withOpacity(0.40),
            ),
          ),
          child: Icon(
            widget.departmentIcon,
            color: statusColor,
            size: 20,
          ),
        ),

        title: Text(
          report['type'] ?? 'Unknown Incident',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _textPri,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 13,
                    color: _textSec,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report['citizenName'] ?? 'N/A',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textSec,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 13,
                    color: _textSec,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      dateTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textSec,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: statusColor.withOpacity(0.40),
            ),
          ),
          child: Text(
            (report['status'] ?? 'PENDING').toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),

        children: [
          Container(
            decoration: const BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionDivider('Citizen Information'),
                  const SizedBox(height: 12),

                  _infoGrid([
                    _InfoItem(
                      Icons.person_rounded,
                      'Name',
                      report['citizenName'] ?? 'N/A',
                    ),
                    _InfoItem(
                      Icons.phone_rounded,
                      'Phone',
                      report['citizenPhone'] ?? 'N/A',
                    ),
                    _InfoItem(
                      Icons.email_rounded,
                      'Email',
                      report['citizenEmail'] ?? 'N/A',
                    ),
                    _InfoItem(
                      Icons.badge_rounded,
                      'CNIC',
                      report['citizenCNIC'] ?? 'N/A',
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _sectionDivider('Incident Details'),
                  const SizedBox(height: 12),

                  _buildInfoRow(
                    Icons.description_rounded,
                    'Description',
                    report['description'] ?? 'N/A',
                  ),

                  const SizedBox(height: 8),

                  _buildInfoRow(
                    Icons.location_on_rounded,
                    'Location',
                    report['location'] ?? 'N/A',
                  ),

                  if (report['affectedPeople'] != null &&
                      report['affectedPeople'] > 0) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.people_alt_rounded,
                      'Affected',
                      '${report['affectedPeople']} people',
                    ),
                  ],

                  if (report['imageCount'] != null &&
                      report['imageCount'] > 0) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.image_rounded,
                      'Attachments',
                      '${report['imageCount']} photos',
                    ),
                  ],

                  const SizedBox(height: 20),

                  _sectionDivider('Update Status'),
                  const SizedBox(height: 12),

                  _buildStatusDropdown(
                    report,
                    reportId,
                  ),

                  const SizedBox(height: 16),

                  _buildActionButtons(
                    report,
                    reportId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _sectionDivider(String title) {
    return Row(children: [
      Text(title,
          style: const TextStyle(
              color: _accent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2)),
      const SizedBox(width: 10),
      const Expanded(child: Divider(color: _border, thickness: 1)),
    ]);
  }

  Widget _infoGrid(List<_InfoItem> items) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3.2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: items.map((item) {
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
          ),
          child: Row(children: [
            Icon(item.icon, size: 10, color: _accent),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.label,
                      style: const TextStyle(
                          color: _textSec, fontSize: 9, letterSpacing: 0.4)),
                  Text(item.value,
                      style: const TextStyle(
                          color: _textPri,
                          fontSize: 9,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ]),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _accent),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: _textSec, fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: _textPri,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(
      Map<String, dynamic> report, String reportId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: report['status'] ?? 'pending',
          isExpanded: true,
          dropdownColor: _surface,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _textSec),
          style: const TextStyle(color: _textPri, fontSize: 14),
          items: [
            _dropItem('pending',     'Pending',     Icons.hourglass_top_rounded,    _pending),
            _dropItem('in-progress', 'In Progress', Icons.bolt_rounded,             _inProg),
            _dropItem('resolved',    'Resolved',    Icons.verified_rounded,         _resolved),
            _dropItem('rejected',    'Rejected',    Icons.cancel_rounded,           _rejected),
          ],
          onChanged: (newStatus) async {
            await FirebaseFirestore.instance
                .collection(widget.collectionName)
                .doc(reportId)
                .update({
              'status': newStatus,
              'statusUpdatedAt': FieldValue.serverTimestamp(),
            });

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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Status updated to ${newStatus?.toUpperCase()}'),
                backgroundColor: _resolved,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ));
            }
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> _dropItem(
      String value, String label, IconData icon, Color color) {
    return DropdownMenuItem(
      value: value,
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildActionButtons(
      Map<String, dynamic> report, String reportId) {
    return Row(
      children: [
        Expanded(
          child: _actionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Message',
            color: _inProg,
            onTap: () => _showMessageDialog(report),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionBtn(
            icon: Icons.location_on_rounded,
            label: 'Location',
            color: _accent,
            onTap: () => _showLocationDialog(report),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionBtn(
            icon: Icons.verified_rounded,
            label: 'Resolve',
            color: _resolved,
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection(widget.collectionName)
                  .doc(reportId)
                  .update({'status': 'resolved'});
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Report marked as resolved'),
                  backgroundColor: _resolved,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3)),
        ]),
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────
  void _showMessageDialog(Map<String, dynamic> report) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => _StyledDialog(
        title: "Data",
        subtitle: 'To: ${report['citizenName']}',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: _inProg,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _border),
              ),
              child: Row(children: [
                const Icon(Icons.tag_rounded, size: 14, color: _textSec),
                const SizedBox(width: 6),
                Text('Report ID: ${report['reportId'] ?? 'N/A'}',
                    style: const TextStyle(
                        color: _textSec, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 4,
              style: const TextStyle(color: _textPri, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Type your response...',
                hintStyle:
                    const TextStyle(color: _textSec, fontSize: 13),
                filled: true,
                fillColor: _card,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: _inProg, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: _textSec)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _inProg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('department_messages')
                  .add({
                'reportId':     report['reportId'],
                'citizenEmail': report['citizenEmail'],
                'department':   widget.department,
                'message':      ctrl.text,
                'sender':       'department',
                'timestamp':    FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Message sent to citizen'),
                backgroundColor: _resolved,
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: const Text('Send',
                style: TextStyle(
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (_) => _StyledDialog(
        title: " Data",
        subtitle: 'GPS Coordinates',
        icon: Icons.location_on_rounded,
        iconColor: _rejected,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Column(children: [
                const Icon(Icons.location_on_rounded,
                    size: 40, color: _rejected),
                const SizedBox(height: 10),
                Text(
                  report['location'] ?? 'Unknown location',
                  style: const TextStyle(
                      color: _textPri,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use these coordinates to navigate to the incident location',
                  style: TextStyle(color: _textSec, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: _textSec)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.map_rounded, size: 16),
            label: const Text('Open Maps'),
          ),
        ],
      ),
    );
  }

  // ── Empty / Error ─────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _card,
              shape: BoxShape.circle,
              border: Border.all(color: _border, width: 2),
            ),
            child: const Icon(Icons.inbox_rounded,
                color: _textSec, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'No $_selectedFilter reports',
            style: const TextStyle(
                color: _textPri,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Reports will appear here once submitted',
            style: TextStyle(color: _textSec, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: _rejected, size: 48),
          const SizedBox(height: 12),
          Text(error,
              style: const TextStyle(color: _textSec, fontSize: 13)),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':     return _pending;
      case 'in-progress': return _inProg;
      case 'resolved':    return _resolved;
      case 'rejected':    return _rejected;
      default:            return _textSec;
    }
  }

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    try {
      if (timestamp is Timestamp) {
        final d = timestamp.toDate();
        return '${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
      } else if (timestamp is String) {
        final d = DateTime.parse(timestamp);
        return '${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    return 'Unknown date';
  }
}

// ── Helper model ─────────────────────────────────────────────────────────────
class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem(this.icon, this.label, this.value);
}

// ── Shared styled dialog ──────────────────────────────────────────────────────
class _StyledDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget content;
  final List<Widget> actions;

  const _StyledDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.content,
    required this.actions,
  });

  static const Color _bg      = Color(0xFF060B18);
  static const Color _surface = Color(0xFF0D1526);
  static const Color _card    = Color(0xFF111C35);
  static const Color _border  = Color(0xFF1E2D50);
  static const Color _textPri = Color(0xFFE8EDF7);
  static const Color _textSec = Color(0xFF6B7FA3);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: _border)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: iconColor.withOpacity(0.4)),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: _textPri,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: _textSec, fontSize: 10)),
                ],
              ),
            ]),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
