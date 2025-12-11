import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/constants.dart';
import 'burn_fluid_result_screen.dart';
import '../adult/fluid_balance_simulation_screen.dart';
import '../child/child_fluid_balance_simulation_screen.dart';

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
  bool _isEWLMode = false;

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
                            int.tryParse(value);
                            return null;
                          },
                        ),

                        _buildInputField(
                          controller: _usiaController,
                          label: 'Usia',
                          suffix: 'tahun',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [DecimalTextInputFormatter()],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Usia harus diisi';
                            }
                            // Normalize decimal separator
                            final normalizedValue = value.replaceAll(',', '.');
                            final age = double.tryParse(normalizedValue);
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

                        const SizedBox(height: 16),

                        // EWL Switch
                        _buildEWLSwitch(),

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
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                        LengthLimitingTextInputFormatter(
                          6,
                        ), // Increased to allow decimals like 99,99
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Persentase luka bakar harus diisi';
                        }
                        // Convert comma to dot for parsing
                        final normalizedValue = value.replaceAll(',', '.');
                        final percentage = double.tryParse(normalizedValue);
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

  Widget _buildEWLSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hitung EWL (Post 24 Jam)?',
            style: TextStyle(
              color: Color(0xFF1565C0),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: _isEWLMode,
            onChanged: (value) {
              setState(() {
                _isEWLMode = value;
              });
            },
            activeColor: const Color(0xFF1565C0),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showDiagramPopup();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1565C0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          'Gambar',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _showDiagramPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Gambar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Color(0xFF1565C0)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Dewasa Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Tutup popup

                      // Navigasi ke simulasi dewasa dengan callback
                      final result = await Navigator.push<double>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FluidBalanceSimulationScreen(
                            onPercentageSelected: (percentage) {
                              // Set nilai ke field %TBSA dengan format koma untuk desimal
                              setState(() {
                                _persentaseController.text = percentage
                                    .toString()
                                    .replaceAll('.', ',');
                              });
                            },
                          ),
                        ),
                      );

                      // Jika ada result dari Navigator.pop, update field
                      if (result != null) {
                        setState(() {
                          _persentaseController.text = result
                              .toString()
                              .replaceAll('.', ',');
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Dewasa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Anak Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Tutup popup

                      // Navigasi ke simulasi anak dengan callback
                      final result = await Navigator.push<double>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildFluidBalanceSimulationScreen(
                            onPercentageSelected: (percentage) {
                              // Set nilai ke field %TBSA dengan format koma untuk desimal
                              setState(() {
                                _persentaseController.text = percentage
                                    .toString()
                                    .replaceAll('.', ',');
                              });
                            },
                          ),
                        ),
                      );

                      // Jika ada result dari Navigator.pop, update field
                      if (result != null) {
                        setState(() {
                          _persentaseController.text = result
                              .toString()
                              .replaceAll('.', ',');
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1565C0),
                      side: const BorderSide(
                        color: Color(0xFF1565C0),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Anak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                            isEWLMode: _isEWLMode,
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
              disabledForegroundColor: const Color(
                0xFF1565C0,
              ).withValues(alpha: 0.5),
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
          _buildNavItem(0, Icons.home, true),
          _buildNavItem(1, Icons.assignment, false),
          _buildNavItem(2, Icons.person, false),
        ],
      ),
    );
  }

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
          color: isActive ? const Color(0xFF1565C0) : AppColors.inactiveGray,
          size: 24,
        ),
      ),
    );
  }
}
