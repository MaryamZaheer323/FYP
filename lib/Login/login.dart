// import 'package:flutter/material.dart';
// import '../Dashboard/police_dashboard.dart';
// import '../Dashboard/traffic_police_dashboard.dart';
// import '../Dashboard/rescue_dashboard.dart';
// import '../Dashboard/fire_brigade_dashboard.dart';
// import '../Dashboard/citizen_dashboard.dart';
// import '../homepage.dart'; // Add this import

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void _login() {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showErrorDialog('Please enter email and password');
//       return;
//     }

//     // Check email domain and navigate to respective dashboard
//     if (email.endsWith('@punjabpolice.gov.pk')) {
//       // Navigate to Police Dashboard
//       _navigateToDashboard(
//         PoliceDashboard(
//           userData: {
//             'name': 'Police Officer',
//             'email': email,
//             'role': 'POLICE OFFICER',
//             'phone': 'Not provided',
//             'cnic': 'Not provided',
//             'fatherName': 'Not provided',
//             'dateOfBirth': 'Not provided',
//             'rank': 'Not provided',
//             'badgeNumber': 'Not provided',
//             'serviceId': 'Not provided',
//             'station': 'Not provided',
//             'department': 'Not provided',
//             'joiningDate': 'Not provided',
//           },
//         ),
//       );
//     }
//     else if (email.endsWith('@trafficpolice.gov.pk')) {
//       // Navigate to Traffic Police Dashboard
//       _navigateToDashboard(
//         TrafficPoliceDashboard(
//           userData: {
//             'name': 'Traffic Officer',
//             'email': email,
//             'role': 'TRAFFIC OFFICER',
//             'phone': 'Not provided',
//             'cnic': 'Not provided',
//             'fatherName': 'Not provided',
//             'dateOfBirth': 'Not provided',
//             'rank': 'Not provided',
//             'badgeNumber': 'Not provided',
//             'serviceId': 'Not provided',
//             'station': 'Not provided',
//             'department': 'Not provided',
//             'joiningDate': 'Not provided',
//           },
//         ),
//       );
//     }
//     else if (email.endsWith('@rescue.gov.pk')) {
//       // Navigate to Rescue Dashboard
//       _navigateToDashboard(
//         RescueDashboard(
//           userData: {
//             'name': 'Rescue Officer',
//             'email': email,
//             'role': 'RESCUE OFFICER',
//             'phone': 'Not provided',
//             'cnic': 'Not provided',
//             'fatherName': 'Not provided',
//             'dateOfBirth': 'Not provided',
//             'rank': 'Not provided',
//             'badgeNumber': 'Not provided',
//             'serviceId': 'Not provided',
//             'station': 'Not provided',
//             'department': 'Not provided',
//             'joiningDate': 'Not provided',
//           },
//         ),
//       );
//     }
//     else if (email.endsWith('@firebrigade.gov.pk')) {
//       // Navigate to Fire Brigade Dashboard
//       _navigateToDashboard(
//         FireBrigadeDashboard(
//           userData: {
//             'name': 'Fire Officer',
//             'email': email,
//             'role': 'FIRE OFFICER',
//             'phone': 'Not provided',
//             'cnic': 'Not provided',
//             'fatherName': 'Not provided',
//             'dateOfBirth': 'Not provided',
//             'rank': 'Not provided',
//             'badgeNumber': 'Not provided',
//             'serviceId': 'Not provided',
//             'station': 'Not provided',
//             'department': 'Not provided',
//             'joiningDate': 'Not provided',
//           },
//         ),
//       );
//     }
//     else if (email.endsWith('@gmail.com')) {
//       // Navigate to Citizen Dashboard
//       _navigateToDashboard(
//         CitizenDashboard(
//           userData: {
//             'name': 'Citizen User',
//             'email': email,
//             'role': 'CITIZEN',
//             'phone': 'Not provided',
//             'cnic': 'Not provided',
//             'fatherName': 'Not provided',
//             'dateOfBirth': 'Not provided',
//             'address': 'Not provided',
//           },
//         ),
//       );
//     }
//     else {
//       _showErrorDialog('Invalid email domain. Please use valid email address.');
//     }
//   }

//   void _navigateToDashboard(Widget dashboard) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => dashboard),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         backgroundColor: Colors.red,
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         contentTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'OK',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToRegister() {
//     // Navigate to ServiceButtonsScreen (homepage) when Register is clicked
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ServiceButtonsScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.black, Color(0xFF0A0E21), Color(0xFF1A1A2E)],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Logo Section
//                   const Column(
//                     children: [
//                       Icon(
//                         Icons.apps,
//                         size: 80,
//                         color: Colors.blueAccent,
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Smart Disaster Response System',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white70,
//                           letterSpacing: 1,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 40),

//                   // Email Field
//                   TextField(
//                     controller: _emailController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: const TextStyle(color: Colors.white70),
//                       prefixIcon: const Icon(
//                         Icons.email,
//                         color: Colors.blueAccent,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.1),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 16,
//                       ),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                   ),

//                   const SizedBox(height: 20),

//                   // Password Field
//                   TextField(
//                     controller: _passwordController,
//                     style: const TextStyle(color: Colors.white),
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: const TextStyle(color: Colors.white70),
//                       prefixIcon: const Icon(
//                         Icons.lock,
//                         color: Colors.blueAccent,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.1),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 16,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Login Button
//                   ElevatedButton(
//                     onPressed: _login,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       elevation: 5,
//                     ),
//                     child: const Text(
//                       'LOGIN',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Forgot Password Button
//                   const TextButton(
//                     onPressed: null,
//                     child: Text(
//                       "Forgot Password?",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Register Button - Opens ServiceButtonsScreen
//                   TextButton(
//                     onPressed: _navigateToRegister,
//                     child: RichText(
//                       text: const TextSpan(
//                         text: "Don't have an account? ",
//                         style: TextStyle(color: Colors.white70),
//                         children: [
//                           TextSpan(
//                             text: 'Register',
//                             style: TextStyle(
//                               color: Colors.blueAccent,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

// lib/screens/login_screen.dart
import 'package:disaster_watch/service/firestore_service.dart';
import 'package:flutter/material.dart'; 
import '../Dashboard/police_dashboard.dart';
import '../Dashboard/traffic_police_dashboard.dart';
import '../Dashboard/rescue_dashboard.dart';
import '../Dashboard/fire_brigade_dashboard.dart';
import '../Dashboard/citizen_dashboard.dart';
import '../homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: "maryam@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "Younis@ns2828");
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _firestoreService.loginUser(email, password);
      
      // Navigate to respective dashboard based on role
      switch (user['role']) {
        case 'CITIZEN':
          _navigateToDashboard(CitizenDashboard(userData: user['data']));
          break;
        case 'POLICE OFFICER':
          _navigateToDashboard(PoliceDashboard(userData: user['data']));
          break;
        case 'FIRE OFFICER':
          _navigateToDashboard(FireBrigadeDashboard(userData: user['data']));
          break;
        case 'RESCUE OFFICER':
          _navigateToDashboard(RescueDashboard(userData: user['data']));
          break;
        case 'TRAFFIC OFFICER':
          _navigateToDashboard(TrafficPoliceDashboard(userData: user['data']));
          break;
        default:
          _showErrorDialog('Invalid user role');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToDashboard(Widget dashboard) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        backgroundColor: Colors.red,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServiceButtonsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0A0E21), Color(0xFF1A1A2E)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Column(
                    children: [
                      Icon(
                        Icons.apps,
                        size: 80,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Smart Disaster Response System',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.blueAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}