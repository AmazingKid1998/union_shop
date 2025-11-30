import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              width: 400,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(height: 20),
                  
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                  ),
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B0082), padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: () {
                        if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                           return;
                        }

                        // 1. Call Signup function
                        bool success = _authService.signup(_emailController.text, _passwordController.text, _nameController.text);
                        
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Created! Please Login.')));
                          Navigator.pop(context); // Go back to Login
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Email already exists')));
                        }
                      },
                      child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}