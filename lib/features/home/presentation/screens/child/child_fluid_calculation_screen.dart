import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:kalbaca/features/home/presentation/screens/child/child_fluid_result_screen.dart';

// Custom input formatter untuk angka desimal dengan koma
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Hanya izinkan angka dan satu koma atau titik
    final regExp = RegExp(r'^\d*[.,]?\d*$');

    if (regExp.hasMatch(newValue.text)) {
      // Pastikan hanya ada satu separator
      final commaCount = newValue.text.split(',').length - 1;
      final dotCount = newValue.text.split('.').length - 1;

      if (commaCount + dotCount <= 1) {
        return newValue;
      }
    }

    return oldValue;
  }
}

class ChildFluidCalculationScreen extends StatefulWidget {
  const ChildFluidCalculationScreen({super.key});

  @override
  State<ChildFluidCalculationScreen> createState() =>
      _ChildFluidCalculationScreenState();
}

class _ChildFluidCalculationScreenState
    extends State<ChildFluidCalculationScreen> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();

  // Dropdown values
  String? _selectedGender;
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  // Switch value for temperature increase
  bool _isTemperatureIncreased = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047AB), // Primary Blue as specified
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Form Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.homePaddingHorizontal,
                  vertical: AppDimensions.homeMarginSection,
                ),
                child: _buildFormSection(),
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

  // Header Section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.homePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),

          // Top Row with Back Button and Logo
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

          const SizedBox(height: 20),

          // App Name and Slogan
          const SizedBox(height: 20),

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
                'Hitung Kebutuhan Cairan Anak',
                style: AppTextStyles.menuText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Form Section
  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Form Title
          Text(
            'Data Pasien',
            style: AppTextStyles.menuText.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Name Field
          _buildFormField(
            label: 'Nama Pasien:',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama pasien harus diisi';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Weight Field
          _buildFormField(
            label: 'Berat Badan:',
            controller: _weightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixText: 'kg',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Berat badan harus diisi';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Height Field
          _buildFormField(
            label: 'Tinggi Badan:',
            controller: _heightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixText: 'cm',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tinggi badan harus diisi';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Age Field with Unit Selector
          _buildAgeField(),

          const SizedBox(height: 16),

          // Gender Field (Dropdown)
          _buildGenderDropdown(),

          const SizedBox(height: 16),

          // Temperature Increase Switch
          _buildTemperatureSwitch(),

          if (_isTemperatureIncreased) ...[
            const SizedBox(height: 16),
            // Temperature Field
            _buildFormField(
              label: 'Suhu Tubuh:',
              controller: _temperatureController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              suffixText: '°C',
              validator: (value) {
                if (_isTemperatureIncreased) {
                  if (value == null || value.isEmpty) {
                    return 'Suhu tubuh harus diisi';
                  }
                  final temp = double.tryParse(value);
                  if (temp == null) {
                    return 'Format suhu tidak valid';
                  }
                  if (temp < 30 || temp > 45) {
                    return 'Suhu tidak wajar';
                  }
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  // Temperature Switch
  Widget _buildTemperatureSwitch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        const SizedBox(
          width: 120,
          child: Text(
            'Ada kenaikan suhu tubuh?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Switch
        Switch(
          value: _isTemperatureIncreased,
          onChanged: (bool value) {
            setState(() {
              _isTemperatureIncreased = value;
              if (!value) {
                _temperatureController.clear();
              }
            });
          },
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF003A8C),
        ),
      ],
    );
  }

  // Form Field Builder
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Input Field
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixText: suffixText,
              errorStyle: const TextStyle(color: Colors.yellow, fontSize: 12),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  // Age Field
  Widget _buildAgeField() {
    return _buildFormField(
      label: 'Usia:',
      controller: _ageController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [DecimalTextInputFormatter()],
      suffixText: 'tahun',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Usia harus diisi';
        }
        // Normalize decimal separator
        final normalizedValue = value.replaceAll(',', '.');
        double age = double.tryParse(normalizedValue) ?? -1;

        if (age <= 0) {
          return 'Usia harus lebih dari 0';
        }
        if (age > 18) {
          return 'Usia maksimal 18 tahun';
        }
        return null;
      },
    );
  }

  // Gender Dropdown
  Widget _buildGenderDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        const SizedBox(
          width: 120,
          child: Text(
            'Jenis Kelamin:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Dropdown Field
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(color: Colors.yellow, fontSize: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jenis kelamin harus dipilih';
              }
              return null;
            },
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
            items: _genderOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
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
        child: GestureDetector(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChildFluidResultScreen(
                    patientName: _nameController.text,
                    weightKg: double.parse(_weightController.text),
                    heightCm: double.parse(_heightController.text),
                    age: double.parse(_ageController.text.replaceAll(',', '.')),
                    gender: _selectedGender!,
                    temperature:
                        _isTemperatureIncreased &&
                            _temperatureController.text.isNotEmpty
                        ? double.parse(_temperatureController.text)
                        : null,
                  ),
                ),
              );
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF003A8C), // Darker blue for next button
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 24),
            ),
          ),
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
