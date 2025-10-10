import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  // Update user profile (display name)
  Future<void> updateUserProfile({
    required String displayName,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal memperbarui profil: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Gagal keluar: ${e.toString()}');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal mengirim email reset kata sandi: ${e.toString()}');
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal menghapus akun: ${e.toString()}');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Kata sandi yang diberikan terlalu lemah.';
      case 'email-already-in-use':
        return 'Akun sudah ada untuk email tersebut.';
      case 'user-not-found':
        return 'Tidak ada pengguna yang ditemukan untuk email tersebut.';
      case 'wrong-password':
        return 'Kata sandi yang diberikan salah untuk pengguna tersebut.';
      case 'invalid-email':
        return 'Alamat email tidak valid.';
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak permintaan. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Masuk dengan Email dan Kata Sandi tidak diaktifkan.';
      case 'invalid-credential':
        return 'Kredensial yang diberikan tidak valid.';
      case 'account-exists-with-different-credential':
        return 'Akun sudah ada dengan alamat email yang sama tetapi kredensial masuk yang berbeda.';
      case 'requires-recent-login':
        return 'Operasi ini sensitif dan memerlukan autentikasi terbaru. Masuk lagi sebelum mencoba permintaan ini.';
      case 'provider-already-linked':
        return 'Penyedia telah ditautkan ke akun pengguna.';
      case 'no-such-provider':
        return 'Pengguna tidak memiliki penyedia ini yang ditautkan atau ID penyedia yang diberikan tidak ada.';
      case 'invalid-user-token':
        return 'Kredensial pengguna tidak lagi valid. Pengguna harus masuk lagi.';
      case 'network-request-failed':
        return 'Terjadi kesalahan jaringan. Silakan periksa koneksi internet Anda dan coba lagi.';
      case 'user-token-expired':
        return 'Kredensial pengguna telah kedaluwarsa. Pengguna harus masuk lagi.';
      default:
        return 'Terjadi kesalahan autentikasi: ${e.message}';
    }
  }
}