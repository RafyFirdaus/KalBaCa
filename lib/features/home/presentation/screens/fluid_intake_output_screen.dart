import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbaca/core/constants/constants.dart';
import 'package:kalbaca/features/home/presentation/screens/hasil_balance_screen.dart';

class FluidIntakeOutputScreen extends StatefulWidget {
  final String patientName;
  final double weightKg;
  final double normalIWL;

  const FluidIntakeOutputScreen({
    super.key,
    required this.patientName,
    required this.weightKg,
    required this.normalIWL,
  });

  @override
  State<FluidIntakeOutputScreen> createState() =>
      _FluidIntakeOutputScreenState();
}

class _FluidIntakeOutputScreenState extends State<FluidIntakeOutputScreen> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  // Intake controllers
  final TextEditingController _infusionController = TextEditingController();
  final TextEditingController _oralController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _transfusionController = TextEditingController();
  final TextEditingController _otherIntakeController = TextEditingController();

  // Output controllers
  final TextEditingController _urineController = TextEditingController();
  final TextEditingController _drainageController = TextEditingController();
  final TextEditingController _diarrheaController = TextEditingController();
  final TextEditingController _iwlController = TextEditingController();
  final TextEditingController _otherOutputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set IWL value automatically based on the value from previous screen
    _iwlController.text = widget.normalIWL.toStringAsFixed(0);
  }

  @override
  void dispose() {
    // Dispose all controllers
    _infusionController.dispose();
    _oralController.dispose();
    _foodController.dispose();
    _transfusionController.dispose();
    _otherIntakeController.dispose();
    _urineController.dispose();
    _drainageController.dispose();
    _diarrheaController.dispose();
    _iwlController.dispose();
    _otherOutputController.dispose();
    super.dispose();
  }

  // Calculate total intake
  double calculateTotalIntake() {
    double infusion = double.tryParse(_infusionController.text) ?? 0;
    double oral = double.tryParse(_oralController.text) ?? 0;
    double food = double.tryParse(_foodController.text) ?? 0;
    double transfusion = double.tryParse(_transfusionController.text) ?? 0;
    double otherIntake = double.tryParse(_otherIntakeController.text) ?? 0;

    return infusion + oral + food + transfusion + otherIntake;
  }

  // Calculate total output
  double calculateTotalOutput() {
    double urine = double.tryParse(_urineController.text) ?? 0;
    double drainage = double.tryParse(_drainageController.text) ?? 0;
    double diarrhea = double.tryParse(_diarrheaController.text) ?? 0;
    double iwl = double.tryParse(_iwlController.text) ?? 0;
    double otherOutput = double.tryParse(_otherOutputController.text) ?? 0;

    return urine + drainage + diarrhea + iwl + otherOutput;
  }

  // Calculate fluid balance
  double calculateFluidBalance() {
    return calculateTotalIntake() - calculateTotalOutput();
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

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF0047AB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and page title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              const Text(
                "Intake dan Output Cairan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // App logo
          Image.asset('assets/logo.png', width: 75, height: 75),
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
        FluidInputField(
          label: "Infus: ",
          unit: "mL",
          controller: _infusionController,
        ),
        FluidInputField(
          label: "Cairan Oral: ",
          unit: "mL",
          controller: _oralController,
        ),
        FluidInputField(
          label: "Makanan: ",
          unit: "mL",
          controller: _foodController,
        ),
        FluidInputField(
          label: "Tranfusi: ",
          unit: "mL",
          controller: _transfusionController,
        ),
        FluidInputField(
          label: "Lainnya: ",
          unit: "mL",
          controller: _otherIntakeController,
        ),
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
        FluidInputField(
          label: "Urine: ",
          unit: "mL",
          controller: _urineController,
        ),
        FluidInputField(
          label: "Drainage: ",
          unit: "mL",
          controller: _drainageController,
        ),
        FluidInputField(
          label: "Diare: ",
          unit: "mL",
          controller: _diarrheaController,
        ),
        FluidInputField(
          label: "IWL: ",
          unit: "mL",
          controller: _iwlController,
          readOnly: true,
        ),
        FluidInputField(
          label: "Lainnya: ",
          unit: "mL",
          controller: _otherOutputController,
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Navigate to balance result screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HasilBalanceScreen(
                  targetKebutuhanCairan:
                      widget.normalIWL *
                      2, // Sesuaikan dengan perhitungan kebutuhan cairan yang sebenarnya
                  totalIntake: calculateTotalIntake(),
                  totalOutput: calculateTotalOutput(),
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
          "Lanjut, Hitung Balance",
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

// Custom FluidInputField component
class FluidInputField extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final bool readOnly;

  const FluidInputField({
    Key? key,
    required this.label,
    required this.unit,
    required this.controller,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100, // Fixed width for all labels
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (!readOnly && (value == null || value.isEmpty)) {
                  return 'Masukkan nilai';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                suffixText: unit,
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
