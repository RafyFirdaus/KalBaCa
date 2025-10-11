import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';

class DataHasilBalanceScreen extends StatefulWidget {
  const DataHasilBalanceScreen({super.key});

  @override
  State<DataHasilBalanceScreen> createState() => _DataHasilBalanceScreenState();
}

class _DataHasilBalanceScreenState extends State<DataHasilBalanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PatientData> _allPatients = [];
  List<PatientData> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
    _filteredPatients = _allPatients;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDummyData() {
    // Data dummy untuk tampilan UI
    _allPatients = [
      PatientData(
        name: 'Ahmad Rizki',
        age: 35,
        weight: 70.0,
        height: 170.0,
        gender: 'Laki-laki',
        targetFluid: 2100.0,
        totalIntake: 1800.0,
        totalOutput: 1500.0,
        balance: 300.0,
        date: '15 Jan 2024',
      ),
      PatientData(
        name: 'Siti Nurhaliza',
        age: 28,
        weight: 55.0,
        height: 160.0,
        gender: 'Perempuan',
        targetFluid: 1650.0,
        totalIntake: 1700.0,
        totalOutput: 1400.0,
        balance: 300.0,
        date: '14 Jan 2024',
      ),
      PatientData(
        name: 'Budi Santoso',
        age: 42,
        weight: 80.0,
        height: 175.0,
        gender: 'Laki-laki',
        targetFluid: 2400.0,
        totalIntake: 2200.0,
        totalOutput: 1800.0,
        balance: 400.0,
        date: '13 Jan 2024',
      ),
      PatientData(
        name: 'Dewi Sartika',
        age: 31,
        weight: 60.0,
        height: 165.0,
        gender: 'Perempuan',
        targetFluid: 1800.0,
        totalIntake: 1600.0,
        totalOutput: 1700.0,
        balance: -100.0,
        date: '12 Jan 2024',
      ),
      PatientData(
        name: 'Andi Wijaya',
        age: 25,
        weight: 65.0,
        height: 168.0,
        gender: 'Laki-laki',
        targetFluid: 1950.0,
        totalIntake: 2000.0,
        totalOutput: 1600.0,
        balance: 400.0,
        date: '11 Jan 2024',
      ),
    ];
  }

  void _filterPatients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPatients = _allPatients;
      } else {
        _filteredPatients = _allPatients
            .where(
              (patient) =>
                  patient.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _showPatientDetail(PatientData patient) {
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
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(child: _buildPatientList()),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        onChanged: _filterPatients,
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

  Widget _buildPatientCard(PatientData patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue,
          child: Text(
            patient.name[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          patient.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          patient.date,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
}

// Dialog untuk menampilkan detail pasien
class PatientDetailDialog extends StatelessWidget {
  final PatientData patient;

  const PatientDetailDialog({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
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

            // Data Pasien Section
            _buildSectionTitle('Data Pasien'),
            const SizedBox(height: 12),
            _buildDataRow('Nama', patient.name),
            _buildDataRow('Usia', '${patient.age} tahun'),
            _buildDataRow('Berat Badan', '${patient.weight} kg'),
            _buildDataRow('Tinggi Badan', '${patient.height} cm'),
            _buildDataRow('Jenis Kelamin', patient.gender),
            _buildDataRow('Tanggal', patient.date),

            const SizedBox(height: 24),

            // Hasil Balance Section
            _buildSectionTitle('Hasil Balance'),
            const SizedBox(height: 12),
            _buildDataRow(
              'Target Kebutuhan Cairan',
              '${patient.targetFluid.toStringAsFixed(0)} ml',
            ),
            _buildDataRow(
              'Total Intake',
              '${patient.totalIntake.toStringAsFixed(0)} ml',
            ),
            _buildDataRow(
              'Total Output',
              '${patient.totalOutput.toStringAsFixed(0)} ml',
            ),
            _buildBalanceRow('Balance (+/-)', patient.balance),

            const Spacer(),

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

// Model data pasien
class PatientData {
  final String name;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final double targetFluid;
  final double totalIntake;
  final double totalOutput;
  final double balance;
  final String date;

  PatientData({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.targetFluid,
    required this.totalIntake,
    required this.totalOutput,
    required this.balance,
    required this.date,
  });
}
