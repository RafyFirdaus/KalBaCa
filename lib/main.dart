import 'package:flutter/material.dart';
import 'package:kalbaca/features/auth/presentation/screens/login_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/home_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/adult/fluid_balance_simulation_screen.dart';
import 'package:kalbaca/features/home/presentation/screens/child/child_fluid_calculation_screen.dart';

void main() {
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
        '/diagram': (context) => const FluidBalanceSimulationScreen(),
        '/child-fluid': (context) => const ChildFluidCalculationScreen(),
      },
    );
  }
}
