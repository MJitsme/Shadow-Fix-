import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shadow_fix/remove_shadow.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({Key? key}) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  FilePickerResult? pickedFile;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedFile = result;
      });
    }
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pickedFile != null && pickedFile!.files.isNotEmpty)
              Container(
                // width: 300,
                // height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Image.file(
                  File(pickedFile!.files.first.path ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                selectFile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('  Select Image  '),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (pickedFile != null && pickedFile!.files.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RemoveShadow(
                        pickedFile: pickedFile!,
                        // pickedFile: File(pickedFile!.files.first.path ?? ""),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an image first.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Remove Shadow'),
            ),
          ],
        ),
      ),
    );
  }
}
