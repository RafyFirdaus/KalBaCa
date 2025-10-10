import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/constants.dart';
import 'burn_fluid_result_screen.dart';

class DataPasienScreen extends StatefulWidget {
  const DataPasienScreen({super.key});

  @override
  State<DataPasienScreen> createState() => _DataPasienScreenState();
}

class _DataPasienScreenState extends State<DataPasienScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _beratController = TextEditingController();
  final _tinggiController = TextEditingController();
  final _usiaController = TextEditingController();
  final _persentaseController = TextEditingController();
  String? _jenisKelamin;

  @override
  void dispose() {
    _namaController.dispose();
    _beratController.dispose();
    _tinggiController.dispose();
    _usiaController.dispose();
    _persentaseController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _namaController.text.isNotEmpty &&
        _beratController.text.isNotEmpty &&
        _tinggiController.text.isNotEmpty &&
        _usiaController.text.isNotEmpty &&
        _jenisKelamin != null &&
        _persentaseController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Data Pasien Section
                        _buildSectionTitle('Data Pasien'),
                        const SizedBox(height: 16),

                        // Input Fields
                        _buildInputField(
                          controller: _namaController,
                          label: 'Nama Pasien',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama pasien harus diisi';
                            }
                            if (value.length < 2) {
                              return 'Nama minimal 2 karakter';
                            }
                            return null;
                          },
                        ),

                        _buildInputField(
                          controller: _beratController,
                          label: 'Berat Badan',
                          suffix: 'kg',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Berat badan harus diisi';
                            }
                            final weight = int.tryParse(value);
                            if (weight == null || weight < 1 || weight > 500) {
                              return 'Berat badan harus antara 1-500 kg';
                            }
                            return null;
                          },
                        ),

                        _buildInputField(
                          controller: _tinggiController,
                          label: 'Tinggi Badan',
                          suffix: 'cm',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tinggi badan harus diisi';
                            }
                            final height = int.tryParse(value);
                            if (height == null || height < 30 || height > 250) {
                              return 'Tinggi badan harus antara 30-250 cm';
                            }
                            return null;
                          },
                        ),

                        _buildInputField(
                          controller: _usiaController,
                          label: 'Usia',
                          suffix: 'tahun',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Usia harus diisi';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 0 || age > 150) {
                              return 'Usia harus antara 0-150 tahun';
                            }
                            return null;
                          },
                        ),

                        _buildDropdownField(),

                        const SizedBox(height: 24),

                        // Data Luka Bakar Section
                        _buildSectionTitle('Data Luka Bakar'),
                        const SizedBox(height: 16),

                        _buildPercentageField(),

                        const SizedBox(height: 24),

                        // Diagram Button
                        _buildDiagramButton(),

                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Button
              _buildBottomButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
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
              Expanded(
                child: Text(
                  'Kalkulator Kebutuhan Cairan Luka Bakar',
                  style: AppTextStyles.menuText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? suffix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
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
                suffixText: suffix,
                errorStyle: const TextStyle(color: Colors.yellow, fontSize: 12),
              ),
              validator: validator,
              onChanged: (value) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
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
                initialValue: _jenisKelamin,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  errorStyle: TextStyle(color: Colors.yellow, fontSize: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis kelamin harus dipilih';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    _jenisKelamin = newValue;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          const SizedBox(
            width: 120,
            child: Text(
              '% Luka Bakar:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Input Field with custom design
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    '[',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _persentaseController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Persentase luka bakar harus diisi';
                        }
                        final percentage = int.tryParse(value);
                        if (percentage == null ||
                            percentage < 0 ||
                            percentage > 100) {
                          return 'Persentase harus antara 0-100';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        errorStyle: TextStyle(
                          color: Colors.yellow,
                          fontSize: 12,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Text(
                    '] % TBSA',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement diagram functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur diagram akan segera tersedia')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1565C0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          'Diagram',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _isFormValid
                ? () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate to burn fluid calculation result page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BurnFluidResultScreen(
                            patientName: _namaController.text,
                            weight: _beratController.text,
                            height: _tinggiController.text,
                            age: _usiaController.text,
                            gender: _jenisKelamin ?? '',
                            burnPercentage: _persentaseController.text,
                          ),
                        ),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1565C0),
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
              disabledForegroundColor: const Color(0xFF1565C0).withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text(
              'Hitung >>',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.calculate, false),
          _buildNavItem(Icons.person, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: isActive ? const Color(0xFF1565C0) : AppColors.inactiveGray,
        size: 24,
      ),
    );
  }
}
