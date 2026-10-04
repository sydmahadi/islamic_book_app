import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();

  runApp(const IslamicBookApp());
}

class IslamicBookApp extends StatefulWidget {
  const IslamicBookApp({super.key});

  @override
  State<IslamicBookApp> createState() => _IslamicBookAppState();
}

class _IslamicBookAppState extends State<IslamicBookApp> {
  // App এখন প্রথমবার Light Mode-এ শুরু হবে।
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ইসলামিক বই',
      themeMode: _themeMode,

      // ═══════════════════════════════════════
      // LIGHT THEME
      // ═══════════════════════════════════════
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F3E8),

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0F5132),
          onPrimary: Colors.white,
          secondary: Color(0xFFC9A45C),
          onSecondary: Color(0xFF1A1A1A),
          surface: Color(0xFFFFFCF5),
          onSurface: Color(0xFF18352A),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F3E8),
          foregroundColor: Color(0xFF123C2A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF123C2A),
          ),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFFFFFCF5),
          elevation: 2,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color(0x22C9A45C),
              width: 1,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5132),
            foregroundColor: Colors.white,
            elevation: 2,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0F5132),
            side: const BorderSide(
              color: Color(0xFFC9A45C),
              width: 1.3,
            ),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0x22C9A45C),
        ),
      ),

      // ═══════════════════════════════════════
      // DARK THEME
      // ═══════════════════════════════════════
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF071C14),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2E8B63),
          onPrimary: Colors.white,
          secondary: Color(0xFFC9A45C),
          onSecondary: Color(0xFF17120A),
          surface: Color(0xFF10291F),
          onSurface: Color(0xFFF4EFE3),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF071C14),
          foregroundColor: Color(0xFFF4EFE3),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFFF4EFE3),
          ),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF10291F),
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color(0x33C9A45C),
              width: 1,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF176B45),
            foregroundColor: Colors.white,
            elevation: 3,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE0C27A),
            side: const BorderSide(
              color: Color(0xFFC9A45C),
              width: 1.3,
            ),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0x33C9A45C),
        ),
      ),

      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
