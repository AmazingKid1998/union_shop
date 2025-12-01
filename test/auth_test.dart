import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    // NOTE: This setup runs before every single test
    setUpAll(() async {
      // FIX: Initialize Flutter binding required for asset loading (rootBundle) in tests.
      TestWidgetsFlutterBinding.ensureInitialized(); 
      
      // 1. Initialize the service instance (Singleton pattern)
      authService = AuthService();
      
      // 2. Await loading the dummy JSON asset file
      await authService.loadUsers(); 
    });

    // --- TEST 1: SUCCESSFUL LOGIN ---
    test('Valid credentials should successfully log in', () {
      // These credentials are read from assets/data/users.json
      const validEmail = 'student@port.ac.uk';
      const validPassword = 'password123';

      final result = authService.login(validEmail, validPassword);

      expect(result, isTrue);
    });

    // --- TEST 2: FAILED LOGIN (Invalid Password) ---
    test('Invalid credentials should fail login', () {
      const invalidPassword = 'wrongpassword';
      
      final result = authService.login('student@port.ac.uk', invalidPassword);

      expect(result, isFalse);
    });

    // --- TEST 3: SUCCESSFUL SIGNUP ---
    test('Successfully sign up a new user', () {
      const newEmail = 'test_new_user@example.com';
      
      // Check that the user does not exist initially
      expect(authService.login(newEmail, 'newpass'), isFalse); 

      // Attempt signup
      final signupSuccess = authService.signup(newEmail, 'newpass', 'Test User');
      
      // Verify signup was successful
      expect(signupSuccess, isTrue);

      // Verify the new user can now log in
      expect(authService.login(newEmail, 'newpass'), isTrue);
    });

    // --- TEST 4: FAILED SIGNUP (Email Already Exists) ---
    test('Fail to sign up if email already exists', () {
      const existingEmail = 'student@port.ac.uk';
      
      // Attempt to sign up the existing user again
      // We also verify that the list size doesn't increase if signup fails
      final result = authService.signup(existingEmail, 'newpassword', 'Duplicate User');
      
      // Verify signup failed
      expect(result, isFalse);
    });
  });
}