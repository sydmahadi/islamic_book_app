import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  pdfrxFlutterInitialize();

  runApp(const IslamicBookApp());
}

class IslamicBookApp extends StatelessWidget {
  const IslamicBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ইসলামিক বই',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}
