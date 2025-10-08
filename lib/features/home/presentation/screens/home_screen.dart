import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:kalbaca/features/home/presentation/screens/adult_fluid_calculation_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/child_fluid_calculation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            _buildHeaderSection(),

            // Title Section
            _buildTitleSection(),

            // Menu Section
            _buildMenuSection(),

            // Button Section
            Expanded(child: _buildButtonSection()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header Section with Welcome Text and Logo
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.homePaddingHorizontal,
        right: AppDimensions.homePaddingHorizontal,
        top: AppDimensions.homePaddingTop,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Information
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELAMAT DATANG',
                style: AppTextStyles.welcomeText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('[Nama Pengguna]', style: AppTextStyles.usernameText),
            ],
          ),

          // App Logo
          Image.asset('assets/logo.png', width: 120, height: 120),
        ],
      ),
    );
  }

  // Title Section with App Name and Subtitle
  Widget _buildTitleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: AppDimensions.homePaddingHorizontal,
        right: AppDimensions.homePaddingHorizontal,
        top: AppDimensions.homeMarginTop,
        bottom: AppDimensions.homeMarginSection,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('KalBaCa', style: AppTextStyles.homeTitle),
          const SizedBox(height: 4),
          Text('Kalkulator Balance Cairan', style: AppTextStyles.homeSubtitle),
        ],
      ),
    );
  }

  // Menu Section with Icon and Text
  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.homePaddingHorizontal,
        right: AppDimensions.homePaddingHorizontal,
        bottom: AppDimensions.homeMarginSection,
      ),
      child: Row(
        children: [
          // Menu Icon
          Container(
            width: AppDimensions.homeIconSize,
            height: AppDimensions.homeIconSize,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.home, color: AppColors.primaryBlue, size: 24),
            ),
          ),

          const SizedBox(width: AppDimensions.homeMenuSpacing),

          // Menu Text
          Text('Menu Utama', style: AppTextStyles.menuText),
        ],
      ),
    );
  }

  // Button Section with 3 Custom Buttons
  Widget _buildButtonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.homePaddingHorizontal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildActionButton('Hitung Kebutuhan Cairan Dewasa', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdultFluidCalculationScreen(),
              ),
            );
          }),
          const SizedBox(height: AppDimensions.buttonSpacing * 4),
          _buildActionButton('Hitung Kebutuhan Cairan Anak', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChildFluidCalculationScreen(),
              ),
            );
          }),
          const SizedBox(height: AppDimensions.buttonSpacing * 4),
          _buildActionButton('Hitung Kebutuhan Cairan Luka Bakar', () {
            // TODO: Navigate to burn calculation screen
          }),
        ],
      ),
    );
  }

  // Custom Action Button
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      height: AppDimensions.homeButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryBlue,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.homeButtonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.homeButtonPadding,
          ),
        ),
        child: Row(
          children: [
            // Blue Indicator
            Container(
              width: AppDimensions.homeIndicatorSize,
              height: AppDimensions.homeIndicatorSize,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            // Button Text
            Text(
              text,
              style: AppTextStyles.buttonLabelText,
              textAlign: TextAlign.start,
            ),
          ],
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
