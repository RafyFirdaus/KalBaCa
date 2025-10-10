import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

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

  // Calculate burn fluid requirements using Parkland formula
  Map<String, dynamic> _calculateBurnFluid() {
    final double weightKg = double.parse(widget.weight);
    final double burnPercent = double.parse(widget.burnPercentage);
    final int age = int.parse(widget.age);

    // Determine multiplier based on age
    final double multiplier = age > 18 ? 4.0 : 3.0;
    final String ageCategory = age > 18
        ? 'Dewasa (>18 tahun)'
        : 'Anak (≤18 tahun)';

    // Calculate total fluid for 24 hours (Parkland formula)
    final double totalFluid24h = multiplier * weightKg * burnPercent;
    final double totalFluid24hLiters = totalFluid24h / 1000;

    // First 8 hours (50% of total)
    final double first8Hours = totalFluid24h * 0.5;
    final double first8HoursLiters = first8Hours / 1000;
    final double hourlyRateFirst8 = first8Hours / 8;

    // Next 16 hours (remaining 50%)
    final double next16Hours = totalFluid24h * 0.5;
    final double next16HoursLiters = next16Hours / 1000;
    final double hourlyRateNext16 = next16Hours / 16;

    return {
      'totalFluid24h': totalFluid24h,
      'totalFluid24hLiters': totalFluid24hLiters,
      'first8Hours': first8Hours,
      'first8HoursLiters': first8HoursLiters,
      'hourlyRateFirst8': hourlyRateFirst8,
      'next16Hours': next16Hours,
      'next16HoursLiters': next16HoursLiters,
      'hourlyRateNext16': hourlyRateNext16,
      'multiplier': multiplier,
      'ageCategory': ageCategory,
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

        // Total Fluid Requirement (24 hours)
        _buildResultField(
          label: 'Total Kebutuhan Cairan (24 jam):',
          value: '${burnFluidData['totalFluid24hLiters'].toStringAsFixed(2)} L',
          subValue: '(${burnFluidData['totalFluid24h'].toStringAsFixed(0)} mL)',
          isHighlighted: true,
        ),

        const SizedBox(height: 16),

        // First 8 hours
        _buildResultField(
          label: '8 Jam Pertama (50%):',
          value: '${burnFluidData['first8HoursLiters'].toStringAsFixed(2)} L',
          subValue:
              '(${burnFluidData['hourlyRateFirst8'].toStringAsFixed(0)} mL/jam)',
        ),

        const SizedBox(height: 16),

        // Next 16 hours
        _buildResultField(
          label: '16 Jam Berikutnya (50%):',
          value: '${burnFluidData['next16HoursLiters'].toStringAsFixed(2)} L',
          subValue:
              '(${burnFluidData['hourlyRateNext16'].toStringAsFixed(0)} mL/jam)',
        ),

        const SizedBox(height: 24),

        // Information about Parkland Formula
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Rumus Parkland:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Kategori: ${burnFluidData['ageCategory']}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                '• Rumus: ${burnFluidData['multiplier'].toStringAsFixed(0)} mL × ${widget.weight} kg × ${widget.burnPercentage}%',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Text(
                '• 50% diberikan dalam 8 jam pertama',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Text(
                '• 50% sisanya diberikan dalam 16 jam berikutnya',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Text(
                '• Cairan: Ringer Laktat (kristaloid)',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(
        right: AppDimensions.homePaddingHorizontal,
        bottom: 16,
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to intake/output screen for burn patients
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur monitoring intake/output akan segera tersedia',
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
