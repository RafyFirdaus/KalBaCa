import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';

// Model untuk Sub-Bagian Tubuh (lebih granular)
class ChildSubPart {
  final String name;
  final double percentage;

  ChildSubPart({required this.name, required this.percentage});
}

// Data model untuk bagian tubuh anak dan persentase cairan
class ChildBodyPart {
  final String name;
  final List<ChildSubPart> subParts;
  final Rect clickableArea;

  ChildBodyPart({
    required this.name,
    required this.subParts,
    required this.clickableArea,
  });

  // Helper untuk mendapatkan total percentage dari subParts
  double get totalPercentage =>
      subParts.fold(0, (sum, item) => sum + item.percentage);
}

class ChildFluidBalanceSimulationScreen extends StatefulWidget {
  final Function(double)? onPercentageSelected;

  const ChildFluidBalanceSimulationScreen({Key? key, this.onPercentageSelected})
    : super(key: key);

  @override
  State<ChildFluidBalanceSimulationScreen> createState() =>
      _ChildFluidBalanceSimulationScreenState();
}

class _ChildFluidBalanceSimulationScreenState
    extends State<ChildFluidBalanceSimulationScreen> {
  int _selectedIndex = 0;
  // Menyimpan nama ChildSubPart yang dipilih
  final Set<String> _selectedSubParts = {};
  double _totalTBSA = 0.0;

  // Data bagian tubuh anak dengan koordinat dan persentase cairan
  late List<ChildBodyPart> _childBodyParts;

  @override
  void initState() {
    super.initState();
    _initializeChildBodyParts();
  }

  void _initializeChildBodyParts() {
    _childBodyParts = [
      // Kepala dan Leher
      ChildBodyPart(
        name: 'Kepala dan Leher',
        subParts: [
          ChildSubPart(name: 'Kepala dan leher depan', percentage: 9.0),
          ChildSubPart(name: 'Kepala dan leher belakang', percentage: 9.0),
        ],
        clickableArea: const Rect.fromLTWH(0.4, 0.07, 0.20, 0.15),
      ),
      // Torso
      ChildBodyPart(
        name: 'Torso',
        subParts: [
          ChildSubPart(name: 'Dada (toraks anterior)', percentage: 9.0),
          ChildSubPart(name: 'Abdomen (perut anterior)', percentage: 9.0),
          ChildSubPart(
            name: 'Punggung atas (toraks posterior)',
            percentage: 9.0,
          ),
          ChildSubPart(
            name: 'Punggung bawah (lumbal posterior)',
            percentage: 9.0,
          ),
        ],
        clickableArea: const Rect.fromLTWH(0.4, 0.25, 0.20, 0.28),
      ),
      // Lengan Kiri
      ChildBodyPart(
        name: 'Lengan Kiri',
        subParts: [
          ChildSubPart(name: 'Lengan kiri depan', percentage: 4.5),
          ChildSubPart(name: 'Lengan kiri belakang', percentage: 4.5),
        ],
        clickableArea: const Rect.fromLTWH(0.2, 0.28, 0.18, 0.32),
      ),
      // Lengan Kanan
      ChildBodyPart(
        name: 'Lengan Kanan',
        subParts: [
          ChildSubPart(name: 'Lengan kanan depan', percentage: 4.5),
          ChildSubPart(name: 'Lengan kanan belakang', percentage: 4.5),
        ],
        clickableArea: const Rect.fromLTWH(0.62, 0.28, 0.18, 0.32),
      ),
      // Kaki Kiri
      ChildBodyPart(
        name: 'Kaki Kiri',
        subParts: [
          ChildSubPart(name: 'Kaki kiri depan', percentage: 7.0),
          ChildSubPart(name: 'Kaki kiri belakang', percentage: 7.0),
        ],
        clickableArea: const Rect.fromLTWH(0.3, 0.6, 0.16, 0.4),
      ),
      // Kaki Kanan
      ChildBodyPart(
        name: 'Kaki Kanan',
        subParts: [
          ChildSubPart(name: 'Kaki kanan depan', percentage: 7.0),
          ChildSubPart(name: 'Kaki kanan belakang', percentage: 7.0),
        ],
        clickableArea: const Rect.fromLTWH(0.54, 0.6, 0.16, 0.4),
      ),
      // Perineum
      ChildBodyPart(
        name: 'Perineum',
        subParts: [ChildSubPart(name: 'Perineum / genitalia', percentage: 1.0)],
        clickableArea: const Rect.fromLTWH(0.44, 0.56, 0.13, 0.07),
      ),
    ];
  }

  void _onBodyPartTapped(ChildBodyPart bodyPart) {
    setState(() {
      // Cek apakah semua sub-part dari body part ini sudah dipilih
      bool allSelected = bodyPart.subParts.every(
        (sub) => _selectedSubParts.contains(sub.name),
      );

      if (allSelected) {
        // Jika sudah semua dipilih, hapus semua (deselect)
        for (var sub in bodyPart.subParts) {
          _selectedSubParts.remove(sub.name);
        }
      } else {
        // Jika belum semua dipilih, pilih semua (select all)
        for (var sub in bodyPart.subParts) {
          _selectedSubParts.add(sub.name);
        }
      }
      _calculateTotalTBSA();
    });
  }

  void _removeSubPart(String subPartName) {
    setState(() {
      _selectedSubParts.remove(subPartName);
      _calculateTotalTBSA();
    });
  }

  void _calculateTotalTBSA() {
    double total = 0.0;
    for (var part in _childBodyParts) {
      for (var sub in part.subParts) {
        if (_selectedSubParts.contains(sub.name)) {
          total += sub.percentage;
        }
      }
    }
    setState(() {
      _totalTBSA = total;
    });
  }

  // Mengembalikan list ChildSubPart yang dipilih, urut berdasarkan kemunculan di _childBodyParts
  List<ChildSubPart> _getSelectedSubPartsOrdered() {
    List<ChildSubPart> selectedList = [];
    for (var part in _childBodyParts) {
      for (var sub in part.subParts) {
        if (_selectedSubParts.contains(sub.name)) {
          selectedList.add(sub);
        }
      }
    }
    return selectedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
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
                    const SizedBox(height: 10),
                    Expanded(child: _buildMainDiagramSection()),
                    const SizedBox(height: 10),
                    _buildBottomActionSection(),
                  ],
                ),
              ),
            ),
          ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Image.asset('assets/logo.png', width: 80, height: 80),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.home,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gambar Kebutuhan Cairan Anak',
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
      padding: const EdgeInsets.all(16),
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
      child: _buildInteractiveDiagram(),
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
                      child: const Center(
                        child: Text(
                          'Diagram Tubuh Anak',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomPaint(
                size: Size(diagramWidth, diagramHeight),
                painter: ChildBodyPartPainter(
                  bodyParts: _childBodyParts,
                  selectedSubParts: _selectedSubParts,
                ),
              ),
              ..._buildClickableAreas(diagramWidth, diagramHeight),
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

  Widget _buildBottomActionSection() {
    final selectedSubParts = _getSelectedSubPartsOrdered();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedSubParts.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              margin: const EdgeInsets.only(bottom: 12),
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: selectedSubParts.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 8),
                  itemBuilder: (context, index) {
                    final subPart = selectedSubParts[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            subPart.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${subPart.percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _removeSubPart(subPart.name),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total TBSA:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '${_totalTBSA.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.onPercentageSelected != null) {
                  widget.onPercentageSelected!(_totalTBSA);
                }
                Navigator.pop(context, _totalTBSA);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Selesai & Simpan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
          _buildNavItem(1, Icons.assignment),
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
        switch (index) {
          case 0:
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 1:
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 2:
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
        }
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

class ChildBodyPartPainter extends CustomPainter {
  final List<ChildBodyPart> bodyParts;
  final Set<String> selectedSubParts;

  ChildBodyPartPainter({
    required this.bodyParts,
    required this.selectedSubParts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var part in bodyParts) {
      // Cek apakah ada sub-part yang dipilih dalam body part ini
      bool isAnySubPartSelected = part.subParts.any(
        (sub) => selectedSubParts.contains(sub.name),
      );

      if (isAnySubPartSelected) {
        final rect = Rect.fromLTWH(
          part.clickableArea.left * size.width,
          part.clickableArea.top * size.height,
          part.clickableArea.width * size.width,
          part.clickableArea.height * size.height,
        );

        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ChildBodyPartPainter oldDelegate) {
    return oldDelegate.selectedSubParts != selectedSubParts;
  }
}
