import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/constants.dart';
import 'burn_fluid_balance_result_screen.dart';

class BurnFluidBalanceCalculationScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final int age;
  final double normalIWL;
  final String gender;

  const BurnFluidBalanceCalculationScreen({
    Key? key,
    required this.patientName,
    required this.weightKg,
    required this.age,
    required this.normalIWL,
    required this.gender,
  }) : super(key: key);

  @override
  _BurnFluidBalanceCalculationScreenState createState() =>
      _BurnFluidBalanceCalculationScreenState();
}

class _BurnFluidBalanceCalculationScreenState
    extends State<BurnFluidBalanceCalculationScreen> {
  // Dropdown-related variables
  final List<String> _intakeOptions = [
    'Infus',
    'Cairan Oral',
    'Makanan',
    'Transfusi',
    'Lainnya'
  ];
  String _selectedIntakeType = 'Infus';
  final TextEditingController _intakeValueController = TextEditingController();
  final TextEditingController _customIntakeController = TextEditingController();
  List<Map<String, dynamic>> _intakeItems = [];

  // Variables untuk calculation results
  double _totalIntake = 0.0;
  double _balance = 0.0;
  bool _isCalculated = false;

  // NumberFormat untuk formatting
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');

  @override
  void dispose() {
    _intakeValueController.dispose();
    _customIntakeController.dispose();
    super.dispose();
  }

  // Function to add intake item
  void _addIntakeItem() {
    if (_intakeValueController.text.isEmpty) return;

    double value = double.tryParse(_intakeValueController.text) ?? 0.0;
    if (value <= 0) return;

    String type = _selectedIntakeType;
    if (_selectedIntakeType == 'Lainnya' && _customIntakeController.text.isNotEmpty) {
      type = _customIntakeController.text;
    }

    setState(() {
      _intakeItems.add({
        'type': type,
        'value': value,
      });
      _intakeValueController.clear();
      if (_selectedIntakeType == 'Lainnya') {
        _customIntakeController.clear();
      }
    });
  }

  // Function to remove intake item
  void _removeIntakeItem(int index) {
    setState(() {
      _intakeItems.removeAt(index);
    });
  }

  // Function to calculate total intake from items
  double _calculateTotalIntake() {
    return _intakeItems.fold(0.0, (sum, item) => sum + item['value']);
  }

  // Fungsi untuk menghitung balance
  void _calculateBalance() {
    setState(() {
      _totalIntake = _calculateTotalIntake();
      _balance = _totalIntake - widget.normalIWL;
      _isCalculated = true;
    });
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

            // Content Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.homePaddingHorizontal,
                  vertical: AppDimensions.homeMarginSection,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputSection(),
                    const SizedBox(height: 24),
                    _buildCalculateButton(),
                    if (_isCalculated) ...[
                      const SizedBox(height: 24),
                      _buildResultSection(),
                      const SizedBox(height: 24),
                      _buildNextButton(),
                    ],
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

  // Input Section
  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intake',
          style: AppTextStyles.menuText.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Dropdown and input row
        Row(
          children: [
            // Dropdown
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0047AB), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedIntakeType,
                    isExpanded: true,
                    items: _intakeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedIntakeType = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Value input
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _intakeValueController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF0047AB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF0047AB)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: "mL",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),

        // Custom input for "Lainnya"
        if (_selectedIntakeType == 'Lainnya') ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: _customIntakeController,
            decoration: InputDecoration(
              hintText: 'Masukkan jenis intake',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0047AB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0047AB)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ],

        const SizedBox(height: 12),

        // Add button
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: _addIntakeItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0047AB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
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

  // Calculate Button
  Widget _buildCalculateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _calculateBalance,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0047AB),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Hitung Balance',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Result Section
  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil Balance',
          style: AppTextStyles.menuText.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Balance Result Field
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Label
            SizedBox(
              width: 120,
              child: Text(
                'Balance (+/-)',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatter.format(_balance),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'mL',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Next Button to navigate to BurnFluidBalanceResultScreen
  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BurnFluidBalanceResultScreen(
                targetKebutuhanCairan:
                    widget.normalIWL *
                    2, // Sesuaikan dengan perhitungan yang sebenarnya
                totalIntake: _totalIntake,
                totalOutput:
                    widget.normalIWL, // Menggunakan normalIWL sebagai output
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
          "Lanjut ke Hasil",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      height: AppDimensions.homeNavBarHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home, false),
          _buildNavItem(1, Icons.assignment, true),
          _buildNavItem(2, Icons.person, false),
        ],
      ),
    );
  }

  // Navigation Item Builder
  Widget _buildNavItem(int index, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () {
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
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF0047AB) : Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}
