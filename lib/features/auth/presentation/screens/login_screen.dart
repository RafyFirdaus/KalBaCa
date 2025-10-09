import 'package:flutter/material.dart';
import 'package:kalbaca/core/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      // Email/Phone TextField
                      TextFormField(
                        controller: _emailController,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email or Phone',
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
                            return 'Please enter your email or phone';
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
                        obscureText: _obscurePassword,
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
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGray,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
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
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.inputSpacing),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.forgotPasswordText,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.buttonSpacing),

                      // Login Button
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Navigate to home page
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          },
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
                          child: const Text(
                            'Login',
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

                      // Create Account Button
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement create account
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
                            'Create an account',
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
