import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import 'burn_fluid_intake_output_screen.dart';

class BurnFluidResultScreen extends StatefulWidget {
  final String patientName;
  final String weight;
  final String height;
  final String age;
  final String gender;
  final String burnPercentage;

  const BurnFluidResultScreen({
    super.key,
    required this.patientName,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.burnPercentage,
  });

  @override
  State<BurnFluidResultScreen> createState() => _BurnFluidResultScreenState();
}

class _BurnFluidResultScreenState extends State<BurnFluidResultScreen> {
  int _selectedIndex = 0;

  // Calculate burn fluid requirements using separate adult and child formulas
  Map<String, dynamic> _calculateBurnFluid() {
    final double weightKg = double.parse(widget.weight);
    double.parse(widget.height);
    final int age = int.parse(widget.age);

    // Calculate base fluid requirement based on age
    double kebutuhanCairan;
    double iwl;
    String ageCategory;

    if (age > 18) {
      // Adult formula (Watson formula)
      ageCategory = 'Dewasa (>18 tahun)';
      kebutuhanCairan = weightKg * 30; // Watson formula: weight * 30 mL/kg/day
      iwl = 15 * weightKg; // Adult IWL: 15 mL/kg/day
    } else {
      // Child formula (Holliday-Segar formula)
      ageCategory = 'Anak (≤18 tahun)';

      // Holliday-Segar formula for fluid requirement
      if (weightKg < 10) {
        kebutuhanCairan = weightKg * 100;
      } else if (weightKg <= 20) {
        kebutuhanCairan = 1000 + (weightKg - 10) * 50;
      } else {
        kebutuhanCairan = 1500 + (weightKg - 20) * 20;
      }

      // Child IWL formula: (30 - age) * weight
      iwl = (30 - age) * weightKg;
    }

    // Calculate total fluid requirement
    final double totalKebutuhanCairan = kebutuhanCairan + iwl;

    return {
      'kebutuhanCairan': kebutuhanCairan,
      'iwl': iwl,
      'totalKebutuhanCairan': totalKebutuhanCairan,
      'ageCategory': ageCategory,
      'weightKg': weightKg,
      'age': age,
    };
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
                'Hitung Kebutuhan Cairan Luka Bakar',
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
    // Calculate burn fluid using updated method
    final burnFluidData = _calculateBurnFluid();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            color: Colors.white.withValues(alpha: 0.1),
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
                'Berat: ${widget.weight} kg | Tinggi: ${widget.height} cm | Usia: ${widget.age} tahun',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Jenis Kelamin: ${widget.gender} | % Luka Bakar: ${widget.burnPercentage}% TBSA',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Age Category Info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Formula: ${burnFluidData['ageCategory']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Kebutuhan Cairan
        _buildResultField(
          label: 'Kebutuhan Cairan:',
          value: '${burnFluidData['kebutuhanCairan'].round()}',
          subValue: 'mL',
        ),

        const SizedBox(height: 16),

        // IWL (Insensible Water Loss)
        _buildResultField(
          label: 'IWL Normal:',
          value: '${burnFluidData['iwl'].round()}',
          subValue: 'mL',
        ),

        const SizedBox(height: 16),

        // Total Kebutuhan Cairan
        _buildResultField(
          label: 'Total Kebutuhan Cairan:',
          value: '${burnFluidData['totalKebutuhanCairan'].round()}',
          subValue: 'mL',
          isHighlighted: true,
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // Result Field Builder
  Widget _buildResultField({
    required String label,
    required String value,
    String? subValue,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (subValue != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subValue,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Next Button
  Widget _buildNextButton() {
    final burnFluidData = _calculateBurnFluid();

    return Padding(
      padding: const EdgeInsets.only(
        right: AppDimensions.homePaddingHorizontal,
        bottom: 16,
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to intake/output screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BurnFluidIntakeOutputScreen(
                  patientName: widget.patientName,
                  weightKg: burnFluidData['weightKg'],
                  normalIWL: burnFluidData['iwl'],
                  age: burnFluidData['age'],
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
