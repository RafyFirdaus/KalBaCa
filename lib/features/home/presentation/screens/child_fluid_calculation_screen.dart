import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbaca/core/constants/constants.dart';
// import 'package:kalbaca/features/home/presentation/screens/child_fluid_result_screen.dart';

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

  // Dropdown values
  String? _selectedGender;
  String _selectedAgeUnit = 'tahun';

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _ageUnitOptions = ['tahun', 'bulan'];

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0052CC), Color(0xFF003A8C)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildFormSection(),
                const SizedBox(height: 130), // Space for floating button
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildNextButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          const SizedBox(height: 16),

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
              Image.asset('assets/logo.png', width: 120, height: 120),
            ],
          ),

          const SizedBox(height: 20),

          // App Name and Slogan
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KalBaCa',
                style: AppTextStyles.menuText.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kalkulator Balance Cairan',
                style: AppTextStyles.menuText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.homePaddingHorizontal,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Form Title
            Text(
              'Data Pasien',
              style: AppTextStyles.menuText.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
            _buildAgeFieldWithUnit(),

            const SizedBox(height: 16),

            // Gender Field (Dropdown)
            _buildGenderDropdown(),
          ],
        ),
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

  // Age Field with Unit Selector
  Widget _buildAgeFieldWithUnit() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        const SizedBox(
          width: 120,
          child: Text(
            'Usia:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Age Input Field
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                return 'Usia harus diisi';
              }
              int age = int.tryParse(value) ?? 0;
              if (_selectedAgeUnit == 'bulan' && age > 24) {
                return 'Usia maksimal 24 bulan';
              }
              if (_selectedAgeUnit == 'tahun' && age > 18) {
                return 'Usia maksimal 18 tahun';
              }
              return null;
            },
          ),
        ),

        const SizedBox(width: 20),

        // Age Unit Dropdown
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: _selectedAgeUnit,
            isExpanded: true,
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
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedAgeUnit = newValue!;
                // Clear age field when unit changes for revalidation
                _ageController.clear();
              });
            },
            items: _ageUnitOptions.map<DropdownMenuItem<String>>((
              String value,
            ) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
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
      child: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Navigate to ChildFluidResultScreen when it's created
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Form valid! Halaman hasil akan dibuat selanjutnya.',
                ),
                backgroundColor: Colors.green,
              ),
            );

            // For now, just print the data
            print('Patient Data:');
            print('Name: ${_nameController.text}');
            print('Weight: ${_weightController.text} kg');
            print('Height: ${_heightController.text} cm');
            print('Age: ${_ageController.text} $_selectedAgeUnit');
            print('Gender: $_selectedGender');
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
