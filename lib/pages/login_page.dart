import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false; // Add loading state

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
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  const Text('Sign In', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  
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
                      onPressed: _isLoading ? null : () async { // Disable button while loading
                        setState(() => _isLoading = true);
                        
                        // Call Async Login
                        String? error = await _authService.login(
                          _emailController.text.trim(), 
                          _passwordController.text.trim()
                        );
                        
                        setState(() => _isLoading = false);

                        if (error == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successful!')));
                          Navigator.pushReplacementNamed(context, '/'); 
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(error)));
                        }
                      },
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                       Navigator.pushNamed(context, '/signup'); // Assuming you have a route for this or direct push
                    }, 
                    child: const Text('Create an account')
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