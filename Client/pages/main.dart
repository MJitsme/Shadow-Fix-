import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shadow_fix/start_screen.dart';
// import 'services/connectivity.dart'; // Import the connectivity service

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowFix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(169, 181, 173, 13),
        ),
        useMaterial3: true,
      ),
      home: const StartScreen(),
    );
  }
}
