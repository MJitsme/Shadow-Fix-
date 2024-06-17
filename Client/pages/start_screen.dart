import 'package:flutter/material.dart';
import 'package:shadow_fix/upload_page.dart';
// import 'about_page.dart'; // Import the AboutPage widget

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds and then navigate to the next screen
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImageUploadPage(),
          // RemoveShadow(onFileChanged: (String imageUrl) {}
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.0,
              height: 200.0,
              child: Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/shadow_white.png'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'SHADOW FIX',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Virtual Image Shadow Remover',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
