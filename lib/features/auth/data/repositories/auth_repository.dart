import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_result.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  // Get current user
  User? get currentUser => _authService.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Register new user
  Future<AuthResult> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      UserCredential? result = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result != null && result.user != null) {
        // Update user profile with username
        await _authService.updateUserProfile(displayName: username);
        
        return AuthResult.success(userId: result.user!.uid);
      } else {
        return AuthResult.failure('Gagal membuat akun');
      }
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Login user
  Future<AuthResult> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential? result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result != null && result.user != null) {
        return AuthResult.success(userId: result.user!.uid);
      } else {
        return AuthResult.failure('Gagal masuk');
      }
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Logout user
  Future<AuthResult> logoutUser() async {
    try {
      await _authService.signOut();
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Send password reset email
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Delete user account
  Future<AuthResult> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }
}