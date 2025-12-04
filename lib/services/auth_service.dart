import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user (returns null if not logged in)
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth state changes (optional, useful for redirecting)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // LOGIN: Returns error message string (null if success)
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the specific Firebase error (e.g. "User not found")
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  // SIGNUP: Returns error message string (null if success)
  Future<String?> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // e.g. "Email already in use"
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  // SIGNOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}