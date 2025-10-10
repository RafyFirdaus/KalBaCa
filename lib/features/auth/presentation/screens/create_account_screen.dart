import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/auth_result.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AuthResult result = await _authRepository.registerUser(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (result.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? 'Gagal membuat akun'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Blue Header Section with Logo and Title
              Container(
                width: double.infinity,
                color: AppColors.primaryBlue,
                padding: const EdgeInsets.all(AppDimensions.headerPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 10), // Top spacing
                    // Logo
                    Image.asset('assets/logo.png', height: 120, width: 120),
                    const SizedBox(height: AppDimensions.headerSpacing),
                    // App Title and Slogan
                    Text(
                      'KalBaCa',
                      style: AppTextStyles.appTitle.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.headerSpacing),
                    Text(
                      'Kalkulator Balance Cairan',
                      style: AppTextStyles.appSlogan.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 30), // Bottom spacing
                  ],
                ),
              ),

              // White Section with Input Fields and Action Buttons
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                transform: Matrix4.translationValues(
                  0,
                  -30,
                  0,
                ), // Overlap with blue section
                padding: const EdgeInsets.all(
                  AppDimensions.formContainerPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20), // Top spacing for overlap
                      // Page Title
                      Text(
                        'Create Account',
                        style: AppTextStyles.homeTitle.copyWith(
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.inputSpacing),

                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: AppTextStyles.inputText.copyWith(
                            color: AppColors.textGray,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.textGray,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.inputVerticalPadding,
                            horizontal: AppDimensions.inputHorizontalPadding,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silakan masukkan email Anda';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Silakan masukkan alamat email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.inputSpacing),

                      // Username TextField
                      TextFormField(
                        controller: _usernameController,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: AppTextStyles.inputText.copyWith(
                            color: AppColors.textGray,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.textGray,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.inputVerticalPadding,
                            horizontal: AppDimensions.inputHorizontalPadding,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silakan masukkan nama pengguna Anda';
                          }
                          if (value.length < 3) {
                            return 'Nama pengguna harus minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.inputSpacing),

                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textDark,
                        ),
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: AppTextStyles.inputText.copyWith(
                            color: AppColors.textGray,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.textGray,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.textGray,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.inputVerticalPadding,
                            horizontal: AppDimensions.inputHorizontalPadding,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silakan masukkan kata sandi Anda';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi harus minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.inputSpacing),

                      // Repeat Password TextField
                      TextFormField(
                        controller: _repeatPasswordController,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textDark,
                        ),
                        obscureText: !_isRepeatPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Repeat Password',
                          hintStyle: AppTextStyles.inputText.copyWith(
                            color: AppColors.textGray,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.textGray,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isRepeatPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.textGray,
                            ),
                            onPressed: () {
                              setState(() {
                                _isRepeatPasswordVisible =
                                    !_isRepeatPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: BorderSide(color: AppColors.borderGray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.inputBorderRadius,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.inputVerticalPadding,
                            horizontal: AppDimensions.inputHorizontalPadding,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silakan ulangi kata sandi Anda';
                          }
                          if (value != _passwordController.text) {
                            return 'Kata sandi tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.buttonSpacing),

                      // Create Account Button
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleCreateAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.actionBlue,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.buttonBorderRadius,
                              ),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: AppTextStyles.buttonText,
                                ),
                        ),
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.dividerSpacing,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.borderGray),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.dividerPadding,
                              ),
                              child: Text(
                                'or',
                                style: AppTextStyles.dividerText,
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppColors.borderGray),
                            ),
                          ],
                        ),
                      ),

                      // Back to Login Button
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightCyan,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.buttonBorderRadius,
                              ),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Back to Login',
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
