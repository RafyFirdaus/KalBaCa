import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:kalbaca/features/home/presentation/screens/child/fluid_intake_output_screen.dart';

class ChildFluidResultScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;

  const ChildFluidResultScreen({
    super.key,
    required this.patientName,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
  });

  @override
  State<ChildFluidResultScreen> createState() => _ChildFluidResultScreenState();
}

class _ChildFluidResultScreenState extends State<ChildFluidResultScreen> {
  int _selectedIndex = 0;
  late double _fluidRequirement;
  late double _normalIWL;
  late double _totalFluidRequirement;
  final NumberFormat _formatter = NumberFormat("#,##0", "id_ID");

  @override
  void initState() {
    super.initState();
    _calculateFluidRequirements();
  }

  // Fungsi untuk menghitung kebutuhan cairan anak menggunakan rumus Holliday-Segar
  double _calculateFluidRequirement(double weightKg) {
    if (weightKg < 10) {
      return weightKg * 100;
    } else if (weightKg <= 20) {
      return 1000 + (weightKg - 10) * 50;
    } else {
      return 1500 + (weightKg - 20) * 20;
    }
  }

  // Fungsi untuk menghitung IWL anak
  double _calculateChildIWL(int ageYears, double weightKg) {
    return (30 - ageYears) * weightKg;
  }

  // Fungsi untuk menghitung total kebutuhan cairan
  void _calculateFluidRequirements() {
    _fluidRequirement = _calculateFluidRequirement(widget.weightKg);
    _normalIWL = _calculateChildIWL(widget.age, widget.weightKg);
    _totalFluidRequirement = _fluidRequirement + _normalIWL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047AB), // Primary Blue as specified
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),

            // Result Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.homePaddingHorizontal,
                  vertical: AppDimensions.homeMarginSection,
                ),
                child: _buildResultSection(),
              ),
            ),

            // Next Button
            _buildNextButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header Section with Logo and Title
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.homePaddingHorizontal,
        right: AppDimensions.homePaddingHorizontal,
        top: AppDimensions.homePaddingTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User and Logo Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF0047AB),
                    size: 24,
                  ),
                ),
              ),

              // App Logo
              Image.asset('assets/logo.png', width: 100, height: 100),
            ],
          ),

          const SizedBox(height: 16),

          // App Title
          Text('KalBaCa', style: AppTextStyles.homeTitle),
          const SizedBox(height: 4),
          Text('Kalkulator Balance Cairan', style: AppTextStyles.homeSubtitle),

          const SizedBox(height: 24),

          // Page Title with Home Icon
          Row(
            children: [
              // Home Icon
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.home, color: Color(0xFF0047AB), size: 20),
                ),
              ),

              const SizedBox(width: 12),

              // Page Title
              Text(
                'Hitung Kebutuhan Cairan Anak',
                style: AppTextStyles.menuText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Result Section
  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Result Title
        Text(
          'Hasil Perhitungan',
          style: AppTextStyles.menuText.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        // Patient Info
        Container(
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
                'Berat: ${widget.weightKg} kg | Tinggi: ${widget.heightCm} cm | Usia: ${widget.age} tahun',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Jenis Kelamin: ${widget.gender}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Fluid Requirement Field
        _buildResultField(
          label: 'Kebutuhan Cairan:',
          value: _formatter.format(_fluidRequirement),
          unit: 'mL',
        ),

        const SizedBox(height: 16),

        // Normal IWL Field
        _buildResultField(
          label: 'IWL Normal:',
          value: _formatter.format(_normalIWL),
          unit: 'mL',
        ),

        const SizedBox(height: 16),

        // Total Fluid Requirement Field
        _buildResultField(
          label: 'Total Kebutuhan Cairan:',
          value: _formatter.format(_totalFluidRequirement),
          unit: 'mL',
          isHighlighted: true,
        ),
      ],
    );
  }

  // Result Field Builder
  Widget _buildResultField({
    required String label,
    required String value,
    required String unit,
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Result Field
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: isHighlighted
                  ? Border.all(color: Colors.yellow, width: 2)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: isHighlighted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Next Button
  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppDimensions.homePaddingHorizontal,
        bottom: 16,
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FluidIntakeOutputScreen(
                  patientName: widget.patientName,
                  weightKg: widget.weightKg,
                  normalIWL: _normalIWL,
                  age: widget.age,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0047AB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Text(
            'Lanjut',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          label: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  // Bottom Navigation Bar
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

  // Navigation Item
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
