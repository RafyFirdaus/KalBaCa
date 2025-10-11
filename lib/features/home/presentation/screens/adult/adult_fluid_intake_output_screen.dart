import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:kalbaca/features/home/presentation/screens/adult/hasil_balance_screen.dart';

class AdultFluidIntakeOutputScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final double normalIWL;
  final int age;

  const AdultFluidIntakeOutputScreen({
    super.key,
    required this.patientName,
    required this.weightKg,
    required this.normalIWL,
    required this.age,
  });

  @override
  State<AdultFluidIntakeOutputScreen> createState() =>
      _AdultFluidIntakeOutputScreenState();
}

class _AdultFluidIntakeOutputScreenState
    extends State<AdultFluidIntakeOutputScreen> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  // Intake data
  List<Map<String, dynamic>> _intakeItems = [];
  String _selectedIntakeType = 'Infus';
  final TextEditingController _intakeValueController = TextEditingController();
  final TextEditingController _customIntakeController = TextEditingController();

  // Output data
  List<Map<String, dynamic>> _outputItems = [];
  String _selectedOutputType = 'Urine';
  final TextEditingController _outputValueController = TextEditingController();
  final TextEditingController _customOutputController = TextEditingController();

  // Predefined options
  final List<String> _intakeOptions = ['Infus', 'Cairan Oral', 'Makanan', 'Transfusi', 'Lainnya'];
  final List<String> _outputOptions = ['Urine', 'Drainage', 'Diare', 'IWL', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // Add IWL automatically to output items
    _outputItems.add({
      'type': 'IWL',
      'value': widget.normalIWL,
      'isReadOnly': true,
    });
  }

  @override
  void dispose() {
    _intakeValueController.dispose();
    _customIntakeController.dispose();
    _outputValueController.dispose();
    _customOutputController.dispose();
    super.dispose();
  }

  // Calculate total intake
  double calculateTotalIntake() {
    return _intakeItems.fold(0.0, (sum, item) => sum + (item['value'] as double));
  }

  // Calculate total output
  double calculateTotalOutput() {
    return _outputItems.fold(0.0, (sum, item) => sum + (item['value'] as double));
  }

  // Calculate fluid balance
  double calculateFluidBalance() {
    return calculateTotalIntake() - calculateTotalOutput();
  }

  // Add intake item
  void _addIntakeItem() {
    if (_selectedIntakeType == 'Lainnya') {
      if (_customIntakeController.text.trim().isNotEmpty && _intakeValueController.text.trim().isNotEmpty) {
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
            const SnackBar(content: Text('Masukkan nilai yang valid (lebih dari 0)')),
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
            const SnackBar(content: Text('Masukkan nilai yang valid (lebih dari 0)')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan nilai intake')),
        );
      }
    }
  }

  // Add output item
  void _addOutputItem() {
    if (_selectedOutputType == 'Lainnya') {
      if (_customOutputController.text.trim().isNotEmpty && _outputValueController.text.trim().isNotEmpty) {
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
            const SnackBar(content: Text('Masukkan nilai yang valid (lebih dari 0)')),
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
            const SnackBar(content: Text('Masukkan nilai yang valid (lebih dari 0)')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan nilai output')),
        );
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
                child: Form(
                  key: _formKey,
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
                  padding: const EdgeInsets.all(6),
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
                'Intake dan Output Cairan Dewasa',
                style: AppTextStyles.menuText,
              ),
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
                        child: Text(value, style: const TextStyle(color: Colors.black)),
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
              hintText: "Nama intake lainnya",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ],
        
        const SizedBox(height: 12),
        
        // Add button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addIntakeItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0047AB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              "+ Tambah Intake",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Added items list
        if (_intakeItems.isNotEmpty) ...[
          const Text(
            "Item Intake:",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ..._intakeItems.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${item['type']}: ${item['value'].toStringAsFixed(0)} mL",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  if (!item['isReadOnly'])
                    GestureDetector(
                      onTap: () => _removeIntakeItem(index),
                      child: const Icon(Icons.delete, color: Colors.white, size: 20),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
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
                    value: _selectedOutputType,
                    isExpanded: true,
                    items: _outputOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOutputType = newValue!;
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
                controller: _outputValueController,
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
        if (_selectedOutputType == 'Lainnya') ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: _customOutputController,
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
              hintText: "Nama output lainnya",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ],
        
        const SizedBox(height: 12),
        
        // Add button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addOutputItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0047AB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              "+ Tambah Output",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Added items list
        if (_outputItems.isNotEmpty) ...[
          const Text(
            "Item Output:",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ..._outputItems.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${item['type']}: ${item['value'].toStringAsFixed(0)} mL",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  if (!item['isReadOnly'])
                    GestureDetector(
                      onTap: () => _removeOutputItem(index),
                      child: const Icon(Icons.delete, color: Colors.white, size: 20),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Calculate totals for direct navigation to hasil balance
            double totalIntake = calculateTotalIntake();
            double totalOutput = calculateTotalOutput();
            double targetKebutuhanCairan = widget.normalIWL * 2; // Adjust calculation as needed
            
            // Navigate directly to hasil balance screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HasilBalanceScreen(
                  targetKebutuhanCairan: targetKebutuhanCairan,
                  totalIntake: totalIntake,
                  totalOutput: totalOutput,
                  patientName: widget.patientName,
                  weightKg: widget.weightKg,
                  age: widget.age,
                  normalIWL: widget.normalIWL,
                ),
              ),
            );
          }
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
          _buildNavItem(1, Icons.save),
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
