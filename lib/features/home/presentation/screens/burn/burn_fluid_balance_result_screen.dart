import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';
import '../adult/fluid_balance_simulation_screen.dart';

class BurnFluidBalanceResultScreen extends StatefulWidget {
  final double targetKebutuhanCairan;
  final double totalIntake;
  final double totalOutput;

  const BurnFluidBalanceResultScreen({
    Key? key,
    required this.targetKebutuhanCairan,
    required this.totalIntake,
    required this.totalOutput,
  }) : super(key: key);

  @override
  State<BurnFluidBalanceResultScreen> createState() => _BurnFluidBalanceResultScreenState();
}

class _BurnFluidBalanceResultScreenState extends State<BurnFluidBalanceResultScreen> {
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
              const Text(
                'Hasil Balance Cairan Luka Bakar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return const SizedBox.shrink(); // No longer needed as title is now in header
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

  Widget _buildResultCard(
    String label,
    String value, {
    bool isBalance = false,
  }) {
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
        border: isBalance
            ? Border.all(color: textColor.withOpacity(0.3))
            : null,
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
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FluidBalanceSimulationScreen(),
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