import 'package:flutter/material.dart';
import '../SignUp/police_signup.dart'; // Import police_signup page
import '../SignUp/fire_brigade_signup.dart'; // Import fire_brigade_signup page';
import '../SignUp/rescue_signup.dart'; // Import rescue_signup page
import '../SignUp/traffic_police_signup.dart'; // Import citizen_signup page';
import '../SignUp/citizen_signup.dart'; // Import citizen_signup page';


class ServiceButtonsScreen extends StatefulWidget {
  const ServiceButtonsScreen({super.key});

  @override
  State<ServiceButtonsScreen> createState() => _ServiceButtonsScreenState();
}

class _ServiceButtonsScreenState extends State<ServiceButtonsScreen> {
  // Method to handle button clicks with navigation
  void handleButtonClick(String buttonName) {
    switch (buttonName) {
      case 'Police':
      // Navigate to police_signup.dart
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PoliceSignupScreen()),
        );
        break;

      case 'Traffic Police':
      // Show message for now (you can add navigation later)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrafficPoliceSignupScreen()),
        );
        break;

      case 'Rescue':
      // Show message for now (you can add navigation later)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RescueSignupScreen()),
        );
        break;

      case 'Fire Brigade':
      // Show message for now (you can add navigation later)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FireBrigadeSignupScreen()),
        );
        break;

      case 'Citizen':
      // Show message for now (you can add navigation later)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CitizenSignupScreen()),
        );
        break;

      default:
        _showMessageDialog(buttonName, '$buttonName Clicked ✅');
    }
  }

  // Method to show dialog message
  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: Colors.green,
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
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Services',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0A0E21), Color(0xFF1A1A2E)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button 1: Police - Opens police_signup.dart
                _buildServiceButton(
                  buttonName: 'Police',
                  icon: Icons.local_police,
                  color: Colors.blue,
                ),

                const SizedBox(height: 15),

                // Button 2: Traffic Police
                _buildServiceButton(
                  buttonName: 'Traffic Police',
                  icon: Icons.traffic,
                  color: Colors.orange,
                ),

                const SizedBox(height: 15),

                // Button 3: Rescue
                _buildServiceButton(
                  buttonName: 'Rescue',
                  icon: Icons.health_and_safety,
                  color: Colors.red,
                ),

                const SizedBox(height: 15),

                // Button 4: Fire Brigade
                _buildServiceButton(
                  buttonName: 'Fire Brigade',
                  icon: Icons.local_fire_department,
                  color: Colors.deepOrange,
                ),

                const SizedBox(height: 15),

                // Button 5: Citizen
                _buildServiceButton(
                  buttonName: 'Citizen',
                  icon: Icons.people,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom button widget
  Widget _buildServiceButton({
    required String buttonName,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => handleButtonClick(buttonName),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 10),
            Text(
              buttonName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}