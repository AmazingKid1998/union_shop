import 'dart:convert';
import 'package:flutter/services.dart';

class AuthService {
  // Singleton pattern so the list persists across pages
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  List<Map<String, String>> _users = [];
  bool _isLoaded = false;

  // Load users from JSON file (Run this when app starts or login page loads)
  Future<void> loadUsers() async {
    if (_isLoaded) return; // Don't reload if already loaded

    try {
      final String response = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> data = json.decode(response);
      
      _users = data.map((item) => {
        'email': item['email'].toString(),
        'password': item['password'].toString(),
        'name': item['name'].toString(),
      }).toList();
      
      _isLoaded = true;
      print("Users Loaded: ${_users.length}");
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  // LOGIN: Check if email/password match
  bool login(String email, String password) {
    for (var user in _users) {
      if (user['email'] == email && user['password'] == password) {
        return true;
      }
    }
    return false;
  }

  // SIGNUP: Add new user to the list
  bool signup(String email, String password, String name) {
    // Check if email already exists
    for (var user in _users) {
      if (user['email'] == email) return false; // Fail if exists
    }

    // Add to in-memory list
    _users.add({
      'email': email,
      'password': password,
      'name': name
    });
    
    print("New User Added: $email");
    return true; // Success
  }
}