import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'child_fluid_balance_simulation_screen.dart';

class ChildHasilBalanceScreen extends StatefulWidget {
  final double targetKebutuhanCairan;
  final double totalIntake;
  final double totalOutput;
  final String patientName;
  final double weightKg;
  final int age;

  const ChildHasilBalanceScreen({
    Key? key,
    required this.targetKebutuhanCairan,
    required this.totalIntake,
    required this.totalOutput,
    required this.patientName,
    required this.weightKg,
    required this.age,
  }) : super(key: key);

  @override
  State<ChildHasilBalanceScreen> createState() => _ChildHasilBalanceScreenState();
}

class _ChildHasilBalanceScreenState extends State<ChildHasilBalanceScreen> {
  late double balance;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    balance = widget.totalIntake - widget.totalOutput;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047AB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(),
                    const SizedBox(height: 16),
                    _buildPatientInfoSection(),
                    const SizedBox(height: 16),
                    _buildResultSection(),
                    const Spacer(),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '[Nama Pengguna]',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'KalBaCa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/logo.png',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.water_drop,
                          color: Colors.white,
                          size: 24,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kalkulator Balance Cairan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF0047AB),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.child_care, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Hitung Kebutuhan Cairan Anak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Hasil Balance Cairan Anak',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pasien: ${widget.patientName}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Berat: ${widget.weightKg} kg | Usia: ${widget.age} tahun',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      children: [
        _buildResultCard(
          'Target Kebutuhan Cairan',
          widget.targetKebutuhanCairan.toStringAsFixed(0),
        ),
        const SizedBox(height: 8),
        _buildResultCard('Total Intake', widget.totalIntake.toStringAsFixed(0)),
        const SizedBox(height: 8),
        _buildResultCard('Total Output', widget.totalOutput.toStringAsFixed(0)),
        const SizedBox(height: 8),
        _buildResultCard(
          'Balance (+/-)',
          '${balance >= 0 ? '+' : ''}${balance.toStringAsFixed(0)}',
          isBalance: true,
        ),
      ],
    );
  }

  Widget _buildResultCard(String label, String value, {bool isBalance = false}) {
    Color cardColor = Colors.white;
    Color textColor = Colors.black;
    
    if (isBalance) {
      if (balance > 0) {
        cardColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
      } else if (balance < 0) {
        cardColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
      }
    }

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: isBalance ? Border.all(color: textColor.withOpacity(0.3)) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBalance ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'mL',
                style: TextStyle(
                  fontSize: 14, 
                  color: isBalance ? textColor : const Color(0xFF0047AB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            // Implementasi fungsi simpan/hapus
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur simpan/hapus akan segera tersedia'),
                backgroundColor: Colors.orange,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0047AB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Simpan / Hapus'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChildFluidBalanceSimulationScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0047AB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Simulasi'),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: AppDimensions.homeNavBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderGray, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home),
          _buildNavItem(1, Icons.calculate),
          _buildNavItem(2, Icons.person),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Icon(
          icon,
          color: isSelected ? AppColors.activeBlack : AppColors.inactiveGray,
          size: 28,
        ),
      ),
    );
  }
}