import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/patient_balance_result.dart';

class BalanceService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collection = 'patient_balance_results';

  // Mendapatkan user ID saat ini atau membuat anonymous user
  static Future<String> _getCurrentUserId() async {
    User? user = _auth.currentUser;
    
    if (user == null) {
      // Jika user belum login, buat anonymous user
      try {
        UserCredential userCredential = await _auth.signInAnonymously();
        user = userCredential.user;
        print('Signed in anonymously: ${user?.uid}');
      } catch (e) {
        print('Error signing in anonymously: $e');
        throw Exception('Gagal membuat sesi anonymous: $e');
      }
    }
    
    return user!.uid;
  }

  // Menyimpan data balance baru
  static Future<String?> saveBalanceResult(PatientBalanceResult result) async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      // Membuat data dengan user ID saat ini
      final resultWithUserId = result.copyWith(
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Menyimpan ke Firestore
      DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(resultWithUserId.toMap());

      return docRef.id;
    } catch (e) {
      print('Error saving balance result: $e');
      rethrow;
    }
  }

  // Mendapatkan semua data balance untuk user saat ini
  static Future<List<PatientBalanceResult>> getBalanceResults() async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      // Simplified query - hanya menggunakan where tanpa orderBy untuk menghindari composite index
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      // Sort di client side
      List<PatientBalanceResult> results = querySnapshot.docs
          .map((doc) => PatientBalanceResult.fromFirestore(doc))
          .toList();
      
      // Sort berdasarkan createdAt descending di client
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return results;
    } catch (e) {
      print('Error getting balance results: $e');
      rethrow;
    }
  }

  // Mendapatkan data balance berdasarkan ID
  static Future<PatientBalanceResult?> getBalanceResultById(String id) async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        PatientBalanceResult result = PatientBalanceResult.fromFirestore(doc);
        // Pastikan data milik user saat ini
        if (result.userId == userId) {
          return result;
        }
      }
      return null;
    } catch (e) {
      print('Error getting balance result by ID: $e');
      rethrow;
    }
  }

  // Mengupdate data balance
  static Future<void> updateBalanceResult(PatientBalanceResult result) async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      // Pastikan data milik user saat ini
      if (result.userId != userId) {
        throw Exception('Tidak memiliki akses untuk mengupdate data ini');
      }

      final updatedResult = result.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_collection)
          .doc(result.id)
          .update(updatedResult.toMap());
    } catch (e) {
      print('Error updating balance result: $e');
      rethrow;
    }
  }

  // Menghapus data balance
  static Future<void> deleteBalanceResult(String id) async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      // Pastikan data milik user saat ini sebelum menghapus
      PatientBalanceResult? result = await getBalanceResultById(id);
      if (result == null) {
        throw Exception('Data tidak ditemukan atau tidak memiliki akses');
      }

      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('Error deleting balance result: $e');
      rethrow;
    }
  }

  // Mendapatkan stream data balance untuk real-time updates
  static Stream<List<PatientBalanceResult>> getBalanceResultsStream() {
    return _auth.authStateChanges().asyncExpand((user) async* {
      if (user == null) {
        // Jika tidak ada user, coba buat anonymous
        try {
          await _auth.signInAnonymously();
          user = _auth.currentUser;
        } catch (e) {
          print('Error creating anonymous user for stream: $e');
          yield [];
          return;
        }
      }

      if (user != null) {
        // Simplified stream query tanpa orderBy
        yield* _firestore
            .collection(_collection)
            .where('userId', isEqualTo: user.uid)
            .snapshots()
            .map((snapshot) {
              List<PatientBalanceResult> results = snapshot.docs
                  .map((doc) => PatientBalanceResult.fromFirestore(doc))
                  .toList();
              
              // Sort di client side
              results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              return results;
            });
      } else {
        yield [];
      }
    });
  }

  // Mencari data balance berdasarkan nama pasien
  static Future<List<PatientBalanceResult>> searchBalanceResults(String patientName) async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      // Simplified search - hanya menggunakan where untuk userId
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      // Filter dan sort di client side
      List<PatientBalanceResult> results = querySnapshot.docs
          .map((doc) => PatientBalanceResult.fromFirestore(doc))
          .where((result) => result.patientName.toLowerCase().contains(patientName.toLowerCase()))
          .toList();
      
      // Sort berdasarkan nama pasien dan tanggal
      results.sort((a, b) {
        int nameComparison = a.patientName.compareTo(b.patientName);
        if (nameComparison != 0) return nameComparison;
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return results;
    } catch (e) {
      print('Error searching balance results: $e');
      rethrow;
    }
  }

  // Mendapatkan statistik data balance
  static Future<Map<String, int>> getBalanceStatistics() async {
    try {
      // Pastikan user terautentikasi (atau buat anonymous)
      String userId = await _getCurrentUserId();

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      Map<String, int> stats = {
        'total': querySnapshot.docs.length,
        'adult': 0,
        'child': 0,
        'burn': 0,
      };

      for (var doc in querySnapshot.docs) {
        PatientBalanceResult result = PatientBalanceResult.fromFirestore(doc);
        stats[result.balanceType] = (stats[result.balanceType] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('Error getting balance statistics: $e');
      rethrow;
    }
  }
}