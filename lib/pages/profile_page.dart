import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user from Firebase
    final User? user = AuthService().currentUser;

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            
            // Profile Card
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
                  const Icon(Icons.account_circle, size: 80, color: Colors.indigo),
                  const SizedBox(height: 20),
                  const Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  
                  // User Details
                  if (user != null) ...[
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.grey),
                      title: const Text('Email'),
                      subtitle: Text(user.email ?? 'No Email'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.badge, color: Colors.grey),
                      title: const Text('User ID'),
                      subtitle: Text(user.uid, style: const TextStyle(fontSize: 12)),
                    ),
                  ] else 
                    const Text('No user logged in'),

                  const SizedBox(height: 40),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent, 
                        padding: const EdgeInsets.symmetric(vertical: 15)
                      ),
                      onPressed: () async {
                        await AuthService().signOut();
                        // Navigate back home and remove all previous routes
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      child: const Text('Sign Out', style: TextStyle(color: Colors.white, fontSize: 16)),
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