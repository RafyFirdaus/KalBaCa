import 'package:flutter/material.dart';
import 'dart:math' as dart_math;
import '../../../../../core/constants/constants.dart';
import 'burn_fluid_intake_output_screen.dart';

class BurnFluidResultScreen extends StatefulWidget {
  final String patientName;
  final String weight;
  final String height;
  final String age;
  final String gender;
  final String burnPercentage;
  final bool isEWLMode;

  const BurnFluidResultScreen({
    super.key,
    required this.patientName,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.burnPercentage,
    required this.isEWLMode,
  });

  @override
  State<BurnFluidResultScreen> createState() => _BurnFluidResultScreenState();
}

class _BurnFluidResultScreenState extends State<BurnFluidResultScreen> {
  int _selectedIndex = 0;

  // Calculate burn fluid requirements
  Map<String, dynamic> _calculateBurnFluid() {
    final double weightKg = double.parse(widget.weight);
    final double heightCm = double.parse(widget.height);
    final int age = int.parse(widget.age);

    // Parse burn percentage, handle comma as decimal separator
    final String burnPercentageStr = widget.burnPercentage.replaceAll(',', '.');
    final double burnPercentage = double.parse(burnPercentageStr);

    double totalFluid = 0;
    String phaseTitle = '';
    String formula = '';
    Map<String, dynamic> breakdown = {};

    if (widget.isEWLMode) {
      // CASE 2: Maintenance + EWL Phase (Fase 2)
      phaseTitle = 'Fase Maintenance + EWL (Post 24 Jam)';

      // Step 1: Calculate BSA (Mosteller Formula)
      // BSA = sqrt((Weight_kg * Height_cm) / 3600)
      final double bsa = dart_math.sqrt((weightKg * heightCm) / 3600);

      // Step 2: Calculate EWL (Evaporative Water Loss)
      // EWL_Rate = (25 + BurnPercentage) * BSA (mL/hour)
      final double ewlRate = (25 + burnPercentage) * bsa;
      final double ewlTotal24h = ewlRate * 24;

      // Step 3: Calculate Maintenance Fluid
      double maintenanceTotal = 0;
      if (age >= 18) {
        // Adult Maintenance: Weight * 30 (Based on standard maintenance for adults)
        maintenanceTotal = weightKg * 30;
      } else {
        // Child Maintenance: Holliday-Segar Formula
        if (weightKg <= 10) {
          maintenanceTotal = weightKg * 100;
        } else if (weightKg <= 20) {
          maintenanceTotal = 1000 + (weightKg - 10) * 50;
        } else {
          maintenanceTotal = 1500 + (weightKg - 20) * 20;
        }
      }

      // Step 4: Final Calculation
      totalFluid = maintenanceTotal + ewlTotal24h;

      formula =
          'Total = Maintenance + EWL\n'
          'BSA = √((BB × TB)/3600)\n'
          'EWL = (25 + %LB) × BSA × 24\n'
          'Maintenance = ${age >= 18 ? 'BB × 30' : 'Holliday-Segar'}';

      breakdown = {
        'maintenance': maintenanceTotal,
        'ewl': ewlTotal24h,
        'bsa': bsa,
      };
    } else {
      // CASE 1: Resuscitation Phase (Fase 1) - Default
      phaseTitle = 'Fase Resusitasi (Parkland)';

      // Formula (Parkland):
      // ADULT (>= 18): 4 * Weight * BurnPercentage
      // CHILD (< 18): 3 * Weight * BurnPercentage

      double multiplier;
      String formulaText;

      if (age >= 18) {
        multiplier = 4.0;
        formulaText = 'Parkland (Dewasa): 4 mL × BB × % TBSA';
      } else {
        multiplier = 3.0;
        formulaText = 'Parkland (Anak): 3 mL × BB × % TBSA';
      }

      totalFluid = multiplier * weightKg * burnPercentage;
      formula = formulaText;

      // Breakdown: 50% first 8h, 50% next 16h
      breakdown = {'first8h': totalFluid * 0.5, 'next16h': totalFluid * 0.5};
    }

    return {
      'totalFluid': totalFluid,
      'phaseTitle': phaseTitle,
      'formula': formula,
      'breakdown': breakdown,
      'weightKg': weightKg,
      'age': age,
      'burnPercentage': burnPercentage,
      'isEWLMode': widget.isEWLMode,
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
    final bool isEWLMode = burnFluidData['isEWLMode'];
    final Map<String, dynamic> breakdown = burnFluidData['breakdown'];

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
                'Berat: ${widget.weight} kg | Tinggi: ${widget.height} cm | Usia: ${widget.age} tahun',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Jenis Kelamin: ${widget.gender} | % Luka Bakar: ${widget.burnPercentage}% TBSA',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              if (isEWLMode) ...[
                const SizedBox(height: 4),
              ] else ...[
                const SizedBox(height: 4),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        if (isEWLMode) ...[
          // Maintenance Fluid
          _buildResultField(
            label: 'Kebutuhan Cairan:',
            value: '${(breakdown['maintenance'] as double).round()}',
            subValue: 'mL/24 jam',
          ),
          const SizedBox(height: 16),

          // EWL
          _buildResultField(
            label: 'EWL (Evaporative Water Loss):',
            value: '${(breakdown['ewl'] as double).round()}',
            subValue: 'mL/24 jam',
          ),
          const SizedBox(height: 16),

          // BSA Info (Small)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'BSA: ${(breakdown['bsa'] as double).toStringAsFixed(2)} m²',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ] else ...[
          // First 8 hours
          _buildResultField(
            label: '8 Jam Pertama (50%):',
            value: '${(breakdown['first8h'] as double).round()}',
            subValue: 'mL',
          ),
          const SizedBox(height: 16),

          // Next 16 hours
          _buildResultField(
            label: '16 Jam Berikutnya (50%):',
            value: '${(breakdown['next16h'] as double).round()}',
            subValue: 'mL',
          ),
          const SizedBox(height: 16),
        ],

        // Total Kebutuhan Cairan
        _buildResultField(
          label: 'Total Kebutuhan Cairan (24 Jam):',
          value: '${(burnFluidData['totalFluid'] as double).round()}',
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
                  normalIWL:
                      0.0, // IWL is not applicable/removed as per requirement
                  age: burnFluidData['age'],
                  gender: widget.weight,
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
