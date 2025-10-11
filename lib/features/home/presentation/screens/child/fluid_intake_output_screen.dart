import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:kalbaca/features/home/presentation/screens/child/child_hasil_balance_screen.dart';

class FluidIntakeOutputScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final double normalIWL;
  final int age;
  final String gender;

  const FluidIntakeOutputScreen({
    super.key,
    required this.patientName,
    required this.weightKg,
    required this.normalIWL,
    required this.age,
    required this.gender,
  });

  @override
  State<FluidIntakeOutputScreen> createState() =>
      _FluidIntakeOutputScreenState();
}

class _FluidIntakeOutputScreenState extends State<FluidIntakeOutputScreen> {
  int _selectedIndex = 0;

  // Dynamic intake and output items
  List<Map<String, dynamic>> _intakeItems = [];
  List<Map<String, dynamic>> _outputItems = [];

  // Dropdown selections
  String _selectedIntakeType = 'Infus';
  String _selectedOutputType = 'Urine';

  // Text controllers for input values
  final TextEditingController _intakeValueController = TextEditingController();
  final TextEditingController _outputValueController = TextEditingController();
  final TextEditingController _customIntakeController = TextEditingController();
  final TextEditingController _customOutputController = TextEditingController();

  // Predefined options
  final List<String> _intakeOptions = [
    'Infus',
    'Cairan Oral',
    'Makanan',
    'Transfusi',
    'Lainnya',
  ];
  final List<String> _outputOptions = [
    'Urine',
    'Drainage',
    'Diare',
    'IWL',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    // Automatically add IWL to output items
    _outputItems.add({
      'type': 'IWL',
      'value': widget.normalIWL,
      'isReadOnly': true,
    });
  }

  @override
  void dispose() {
    _intakeValueController.dispose();
    _outputValueController.dispose();
    _customIntakeController.dispose();
    _customOutputController.dispose();
    super.dispose();
  }

  // Calculate total intake
  double calculateTotalIntake() {
    return _intakeItems.fold(
      0.0,
      (sum, item) => sum + (item['value'] as double),
    );
  }

  // Calculate total output
  double calculateTotalOutput() {
    return _outputItems.fold(
      0.0,
      (sum, item) => sum + (item['value'] as double),
    );
  }

  // Calculate fluid balance
  double calculateFluidBalance() {
    return calculateTotalIntake() - calculateTotalOutput();
  }

  // Add intake item
  void _addIntakeItem() {
    if (_selectedIntakeType == 'Lainnya') {
      if (_customIntakeController.text.trim().isNotEmpty &&
          _intakeValueController.text.trim().isNotEmpty) {
        final value = double.tryParse(_intakeValueController.text.trim());
        if (value != null && value > 0) {
          setState(() {
            _intakeItems.add({
              'type': _customIntakeController.text.trim(),
              'value': value,
              'isReadOnly': false,
            });
            _customIntakeController.clear();
            _intakeValueController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Masukkan nilai yang valid (lebih dari 0)'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi nama dan nilai intake')),
        );
      }
    } else {
      if (_intakeValueController.text.trim().isNotEmpty) {
        final value = double.tryParse(_intakeValueController.text.trim());
        if (value != null && value > 0) {
          setState(() {
            _intakeItems.add({
              'type': _selectedIntakeType,
              'value': value,
              'isReadOnly': false,
            });
            _intakeValueController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Masukkan nilai yang valid (lebih dari 0)'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Masukkan nilai intake')));
      }
    }
  }

  // Add output item
  void _addOutputItem() {
    if (_selectedOutputType == 'Lainnya') {
      if (_customOutputController.text.trim().isNotEmpty &&
          _outputValueController.text.trim().isNotEmpty) {
        final value = double.tryParse(_outputValueController.text.trim());
        if (value != null && value > 0) {
          setState(() {
            _outputItems.add({
              'type': _customOutputController.text.trim(),
              'value': value,
              'isReadOnly': false,
            });
            _customOutputController.clear();
            _outputValueController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Masukkan nilai yang valid (lebih dari 0)'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi nama dan nilai output')),
        );
      }
    } else {
      if (_outputValueController.text.trim().isNotEmpty) {
        final value = double.tryParse(_outputValueController.text.trim());
        if (value != null && value > 0) {
          setState(() {
            _outputItems.add({
              'type': _selectedOutputType,
              'value': value,
              'isReadOnly': false,
            });
            _outputValueController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Masukkan nilai yang valid (lebih dari 0)'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Masukkan nilai output')));
      }
    }
  }

  // Remove intake item
  void _removeIntakeItem(int index) {
    setState(() {
      _intakeItems.removeAt(index);
    });
  }

  // Remove output item
  void _removeOutputItem(int index) {
    if (!_outputItems[index]['isReadOnly']) {
      setState(() {
        _outputItems.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047AB), // Primary Blue
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),

            // Form Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.homePaddingHorizontal,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Intake Section
                    _buildIntakeSection(),

                    const SizedBox(height: 24),

                    // Output Section
                    _buildOutputSection(),

                    const SizedBox(height: 32),

                    // Next Button
                    _buildNextButton(),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
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
              Text('Intake dan Output Cairan', style: AppTextStyles.menuText),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Intake",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown for intake type
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedIntakeType,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIntakeType = newValue!;
                });
              },
              items: _intakeOptions.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Custom input for "Lainnya"
        if (_selectedIntakeType == 'Lainnya')
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _customIntakeController,
              decoration: InputDecoration(
                hintText: 'Masukkan jenis intake',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

        // Value input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _intakeValueController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Nilai (mL)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addIntakeItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0047AB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Tambah'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Display added intake items
        ..._intakeItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['type']}: ${item['value'].toStringAsFixed(0)} mL',
                  style: const TextStyle(color: Colors.black),
                ),
                if (!item['isReadOnly'])
                  IconButton(
                    onPressed: () => _removeIntakeItem(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOutputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Output",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown for output type
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedOutputType,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOutputType = newValue!;
                });
              },
              items: _outputOptions.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Custom input for "Lainnya"
        if (_selectedOutputType == 'Lainnya')
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _customOutputController,
              decoration: InputDecoration(
                hintText: 'Masukkan jenis output',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

        // Value input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _outputValueController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Nilai (mL)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addOutputItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0047AB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Tambah'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Display added output items
        ..._outputItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['type']}: ${item['value'].toStringAsFixed(0)} mL',
                  style: const TextStyle(color: Colors.black),
                ),
                if (!item['isReadOnly'])
                  IconButton(
                    onPressed: () => _removeOutputItem(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          // Calculate totals for direct navigation to hasil balance
          double totalIntake = calculateTotalIntake();
          double totalOutput = calculateTotalOutput();
          double targetKebutuhanCairan =
              widget.normalIWL * 2; // Adjust calculation as needed

          // Navigate directly to child hasil balance screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildHasilBalanceScreen(
                targetKebutuhanCairan: targetKebutuhanCairan,
                totalIntake: totalIntake,
                totalOutput: totalOutput,
                patientName: widget.patientName,
                weightKg: widget.weightKg,
                age: widget.age,
                normalIWL: widget.normalIWL,
                gender: widget.gender,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0047AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          "Lanjut, Hasil Balance",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
