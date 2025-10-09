import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';

// Data model untuk bagian tubuh dan persentase cairan anak
class ChildBodyPart {
  final String name;
  final List<ChildFluidDistribution> distributions;
  final Rect clickableArea;

  ChildBodyPart({
    required this.name,
    required this.distributions,
    required this.clickableArea,
  });
}

// Data model untuk distribusi cairan pada anak
class ChildFluidDistribution {
  final String area;
  final double percentage;

  ChildFluidDistribution({required this.area, required this.percentage});
}

class ChildFluidBalanceSimulationScreen extends StatefulWidget {
  const ChildFluidBalanceSimulationScreen({Key? key}) : super(key: key);

  @override
  State<ChildFluidBalanceSimulationScreen> createState() =>
      _ChildFluidBalanceSimulationScreenState();
}

class _ChildFluidBalanceSimulationScreenState
    extends State<ChildFluidBalanceSimulationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  ChildBodyPart? _selectedBodyPart;
  bool _showTooltip = false;
  late AnimationController _tooltipAnimationController;
  late Animation<double> _tooltipAnimation;

  // Data bagian tubuh anak dengan koordinat dan persentase cairan
  late List<ChildBodyPart> _childBodyParts;

  @override
  void initState() {
    super.initState();
    _initializeChildBodyParts();
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

  void _initializeChildBodyParts() {
    _childBodyParts = [
      // Kepala dan Leher - persentase untuk anak lebih besar
      ChildBodyPart(
        name: 'Kepala dan Leher',
        distributions: [
          ChildFluidDistribution(
            area: 'Kepala dan leher depan',
            percentage: 9.0,
          ),
          ChildFluidDistribution(
            area: 'Kepala dan leher belakang',
            percentage: 9.0,
          ),
        ],
        clickableArea: const Rect.fromLTWH(
          0.35,
          0.07,
          0.3,
          0.15,
        ), // Area kepala lebih besar untuk anak
      ),
      // Torso - disesuaikan untuk proporsi anak
      ChildBodyPart(
        name: 'Torso',
        distributions: [
          ChildFluidDistribution(
            area: 'Dada (toraks anterior)',
            percentage: 6.5,
          ),
          ChildFluidDistribution(
            area: 'Abdomen (perut anterior)',
            percentage: 6.5,
          ),
          ChildFluidDistribution(
            area: 'Punggung atas (toraks posterior)',
            percentage: 6.5,
          ),
          ChildFluidDistribution(
            area: 'Punggung bawah (lumbal posterior)',
            percentage: 6.5,
          ),
        ],
        clickableArea: const Rect.fromLTWH(
          0.3,
          0.25,
          0.4,
          0.25,
        ), // Torso anak proporsi berbeda
      ),
      // Lengan Kiri - persentase lebih kecil untuk anak
      ChildBodyPart(
        name: 'Lengan Kiri',
        distributions: [
          ChildFluidDistribution(area: 'Lengan kiri depan', percentage: 2.25),
          ChildFluidDistribution(
            area: 'Lengan kiri belakang',
            percentage: 2.25,
          ),
        ],
        clickableArea: const Rect.fromLTWH(
          0.05,
          0.25,
          0.25,
          0.35,
        ), // Lengan kiri anak
      ),
      // Lengan Kanan - persentase lebih kecil untuk anak
      ChildBodyPart(
        name: 'Lengan Kanan',
        distributions: [
          ChildFluidDistribution(area: 'Lengan kanan depan', percentage: 2.25),
          ChildFluidDistribution(
            area: 'Lengan kanan belakang',
            percentage: 2.25,
          ),
        ],
        clickableArea: const Rect.fromLTWH(
          0.7,
          0.25,
          0.25,
          0.35,
        ), // Lengan kanan anak
      ),
      // Kaki Kiri - persentase disesuaikan untuk anak
      ChildBodyPart(
        name: 'Kaki Kiri',
        distributions: [
          ChildFluidDistribution(area: 'Kaki kiri depan', percentage: 6.75),
          ChildFluidDistribution(area: 'Kaki kiri belakang', percentage: 6.75),
        ],
        clickableArea: const Rect.fromLTWH(
          0.25,
          0.48,
          0.2,
          0.5,
        ), // Kaki kiri anak
      ),
      // Kaki Kanan - persentase disesuaikan untuk anak
      ChildBodyPart(
        name: 'Kaki Kanan',
        distributions: [
          ChildFluidDistribution(area: 'Kaki kanan depan', percentage: 6.75),
          ChildFluidDistribution(area: 'Kaki kanan belakang', percentage: 6.75),
        ],
        clickableArea: const Rect.fromLTWH(
          0.55,
          0.48,
          0.2,
          0.5,
        ), // Kaki kanan anak
      ),
    ];
  }

  void _onBodyPartTapped(ChildBodyPart bodyPart) {
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
              Expanded(
                child: Text(
                  'Diagram Kebutuhan Cairan Anak',
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInteractiveDiagram() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diagramWidth = constraints.maxWidth.clamp(0.0, 400.0);
        final diagramHeight = constraints.maxHeight.clamp(0.0, double.infinity);

        return Container(
          width: diagramWidth,
          height: diagramHeight,
          child: Stack(
            children: [
              // Background image - menggunakan diagram anak
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/diagram anak.png',
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
                          Icon(Icons.child_care, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Diagram Anak',
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
    return _childBodyParts.map((bodyPart) {
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
          child: Container(color: Colors.transparent),
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
    final centerX = screenSize.width / 2.40;
    final centerY = screenSize.height / 3.5;

    return Positioned(
      left: centerX - 100,
      top: centerY - 120,
      child: Transform.scale(
        scale: _tooltipAnimation.value,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, Color(0xFF1565C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              const SizedBox(width: 20),
              GestureDetector(
                onTap: _hideTooltip,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistributionTooltip(
    ChildFluidDistribution distribution,
    int index,
    int totalCount,
    Size screenSize,
  ) {
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 3.3;
    final tooltipWidth = 120.0;
    final tooltipHeight = 70.0;
    final spacing = 40.0;

    double left, top;

    // Enhanced positioning logic
    final leftBoundary = 10.0;
    final rightBoundary = 80.0;
    final topBoundary = 60.0;
    final bottomBoundary = 100.0;

    if (totalCount == 1) {
      left = centerX - (tooltipWidth / 2);
      top = centerY + 40;
    } else if (totalCount == 2) {
      // Two tooltips: left and right
      switch (index) {
        case 0: // Left
          left = centerX - tooltipWidth - spacing * 2;
          top = centerY - (tooltipHeight / 3);
          break;
        case 1: // Right
          left = centerX + spacing / 2;
          top = centerY - (tooltipHeight / 3);
          break;
        default:
          left = centerX - (tooltipWidth / 2);
          top = centerY + 40;
      }
    } else if (totalCount <= 4) {
      // Four tooltips: arranged around center but avoiding header area
      switch (index) {
        case 0: // Left
          left = centerX - tooltipWidth + spacing - 100;
          top = centerY - (tooltipHeight / 1);
          break;
        case 1: // Right
          left = centerX + spacing + 20;
          top = centerY - (tooltipHeight / 1);
          break;
        case 2: // Bottom-left
          left = centerX - tooltipWidth + spacing - 100;
          top = centerY + (tooltipHeight / 5);
          break;
        case 3: // Bottom-right
          left = centerX + spacing + 20;
          top = centerY + (tooltipHeight / 6);
          break;
        default:
          left = centerX - (tooltipWidth / 2);
          top = centerY + 40;
      }
    } else {
      // More than 4: arrange in a circle around center, avoiding header area
      final angle = (2 * 3.14159 * index) / totalCount;
      final radius = 120.0;
      left = centerX + (radius * cos(angle)) - (tooltipWidth / 2);
      top = centerY + (radius * sin(angle)) - (tooltipHeight / 2);

      if (top < centerY - 40) {
        top = centerY + 40;
      }
    }

    // Boundary checking
    if (left < leftBoundary) left = leftBoundary;
    if (left + tooltipWidth > screenSize.width - rightBoundary) {
      left = screenSize.width - tooltipWidth - rightBoundary;
    }
    if (top < topBoundary) top = topBoundary;
    if (top + tooltipHeight > screenSize.height - bottomBoundary) {
      top = screenSize.height - tooltipHeight - bottomBoundary;
    }

    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: _tooltipAnimation.value,
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(width: 10),
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
                    horizontal: 6,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${distribution.percentage}%',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primaryBlue : AppColors.textGray,
          size: 24,
        ),
      ),
    );
  }
}
