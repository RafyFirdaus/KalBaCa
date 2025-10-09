import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color - Warna utama aplikasi
  static const Color primaryBlue = Color(
    0xFF0052CC,
  ); // Updated to match home page spec

  // Action color for interactive elements - Warna untuk elemen interaktif
  static const Color actionBlue = Color(0xFF007AFF);

  // Accent color for highlights - Warna aksen untuk highlight
  static const Color lightCyan = Color(0xFF66D9EF);

  // Pure white for backgrounds and text - Putih murni untuk background dan teks
  static const Color white = Color(0xFFFFFFFF);

  // Border color for input fields and dividers - Warna border untuk input dan pembatas
  static const Color borderGray = Color(0xFFE0E0E0);

  // Dark text color for primary content - Warna teks gelap untuk konten utama
  static const Color textDark = Color(0xFF333333);

  // Gray text color for secondary content - Warna teks abu-abu untuk konten sekunder
  static const Color textGray = Color(0xFF666666);

  // Inactive state color for disabled elements - Warna untuk elemen yang tidak aktif
  static const Color inactiveGray = Color(0xFF9E9E9E);

  // Active black for emphasis - Hitam aktif untuk penekanan
  static const Color activeBlack = Color(0xFF000000);
}

class AppTextStyles {
  // Main app title - 32px bold with wide letter spacing - Judul utama aplikasi
  static const TextStyle appTitle = TextStyle(
    fontSize: 32, // Large title size - Ukuran judul besar
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing:
        0.5, // Wide spacing for emphasis - Spasi lebar untuk penekanan
  );

  // App slogan text - 16px normal weight - Teks slogan aplikasi
  static const TextStyle appSlogan = TextStyle(
    fontSize: 16, // Medium text size - Ukuran teks sedang
    color: AppColors.white,
    letterSpacing: 0.25, // Standard letter spacing - Spasi huruf standar
  );

  // Input field text - 16px for readability - Teks field input
  static const TextStyle inputText = TextStyle(
    fontSize: 16, // Readable input size - Ukuran input yang mudah dibaca
    color: AppColors.textDark,
    letterSpacing: 0.15, // Tight spacing for input - Spasi ketat untuk input
  );

  // Button text - 16px semi-bold - Teks tombol
  static const TextStyle buttonText = TextStyle(
    fontSize: 16, // Standard button text size - Ukuran teks tombol standar
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5, // Wide spacing for buttons - Spasi lebar untuk tombol
  );

  // Forgot password link - 14px small text - Link lupa password
  static const TextStyle forgotPasswordText = TextStyle(
    fontSize: 14, // Small link text size - Ukuran teks link kecil
    color: AppColors.textGray,
    letterSpacing: 0.25, // Standard spacing - Spasi standar
  );

  // Divider text - 14px for separators - Teks pembatas
  static const TextStyle dividerText = TextStyle(
    fontSize: 14, // Small divider text - Ukuran teks pembatas kecil
    color: AppColors.textGray,
    letterSpacing: 0.25, // Standard spacing - Spasi standar
  );

  // Home Page Text Styles - Gaya teks halaman beranda

  // Welcome message - 16px bold - Pesan selamat datang
  static const TextStyle welcomeText = TextStyle(
    fontSize: 16, // Medium welcome text - Ukuran teks selamat datang sedang
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing:
        0.5, // Wide spacing for emphasis - Spasi lebar untuk penekanan
  );

  // Username display - 16px bold - Tampilan nama pengguna
  static const TextStyle usernameText = TextStyle(
    fontSize: 16, // Medium username size - Ukuran nama pengguna sedang
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.25, // Standard spacing - Spasi standar
  );

  // Home page main title - 24px large bold - Judul utama halaman beranda
  static const TextStyle homeTitle = TextStyle(
    fontSize: 24, // Large home title - Ukuran judul beranda besar
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5, // Wide spacing for titles - Spasi lebar untuk judul
  );

  // Home page subtitle - 14px normal - Subjudul halaman beranda
  static const TextStyle homeSubtitle = TextStyle(
    fontSize: 14, // Small subtitle size - Ukuran subjudul kecil
    color: AppColors.white,
    letterSpacing: 0.25, // Standard spacing - Spasi standar
  );

