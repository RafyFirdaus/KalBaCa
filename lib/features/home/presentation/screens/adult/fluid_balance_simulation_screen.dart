import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';

// Data model untuk bagian tubuh dan persentase cairan
class BodyPart {
  final String name;
  final List<FluidDistribution> distributions;
  final Rect clickableArea;

  BodyPart({
    required this.name,
    required this.distributions,
    required this.clickableArea,
  });
}

class FluidDistribution {
  final String area;
  final double percentage;

  FluidDistribution({required this.area, required this.percentage});
}

class FluidBalanceSimulationScreen extends StatefulWidget {
  const FluidBalanceSimulationScreen({Key? key}) : super(key: key);

  @override
  State<FluidBalanceSimulationScreen> createState() =>
      _FluidBalanceSimulationScreenState();
}

class _FluidBalanceSimulationScreenState
    extends State<FluidBalanceSimulationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  BodyPart? _selectedBodyPart;
  bool _showTooltip = false;
  late AnimationController _tooltipAnimationController;
  late Animation<double> _tooltipAnimation;

  // Data bagian tubuh dengan koordinat dan persentase cairan
  late List<BodyPart> _bodyParts;

  @override
  void initState() {
    super.initState();
    _initializeBodyParts();
    _tooltipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tooltipAnimation = CurvedAnimation(
      parent: _tooltipAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tooltipAnimationController.dispose();
    super.dispose();
  }

  void _initializeBodyParts() {
    _bodyParts = [
      // Kepala dan Leher - area lebih kecil dan presisi
      BodyPart(
        name: 'Kepala dan Leher',
        distributions: [
          FluidDistribution(area: 'Kepala dan leher depan', percentage: 4.5),
          FluidDistribution(area: 'Kepala dan leher belakang', percentage: 4.5),
        ],
        clickableArea: const Rect.fromLTWH(
          0.4,
          0.08,
          0.2,
          0.10,
        ), // Lebih kecil dan presisi
      ),
      // Torso - area lebih kecil, tidak overlap dengan kepala dan lengan
      BodyPart(
        name: 'Torso',
        distributions: [
          FluidDistribution(area: 'Dada (toraks anterior)', percentage: 9.0),
          FluidDistribution(area: 'Abdomen (perut anterior)', percentage: 9.0),
          FluidDistribution(
            area: 'Punggung atas (toraks posterior)',
            percentage: 9.0,
          ),
          FluidDistribution(
            area: 'Punggung bawah (lumbal posterior)',
            percentage: 9.0,
          ),
        ],
        clickableArea: const Rect.fromLTWH(
          0.35,
          0.20,
          0.3,
          0.20,
        ), // Lebih kecil dan tidak overlap
      ),
      // Lengan Kiri (dari POV user) - perbaiki orientasi
      BodyPart(
        name: 'Lengan Kiri',
        distributions: [
          FluidDistribution(area: 'Lengan kiri depan', percentage: 4.5),
          FluidDistribution(area: 'Lengan kiri belakang', percentage: 4.5),
        ],
        clickableArea: const Rect.fromLTWH(
          0.1,
          0.32,
          0.30,
          0.28,
        ), // Kiri dari POV user
      ),
      // Lengan Kanan (dari POV user) - perbaiki orientasi
      BodyPart(
        name: 'Lengan Kanan',
        distributions: [
          FluidDistribution(area: 'Lengan kanan depan', percentage: 4.5),
          FluidDistribution(area: 'Lengan kanan belakang', percentage: 4.5),
        ],
        clickableArea: const Rect.fromLTWH(
          0.60,
          0.32,
          0.15,
          0.28,
        ), // Kanan dari POV user
      ),
      // Kaki Kiri (dari POV user) - perbaiki orientasi
      BodyPart(
        name: 'Kaki Kiri',
        distributions: [
          FluidDistribution(area: 'Kaki kiri depan', percentage: 9.0),
          FluidDistribution(area: 'Kaki kiri belakang', percentage: 9.0),
        ],
        clickableArea: const Rect.fromLTWH(
          0.3,
          0.58,
          0.15,
          0.45,
        ), // Kiri dari POV user
      ),
      // Kaki Kanan (dari POV user) - perbaiki orientasi
      BodyPart(
        name: 'Kaki Kanan',
        distributions: [
          FluidDistribution(area: 'Kaki kanan depan', percentage: 9.0),
          FluidDistribution(area: 'Kaki kanan belakang', percentage: 9.0),
        ],
        clickableArea: const Rect.fromLTWH(
          0.55,
          0.58,
          0.15,
          0.45,
        ), // Kanan dari POV user
      ),
      // Perineum - area lebih presisi
      BodyPart(
        name: 'Perineum',
        distributions: [
          FluidDistribution(area: 'Perineum / genitalia', percentage: 1.0),
        ],
        clickableArea: const Rect.fromLTWH(
          0.42,
          0.49,
          0.16,
          0.10,
        ), // Lebih presisi
      ),
    ];
  }

  void _onBodyPartTapped(BodyPart bodyPart) {
    setState(() {
      _selectedBodyPart = bodyPart;
      _showTooltip = true;
    });
    _tooltipAnimationController.forward();
  }

  void _hideTooltip() {
    _tooltipAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showTooltip = false;
          _selectedBodyPart = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: GestureDetector(
        onTap: () {
          if (_showTooltip) {
            _hideTooltip();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildHeaderSection(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Expanded(child: _buildMainDiagramSection()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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
              Image.asset('assets/logo.png', width: 80, height: 80),
            ],
          ),

          const SizedBox(height: 1),

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

              const SizedBox(width: 10),

              // Page Title
              Expanded(
                child: Text(
                  'Diagram Kebutuhan Cairan Dewasa',
                  style: AppTextStyles.pageTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainDiagramSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: _buildInteractiveDiagram()),
          const SizedBox(height: 20), // Ruang kosong di bawah diagram dikurangi
        ],
      ),
    );
  }

  Widget _buildInteractiveDiagram() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Menggunakan ruang yang tersedia dengan optimal
        final diagramWidth = constraints.maxWidth.clamp(0.0, 400.0);
        // Menggunakan tinggi yang tersedia, dengan rasio yang sesuai
        final diagramHeight = constraints.maxHeight.clamp(0.0, double.infinity);

        return Container(
          width: diagramWidth,
          height: diagramHeight,
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/diagram tubuh manusia.png',
                  width: diagramWidth,
                  height: diagramHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: diagramWidth,
                      height: diagramHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Diagram Tubuh Manusia',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Clickable areas
              ..._buildClickableAreas(diagramWidth, diagramHeight),
              // Tooltip
              if (_showTooltip && _selectedBodyPart != null) _buildTooltip(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildClickableAreas(double diagramWidth, double diagramHeight) {
    return _bodyParts.map((bodyPart) {
      final area = bodyPart.clickableArea;
      return Positioned(
        left: area.left * diagramWidth,
        top: area.top * diagramHeight,
        width: area.width * diagramWidth,
        height: area.height * diagramHeight,
        child: GestureDetector(
          onTap: () {
            _onBodyPartTapped(bodyPart);
          },
          child: Container(
            color: Colors.transparent, // Invisible clickable area
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTooltip() {
    return AnimatedBuilder(
      animation: _tooltipAnimation,
      builder: (context, child) {
        return Stack(children: _buildSeparateTooltips());
      },
    );
  }

  List<Widget> _buildSeparateTooltips() {
    final distributions = _selectedBodyPart!.distributions;
    final screenSize = MediaQuery.of(context).size;
    List<Widget> tooltips = [];

    // Add header tooltip with body part name and close button
    tooltips.add(_buildHeaderTooltip(screenSize));

    // Add separate tooltips for each distribution
    for (int i = 0; i < distributions.length; i++) {
      tooltips.add(
        _buildDistributionTooltip(
          distributions[i],
          i,
          distributions.length,
          screenSize,
        ),
      );
    }

    return tooltips;
  }

  Widget _buildHeaderTooltip(Size screenSize) {
    const tooltipWidth = 140.0;
    const tooltipHeight = 85.0;

    // Perfect center positioning - horizontally and vertically centered
    double left =
        (screenSize.width - tooltipWidth) / 2 -
        30; // Sedikit ke kiri untuk lebih centered
    double top = (screenSize.height - tooltipHeight) / 2 - 500; // Lebih ke atas

    // Ensure tooltip stays within screen bounds
    if (left < 10) left = 20;
    if (left + tooltipWidth > screenSize.width - 20) {
      left = screenSize.width - tooltipWidth - 20;
    }
    if (top < 80) top = 80; // Leave space for status bar
    if (top + tooltipHeight > screenSize.height - 200) {
      top =
          screenSize.height - tooltipHeight - 100; // Leave space for bottom nav
    }

    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: _tooltipAnimation.value,
        child: Opacity(
          opacity: _tooltipAnimation.value,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: tooltipWidth,
              height: tooltipHeight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _selectedBodyPart!.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: _hideTooltip,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistributionTooltip(
    FluidDistribution distribution,
    int index,
    int totalCount,
    Size screenSize,
  ) {
    const tooltipWidth = 120.0;
    const tooltipHeight = 100.0;
    const spacing = 10.0;

    // Parameter untuk mengatur batas posisi tooltip - EDIT NILAI INI UNTUK MENGATUR POSISI
    const leftBoundary =
        5.0; // Bisa diubah untuk mengatur seberapa jauh ke kiri tooltip bisa bergerak (negatif = keluar layar)
    const rightBoundary = 80.0; // Batas kanan dari tepi layar
    const topBoundary = 170.0; // Batas atas (untuk menghindari header)
    const bottomBoundary = 10.0; // Batas bawah dari tepi layar

    // Improved positioning to avoid header overlap
    double left, top;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2; // Move down to avoid header overlap

    if (totalCount == 1) {
      // Single tooltip: center below header with more space
      left = centerX - (tooltipWidth / 1.3);
      top = centerY - (tooltipHeight / 0.4);
    } else if (totalCount == 2) {
      // Two tooltips: left and right of center, positioned lower
      if (index == 0) {
        left = centerX - tooltipWidth + spacing - 100;
        top = centerY - (tooltipHeight / 0.4);
      } else {
        left = centerX + tooltipWidth + spacing - 100;
        top = centerY - (tooltipHeight / 0.4);
      }
    } else if (totalCount == 4) {
      // Four tooltips: arranged around center but avoiding header area
      switch (index) {
        case 0: // Left
          left = centerX - tooltipWidth + spacing - 100;
          top = centerY - (tooltipHeight / 0.4);
          break;
        case 1: // Right
          left = centerX + spacing + 20;
          top = centerY - (tooltipHeight / 0.4);
          break;
        case 2: // Bottom-left
          left = centerX - tooltipWidth + spacing - 100;
          top = centerY - spacing - tooltipHeight / 1.1;
          break;
        case 3: // Bottom-right
          left = centerX + spacing + 20;
          top = centerY - spacing - tooltipHeight / 1.1;
          break;
        default:
          left = centerX - (tooltipWidth / 2);
          top = centerY + 40;
      }
    } else {
      // More than 4: arrange in a circle around center, avoiding header area
      final angle = (2 * 3.14159 * index) / totalCount;
      final radius = 120.0; // Increased radius for better spacing
      left = centerX + (radius * cos(angle)) - (tooltipWidth / 2);
      top = centerY + (radius * sin(angle)) - (tooltipHeight / 2);

      // Ensure distribution tooltips don't overlap with header area
      if (top < centerY - 40) {
        top = centerY + 40; // Push down if too high
      }
    }

    // Enhanced boundary checking dengan parameter yang bisa disesuaikan
    if (left < leftBoundary) {
      left = leftBoundary; // Sekarang bisa negatif untuk keluar dari layar
    }
    if (left + tooltipWidth > screenSize.width - rightBoundary) {
      left = screenSize.width - tooltipWidth - rightBoundary;
    }
    if (top < topBoundary) {
      top = topBoundary; // Menggunakan parameter topBoundary
    }
    if (top + tooltipHeight > screenSize.height - bottomBoundary) {
      top =
          screenSize.height -
          tooltipHeight -
          bottomBoundary; // Menggunakan parameter bottomBoundary
    }

    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: _tooltipAnimation.value,
        child: Opacity(
          opacity: _tooltipAnimation.value,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: tooltipWidth,
              height: tooltipHeight,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 3),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          distribution.area,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${distribution.percentage}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.calculate, 1),
          _buildNavItem(Icons.person, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Handle navigation based on index
        switch (index) {
          case 0:
            // Navigate to home
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 1:
            // Navigate to calculation
            Navigator.pop(context);
            break;
          case 2:
            // Navigate to profile
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryBlue
                  : AppColors.inactiveGray,
              size: 24,
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 20,
              color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
