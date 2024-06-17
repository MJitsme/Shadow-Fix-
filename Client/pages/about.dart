import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              'assets/images/shadow_white.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'SHADOW FIX',
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 175,
          ),
          Text(
            'Shadow Fix is a user-friendly mobile application designed to enhance your photos by effortlessly removing shadows, allowing your images to shine with clarity.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
