import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/constants.dart';
import 'hasil_balance_screen.dart';

class AdultFluidIntakeBalanceScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final int age;
  final double normalIWL;

  const AdultFluidIntakeBalanceScreen({
    Key? key,
    required this.patientName,
    required this.weightKg,
    required this.age,
    required this.normalIWL,
  }) : super(key: key);

  @override
  _AdultFluidIntakeBalanceScreenState createState() =>
      _AdultFluidIntakeBalanceScreenState();
}

class _AdultFluidIntakeBalanceScreenState
    extends State<AdultFluidIntakeBalanceScreen> {
  // TextEditingControllers untuk setiap input field
  final TextEditingController _infusController = TextEditingController();
  final TextEditingController _cairanOralController = TextEditingController();
  final TextEditingController _makananController = TextEditingController();
  final TextEditingController _transfusiController = TextEditingController();
  final TextEditingController _lainnyaController = TextEditingController();

  // Variables untuk calculation results
  double _totalIntake = 0.0;
  double _balance = 0.0;
  bool _isCalculated = false;

  // NumberFormat untuk formatting
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');

  @override
  void dispose() {
    _infusController.dispose();
    _cairanOralController.dispose();
    _makananController.dispose();
    _transfusiController.dispose();
    _lainnyaController.dispose();
    super.dispose();
  }

  // Fungsi untuk menghitung balance
  void _calculateBalance() {
    double infus = double.tryParse(_infusController.text) ?? 0.0;
    double cairanOral = double.tryParse(_cairanOralController.text) ?? 0.0;
    double makanan = double.tryParse(_makananController.text) ?? 0.0;
    double transfusi = double.tryParse(_transfusiController.text) ?? 0.0;
    double lainnya = double.tryParse(_lainnyaController.text) ?? 0.0;

    setState(() {
      _totalIntake = infus + cairanOral + makanan + transfusi + lainnya;
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
              // Logo Section
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'KB',
                        style: TextStyle(
                          color: const Color(0xFF0047AB),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KalBaCa',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kalkulator Balance Cairan',
                        style: TextStyle(color: AppColors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),

              // User Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF0047AB),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Page Title
          Text('Hitung Kebutuhan Cairan Dewasa', style: AppTextStyles.menuText),
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

        _buildInputField(label: 'Infus:', controller: _infusController),
        const SizedBox(height: 16),

        _buildInputField(
          label: 'Cairan Oral:',
          controller: _cairanOralController,
        ),
        const SizedBox(height: 16),

        _buildInputField(label: 'Makanan:', controller: _makananController),
        const SizedBox(height: 16),

        _buildInputField(label: 'Transfusi:', controller: _transfusiController),
        const SizedBox(height: 16),

        _buildInputField(label: 'Lainnya:', controller: _lainnyaController),
      ],
    );
  }

  // Input Field Builder
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
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

  // Next Button to navigate to HasilBalanceScreen (Adult version)
  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HasilBalanceScreen(
                targetKebutuhanCairan:
                    widget.normalIWL *
                    2, // Sesuaikan dengan perhitungan yang sebenarnya
                totalIntake: _totalIntake,
                totalOutput:
                    widget.normalIWL, // Menggunakan normalIWL sebagai output
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
          _buildNavItem(Icons.home, false),
          _buildNavItem(Icons.calculate, true),
          _buildNavItem(Icons.person, false),
        ],
      ),
    );
  }

  // Navigation Item Builder
  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: isActive ? const Color(0xFF0047AB) : Colors.grey,
        size: 24,
      ),
    );
  }
}
