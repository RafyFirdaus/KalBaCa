import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF0052CC); // Updated to match home page spec
  static const Color actionBlue = Color(0xFF007AFF);
  static const Color lightCyan = Color(0xFF66D9EF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color textDark = Color(0xFF333333);
  static const Color textGray = Color(0xFF666666);
  static const Color shadowColor = Color(0x1A000000);
  static const Color inactiveGray = Color(0xFF9E9E9E);
  static const Color activeBlack = Color(0xFF000000);
}

class AppTextStyles {
  static const TextStyle appTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle appSlogan = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    letterSpacing: 0.25,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
    letterSpacing: 0.15,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle forgotPasswordText = TextStyle(
    fontSize: 14,
    color: AppColors.textGray,
    letterSpacing: 0.25,
  );

  static const TextStyle dividerText = TextStyle(
    fontSize: 14,
    color: AppColors.textGray,
    letterSpacing: 0.25,
  );
  
  // Home Page Text Styles
  static const TextStyle welcomeText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle usernameText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.25,
  );
  
  static const TextStyle homeTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle homeSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.white,
    letterSpacing: 0.25,
  );
  
  static const TextStyle menuText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.25,
  );
  
  static const TextStyle buttonLabelText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
    letterSpacing: 0.15,
  );
}

class AppDimensions {
  // Header
  static const double headerPadding = 32.0;
  static const double headerSpacing = 8.0;
  
  // Form Container
  static const double formContainerRadius = 24.0;
  static const double formContainerPadding = 24.0;
  static const double formContainerMargin = 24.0;
  static const double formContainerElevation = 4.0;
  
  // Input Fields
  static const double inputBorderRadius = 12.0;
  static const double inputVerticalPadding = 16.0;
  static const double inputHorizontalPadding = 16.0;
  static const double inputSpacing = 20.0;
  
  // Buttons
  static const double buttonHeight = 52.0;
  static const double buttonBorderRadius = 12.0;
  static const double buttonSpacing = 16.0;
  
  // Other Elements
  static const double forgotPasswordSpacing = 16.0;
  static const double dividerSpacing = 24.0;
  static const double dividerPadding = 16.0;
  
  // Home Page
  static const double homePaddingHorizontal = 20.0;
  static const double homePaddingTop = 24.0;
  static const double homeMarginBottom = 16.0;
  static const double homeMarginTop = 8.0;
  static const double homeMarginSection = 24.0;
  static const double homeIconSize = 40.0;
  static const double homeIconBorder = 2.0;
  static const double homeMenuSpacing = 12.0;
  static const double homeButtonHeight = 50.0;
  static const double homeButtonRadius = 30.0;
  static const double homeButtonPadding = 16.0;
  static const double homeNavBarHeight = 60.0;
  static const double homeIndicatorSize = 10.0;
}