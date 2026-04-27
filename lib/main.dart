import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_design.dart';
import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';
import 'data/service_locator.dart';
import 'data/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  locator.setup();

  final token = await locator.apiClient.getToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(PlateraApp(isLoggedIn: isLoggedIn));
}

class PlateraApp extends StatefulWidget {
  final bool isLoggedIn;
  const PlateraApp({super.key, required this.isLoggedIn});

  static _PlateraAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_PlateraAppState>()!;

  @override
  State<PlateraApp> createState() => _PlateraAppState();
}

class _PlateraAppState extends State<PlateraApp> {
  ThemeMode _themeMode = ThemeMode.light; // Default to Light as per screenshots

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platera',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E1116),
        cardColor: const Color(0xFF1A1F26),
        textTheme:
            GoogleFonts.plusJakartaSansTextTheme(
              ThemeData.dark().textTheme,
            ).apply(
              bodyColor: const Color(0xFFB0B3B8),
              displayColor: const Color(0xFFF0FDF4),
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ),
      ),
      // Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        cardColor: Colors.white,
        textTheme:
            GoogleFonts.plusJakartaSansTextTheme(
              ThemeData.light().textTheme,
            ).apply(
              bodyColor: const Color(0xFF4A4A4A),
              displayColor: const Color(0xFF1A1C1E),
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.light,
        ),
      ),
      home: widget.isLoggedIn ? const HomeScreen() : const SigninScreen(),
    );
  }
}