  // Menu item text - 18px semi-bold - Teks item menu
  static const TextStyle menuText = TextStyle(
    fontSize: 16, // Medium-large menu text - Ukuran teks menu sedang-besar
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.25, // Standard menu spacing - Spasi menu standar
  );

  // Button label text - 15px medium weight - Teks label tombol
  static const TextStyle buttonLabelText = TextStyle(
    fontSize:
        15, // Slightly smaller button label - Label tombol sedikit lebih kecil
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
    letterSpacing: 0.15, // Tight spacing for labels - Spasi ketat untuk label
  );

  // Page title in app bar - 16px semi-bold - Judul halaman di app bar
  static const TextStyle pageTitle = TextStyle(
    fontSize: 16, // Standard page title size - Ukuran judul halaman standar
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.25, // Standard title spacing - Spasi judul standar
  );
}

class AppDimensions {
  // Header Section - Bagian header aplikasi
  static const double headerPadding =
      32.0; // Large padding for header content - Padding besar untuk konten header
  static const double headerSpacing =
      8.0; // Small spacing between header elements - Spasi kecil antar elemen header

  // Form Container - Kontainer formulir
  static const double formContainerRadius =
      24.0; // Rounded corners for form container - Sudut melengkung untuk kontainer form
  static const double formContainerPadding =
      24.0; // Internal padding inside form container - Padding internal dalam kontainer form

  // Input Fields - Field input
  static const double inputBorderRadius =
      12.0; // Rounded corners for input fields - Sudut melengkung untuk field input
  static const double inputVerticalPadding =
      16.0; // Top and bottom padding inside input fields - Padding atas dan bawah dalam field input
  static const double inputHorizontalPadding =
      16.0; // Left and right padding inside input fields - Padding kiri dan kanan dalam field input
  static const double inputSpacing =
      20.0; // Vertical spacing between input fields - Spasi vertikal antar field input

  // Buttons - Tombol
  static const double buttonHeight =
      52.0; // Standard height for buttons - Tinggi standar untuk tombol
  static const double buttonBorderRadius =
      12.0; // Rounded corners for buttons - Sudut melengkung untuk tombol
  static const double buttonSpacing =
      16.0; // Vertical spacing between buttons - Spasi vertikal antar tombol

  // Other Elements - Elemen lainnya
  static const double dividerSpacing =
      24.0; // Vertical spacing around dividers - Spasi vertikal di sekitar pembatas
  static const double dividerPadding =
      16.0; // Horizontal padding for divider text - Padding horizontal untuk teks pembatas

  // Home Page Layout - Tata letak halaman beranda
  static const double homePaddingHorizontal =
      18.0; // Left and right padding for home page content - Padding kiri dan kanan untuk konten beranda
  static const double homePaddingTop =
      20.0; // Top padding for home page content - Padding atas untuk konten beranda
  static const double homeMarginTop =
      5.0; // Small top margin for home page elements - Margin atas kecil untuk elemen beranda
  static const double homeMarginSection =
      24.0; // Large margin between major home page sections - Margin besar antar bagian utama beranda

  // Home Page Icons - Ikon halaman beranda
  static const double homeIconSize =
      40.0; // Size for home page icons - Ukuran untuk ikon beranda

  // Home Page Menu - Menu halaman beranda
  static const double homeMenuSpacing =
      12.0; // Spacing between menu items - Spasi antar item menu

  // Home Page Buttons - Tombol halaman beranda
  static const double homeButtonHeight =
      50.0; // Height for home page buttons - Tinggi untuk tombol beranda
  static const double homeButtonRadius =
      30.0; // Large radius for rounded home page buttons - Radius besar untuk tombol beranda yang melengkung
  static const double homeButtonPadding =
      16.0; // Internal padding for home page buttons - Padding internal untuk tombol beranda

  // Home Page Navigation - Navigasi halaman beranda
  static const double homeNavBarHeight =
      60.0; // Height for home page navigation bar - Tinggi untuk bar navigasi beranda
  static const double homeIndicatorSize =
      10.0; // Size for page indicators or dots - Ukuran untuk indikator halaman atau titik
}
