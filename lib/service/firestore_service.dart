// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if email already exists in any collection
  Future<bool> isEmailRegistered(String email) async {
    final collections = ['citizens', 'police_officers', 'fire_officers', 'rescue_officers', 'traffic_officers'];
    
    for (String collection in collections) {
      final querySnapshot = await _firestore
          .collection(collection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  // Register Citizen
  Future<void> registerCitizen(Map<String, dynamic> userData, Map<String, File?> files) async {
    // Check if email already exists
    if (await isEmailRegistered(userData['email'])) {
      throw Exception('Email already registered!');
    }

    // Prepare document data
    final docData = {
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending', // pending, approved, rejected
      'documents': {
        'profilePhoto': files['profilePhoto']?.path,
        'scannedCNIC': files['scannedCNIC']?.path,
      },
    };

    // Add to citizens collection
    await _firestore.collection('citizens').add(docData);
  }

  // Register Police Officer
  Future<void> registerPoliceOfficer(Map<String, dynamic> userData, Map<String, File?> files) async {
    if (await isEmailRegistered(userData['email'])) {
      throw Exception('Email already registered!');
    }

    final docData = {
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'documents': {
        'scannedCNIC': files['scannedCNIC']?.path,
        'policeIDCardFront': files['policeIDCardFront']?.path,
        'policeIDCardBack': files['policeIDCardBack']?.path,
        'appointmentLetter': files['appointmentLetter']?.path,
        'recentPhotograph': files['recentPhotograph']?.path,
      },
    };

    await _firestore.collection('police_officers').add(docData);
  }

  // Register Fire Brigade Officer
  Future<void> registerFireOfficer(Map<String, dynamic> userData, Map<String, File?> files) async {
    if (await isEmailRegistered(userData['email'])) {
      throw Exception('Email already registered!');
    }

    final docData = {
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'documents': {
        'scannedCNIC': files['scannedCNIC']?.path,
        'fireIDCardFront': files['fireIDCardFront']?.path,
        'fireIDCardBack': files['fireIDCardBack']?.path,
        'appointmentLetter': files['appointmentLetter']?.path,
        'recentPhotograph': files['recentPhotograph']?.path,
      },
    };

    await _firestore.collection('fire_officers').add(docData);
  }

  // Register Rescue Officer
  Future<void> registerRescueOfficer(Map<String, dynamic> userData, Map<String, File?> files) async {
    if (await isEmailRegistered(userData['email'])) {
      throw Exception('Email already registered!');
    }

    final docData = {
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'documents': {
        'scannedCNIC': files['scannedCNIC']?.path,
        'rescueIDCardFront': files['rescueIDCardFront']?.path,
        'rescueIDCardBack': files['rescueIDCardBack']?.path,
        'appointmentLetter': files['appointmentLetter']?.path,
        'recentPhotograph': files['recentPhotograph']?.path,
      },
    };

    await _firestore.collection('rescue_officers').add(docData);
  }

  // Register Traffic Police Officer
  Future<void> registerTrafficOfficer(Map<String, dynamic> userData, Map<String, File?> files) async {
    if (await isEmailRegistered(userData['email'])) {
      throw Exception('Email already registered!');
    }

    final docData = {
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'documents': {
        'scannedCNIC': files['scannedCNIC']?.path,
        'trafficPoliceIDCardFront': files['trafficPoliceIDCardFront']?.path,
        'trafficPoliceIDCardBack': files['trafficPoliceIDCardBack']?.path,
        'appointmentLetter': files['appointmentLetter']?.path,
        'recentPhotograph': files['recentPhotograph']?.path,
      },
    };

    await _firestore.collection('traffic_officers').add(docData);
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final collections = {
      'citizens': 'CITIZEN',
      'police_officers': 'POLICE OFFICER',
      'fire_officers': 'FIRE OFFICER',
      'rescue_officers': 'RESCUE OFFICER',
      'traffic_officers': 'TRAFFIC OFFICER',
    };

    for (var entry in collections.entries) {
      final querySnapshot = await _firestore
          .collection(entry.key)
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        
        // Check if user is approved
        if (userData['status'] != 'approved') {
          throw Exception('Your account is pending approval. Please wait for admin approval.');
        }

        return {
          'id': userDoc.id,
          'role': entry.value,
          'data': userData,
        };
      }
    }
    
    throw Exception('Invalid email or password');
  }

  // Get user data by ID
  Future<Map<String, dynamic>> getUserData(String userId, String role) async {
    String collectionName = _getCollectionName(role);
    final doc = await _firestore.collection(collectionName).doc(userId).get();
    
    if (doc.exists) {
      return doc.data()!;
    }
    throw Exception('User not found');
  }

  String _getCollectionName(String role) {
    switch (role) {
      case 'CITIZEN':
        return 'citizens';
      case 'POLICE OFFICER':
        return 'police_officers';
      case 'FIRE OFFICER':
        return 'fire_officers';
      case 'RESCUE OFFICER':
        return 'rescue_officers';
      case 'TRAFFIC OFFICER':
        return 'traffic_officers';
      default:
        throw Exception('Invalid role');
    }
  }
}