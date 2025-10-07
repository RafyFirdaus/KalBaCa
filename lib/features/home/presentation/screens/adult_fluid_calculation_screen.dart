import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:kalbaca/features/home/presentation/screens/adult_fluid_result_screen.dart';

class AdultFluidCalculationScreen extends StatefulWidget {
  const AdultFluidCalculationScreen({super.key});

  @override
  State<AdultFluidCalculationScreen> createState() =>
      _AdultFluidCalculationScreenState();
}

class _AdultFluidCalculationScreenState
    extends State<AdultFluidCalculationScreen> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Dropdown value for gender
  String? _selectedGender;
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
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
            _buildHeaderSection(),

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
                'Hitung Kebutuhan Cairan Dewasa',
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

          // Age Field
          _buildFormField(
            label: 'Usia:',
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixText: 'tahun',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Usia harus diisi';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Gender Field (Dropdown)
          _buildGenderDropdown(),
        ],
      ),
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
              suffixText: suffixText,
              errorStyle: const TextStyle(color: Colors.yellow, fontSize: 12),
            ),
            validator: validator,
          ),
        ),
      ],
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

        // Dropdown
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedGender,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
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
              items: _genderOptions.map<DropdownMenuItem<String>>((
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
              // Navigate to result screen with form data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdultFluidResultScreen(
                    patientName: _nameController.text,
                    weightKg: double.parse(_weightController.text),
                    heightCm: double.parse(_heightController.text),
                    age: int.parse(_ageController.text),
                    gender: _selectedGender!,
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
