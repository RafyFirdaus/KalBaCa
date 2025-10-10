import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kalbaca/firebase_options.dart';
import 'package:kalbaca/features/auth/presentation/screens/login_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/home_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/adult/adult_fluid_calculation_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/child/child_fluid_calculation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KalBaCa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0052CC)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/adult-fluid-calculation': (context) => const AdultFluidCalculationScreen(),
        '/child-fluid-calculation': (context) => const ChildFluidCalculationScreen(),
      },
    );
  }
}
