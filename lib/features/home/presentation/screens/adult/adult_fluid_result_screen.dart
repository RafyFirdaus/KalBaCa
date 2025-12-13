import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:kalbaca/features/home/presentation/screens/adult/adult_fluid_intake_output_screen.dart';

class AdultFluidResultScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;
  final double? temperature;

  const AdultFluidResultScreen({
    super.key,
    required this.patientName,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    this.temperature,
  });

  @override
  State<AdultFluidResultScreen> createState() => _AdultFluidResultScreenState();
}

class _AdultFluidResultScreenState extends State<AdultFluidResultScreen> {
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

  // Fungsi untuk menghitung kebutuhan cairan berdasarkan rumus Watson
  void _calculateFluidRequirements() {
    _fluidRequirement = calculateFluidRequirement(
      widget.weightKg,
      widget.heightCm,
      widget.age,
      widget.gender,
    );
    _normalIWL = calculateNormalIWL(_fluidRequirement);
    _totalFluidRequirement = calculateTotalFluidRequirement(
      _fluidRequirement,
      _normalIWL,
    );
  }

  // Fungsi untuk menghitung kebutuhan cairan berdasarkan rumus Watson
  double calculateFluidRequirement(
    double weightKg,
    double heightCm,
    int age,
    String gender,
  ) {
    // Rumus disatukan: berat badan (kg) × 30 mL/kg/hari
    // Param heightCm, age, gender tidak digunakan lagi sesuai revisi
    return weightKg * 30;
  }

  // Fungsi untuk menghitung Adjustment IWL akibat kenaikan suhu
  double calculateNormalIWL(double fluidRequirement) {
    double baseIWL = 15 * widget.weightKg;
    double adjustment = 0;

    // Jika ada kenaikan suhu (demam), hitung adjustment
    if (widget.temperature != null && widget.temperature! > 37) {
      // Adjustment = Base IWL * 10% * (Input Temperature - 37)
      adjustment = baseIWL * 0.1 * (widget.temperature! - 37);

      // Jika demam, tampilkan HANYA adjustment (karena base sudah include di maintenance)
      return adjustment;
    }

    // Jika TIDAK ada kenaikan suhu (Normal), tampilkan Base IWL (Standard Formula)
    // Agar tidak muncul angka 0 yang membingungkan
    return baseIWL;
  }

  // Fungsi untuk menghitung total kebutuhan cairan
  // Total = Maintenance (fluidRequirement) + Adjustment only
  double calculateTotalFluidRequirement(
    double fluidRequirement,
    double normalIWL,
  ) {
    // We need to recalculate the base IWL to separate the adjustment part
    double baseIWL = 15 * widget.weightKg;
    double adjustment = 0;

    if (widget.temperature != null && widget.temperature! > 37) {
      adjustment = baseIWL * 0.1 * (widget.temperature! - 37);
    }

    // Total Kebutuhan Cairan = Maintenance + Adjustment
    // Note: The 'normalIWL' parameter passed here is the Total IWL (Base + Adjustment)
    // calculated in calculateNormalIWL.
    // However, the formula requested is: Maintenance + Adjustment only.
    // Maintenance theoretically covers Base IWL.
    return fluidRequirement + adjustment;
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
                'Hitung Kebutuhan Cairan Dewasa',
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
                'Jenis Kelamin: ${widget.gender}' +
                    (widget.temperature != null
                        ? ' | Suhu: ${widget.temperature}°C'
                        : ''),
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
          label: 'IWL :',
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
                builder: (context) => AdultFluidIntakeOutputScreen(
                  patientName: widget.patientName,
                  weightKg: widget.weightKg,
                  normalIWL: _normalIWL,
                  fluidRequirement: _totalFluidRequirement,
                  age: widget.age,
                  gender: widget.gender,
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
          _buildNavItem(1, Icons.assignment),
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

        // Navigate based on selected index
        switch (index) {
          case 0:
            // Navigate to Home
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 1:
            // Navigate to Data Hasil Balance via Home
            Navigator.popUntil(context, (route) => route.isFirst);
            // The HomeScreen will handle showing DataHasilBalanceScreen when index is 1
            break;
          case 2:
            // Navigate to Profile via Home
            Navigator.popUntil(context, (route) => route.isFirst);
            // The HomeScreen will handle showing ProfileScreen when index is 2
            break;
        }
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
