import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';

class HasilBalanceScreen extends StatefulWidget {
  final double targetKebutuhanCairan;
  final double totalIntake;
  final double totalOutput;

  const HasilBalanceScreen({
    Key? key,
    required this.targetKebutuhanCairan,
    required this.totalIntake,
    required this.totalOutput,
  }) : super(key: key);

  @override
  State<HasilBalanceScreen> createState() => _HasilBalanceScreenState();
}

class _HasilBalanceScreenState extends State<HasilBalanceScreen> {
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
                    _buildResultSection(),
                    const Spacer(),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '[Nama Pengguna]',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'KalBaCa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Kalkulator Balance Cairan',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              Image.asset('assets/logo.png', width: 100, height: 100),
            ],
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
            Icon(Icons.home, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Hitung Kebutuhan Cairan Dewasa',
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
            'Hasil Balance',
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
        ),
      ],
    );
  }

  Widget _buildResultCard(String label, String value) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'mL',
                style: TextStyle(fontSize: 14, color: Color(0xFF0047AB)),
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
            // Implementasi fungsi simulasi
            Navigator.pop(context);
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
