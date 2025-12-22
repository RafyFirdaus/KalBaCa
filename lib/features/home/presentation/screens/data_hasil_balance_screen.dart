import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';
import '../../data/models/patient_balance_result.dart';
import '../../data/repositories/balance_repository.dart';
import 'package:intl/intl.dart';

class DataHasilBalanceScreen extends StatefulWidget {
  const DataHasilBalanceScreen({super.key});

  @override
  State<DataHasilBalanceScreen> createState() => _DataHasilBalanceScreenState();
}

class _DataHasilBalanceScreenState extends State<DataHasilBalanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BalanceRepository _balanceRepository = BalanceRepository();
  List<PatientBalanceResult> _allPatients = [];
  List<PatientBalanceResult> _filteredPatients = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final patients = await _balanceRepository.getBalanceResults();

      setState(() {
        _allPatients = patients;
        _filteredPatients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        return patient.patientName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showPatientDetail(PatientBalanceResult patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PatientDetailDialog(patient: patient);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Data Hasil Balance Pasien',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _loadPatientData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPatientData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return _buildPatientList();
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari nama pasien...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientList() {
    if (_filteredPatients.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada data pasien ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = _filteredPatients[index];
        return _buildPatientCard(patient);
      },
    );
  }

  Widget _buildPatientCard(PatientBalanceResult patient) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final balance = patient.balanceData['balance'] ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue,
          child: Text(
            patient.patientName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          patient.patientName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(patient.createdAt),
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getBalanceTypeColor(patient.balanceType),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getBalanceTypeLabel(patient.balanceType),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Balance: ${balance.toStringAsFixed(0)} ml',
                  style: TextStyle(
                    color: balance >= 0 ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () => _showPatientDetail(patient),
      ),
    );
  }

  Color _getBalanceTypeColor(String balanceType) {
    switch (balanceType) {
      case 'adult':
        return Colors.blue;
      case 'child':
        return Colors.green;
      case 'burn':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getBalanceTypeLabel(String balanceType) {
    switch (balanceType) {
      case 'adult':
        return 'Dewasa';
      case 'child':
        return 'Anak';
      case 'burn':
        return 'Luka Bakar';
      default:
        return 'Unknown';
    }
  }
}

// Dialog untuk menampilkan detail pasien
class PatientDetailDialog extends StatelessWidget {
  final PatientBalanceResult patient;

  const PatientDetailDialog({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy HH:mm');
    final balanceData = patient.balanceData;
    final balance = balanceData['balance'] ?? 0.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detail Pasien',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0047AB),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data Pasien Section
                    _buildSectionTitle('Data Pasien'),
                    const SizedBox(height: 12),
                    _buildDataRow('Nama', patient.patientName),
                    _buildDataRow('Usia', '${patient.age} tahun'),
                    _buildDataRow('Berat Badan', '${patient.weight} kg'),
                    _buildDataRow('Jenis Kelamin', patient.gender),
                    _buildDataRow(
                      'Tipe Balance',
                      _getBalanceTypeLabel(patient.balanceType),
                    ),
                    _buildDataRow(
                      'Tanggal Dibuat',
                      dateFormat.format(patient.createdAt),
                    ),

                    const SizedBox(height: 24),

                    // Hasil Balance Section
                    _buildSectionTitle('Hasil Balance'),
                    const SizedBox(height: 12),
                    if (balanceData['targetKebutuhanCairan'] != null)
                      _buildDataRow(
                        'Target Kebutuhan Cairan',
                        '${balanceData['targetKebutuhanCairan'].toStringAsFixed(0)} ml',
                      ),
                    if (balanceData['totalIntake'] != null)
                      _buildDataRow(
                        'Total Intake',
                        '${balanceData['totalIntake'].toStringAsFixed(0)} ml',
                      ),
                    if (balanceData['totalOutput'] != null)
                      _buildDataRow(
                        'Total Output',
                        '${balanceData['totalOutput'].toStringAsFixed(0)} ml',
                      ),
                    _buildBalanceRow('Balance (+/-)', balance),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0047AB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBalanceTypeLabel(String balanceType) {
    switch (balanceType) {
      case 'adult':
        return 'Balance Cairan Dewasa';
      case 'child':
        return 'Balance Cairan Anak';
      case 'burn':
        return 'Balance Cairan Luka Bakar';
      default:
        return 'Unknown';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0047AB),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, double balance) {
    Color balanceColor = balance >= 0 ? Colors.green : Colors.red;
    String balanceText =
        '${balance >= 0 ? '+' : ''}${balance.toStringAsFixed(0)} ml';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              balanceText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: balanceColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
