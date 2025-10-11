import '../models/patient_balance_result.dart';
import '../services/balance_service.dart';

class BalanceRepository {
  // Menyimpan data balance baru
  Future<String?> saveBalanceResult(PatientBalanceResult result) async {
    try {
      return await BalanceService.saveBalanceResult(result);
    } catch (e) {
      print('Repository Error - Save balance result: $e');
      rethrow;
    }
  }

  // Mendapatkan semua data balance
  Future<List<PatientBalanceResult>> getBalanceResults() async {
    try {
      return await BalanceService.getBalanceResults();
    } catch (e) {
      print('Repository Error - Get balance results: $e');
      rethrow;
    }
  }

  // Mendapatkan data balance berdasarkan ID
  Future<PatientBalanceResult?> getBalanceResultById(String id) async {
    try {
      return await BalanceService.getBalanceResultById(id);
    } catch (e) {
      print('Repository Error - Get balance result by ID: $e');
      rethrow;
    }
  }

  // Mengupdate data balance
  Future<void> updateBalanceResult(PatientBalanceResult result) async {
    try {
      await BalanceService.updateBalanceResult(result);
    } catch (e) {
      print('Repository Error - Update balance result: $e');
      rethrow;
    }
  }

  // Menghapus data balance
  Future<void> deleteBalanceResult(String id) async {
    try {
      await BalanceService.deleteBalanceResult(id);
    } catch (e) {
      print('Repository Error - Delete balance result: $e');
      rethrow;
    }
  }

  // Mendapatkan stream data balance
  Stream<List<PatientBalanceResult>> getBalanceResultsStream() {
    try {
      return BalanceService.getBalanceResultsStream();
    } catch (e) {
      print('Repository Error - Get balance results stream: $e');
      rethrow;
    }
  }

  // Mencari data balance berdasarkan nama pasien
  Future<List<PatientBalanceResult>> searchBalanceResults(String patientName) async {
    try {
      return await BalanceService.searchBalanceResults(patientName);
    } catch (e) {
      print('Repository Error - Search balance results: $e');
      rethrow;
    }
  }

  // Mendapatkan statistik data balance
  Future<Map<String, int>> getBalanceStatistics() async {
    try {
      return await BalanceService.getBalanceStatistics();
    } catch (e) {
      print('Repository Error - Get balance statistics: $e');
      rethrow;
    }
  }
}