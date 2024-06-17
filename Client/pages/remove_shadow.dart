import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RemoveShadow extends StatefulWidget {
  final FilePickerResult pickedFile;

  const RemoveShadow({required this.pickedFile, Key? key}) : super(key: key);

  @override
  _RemoveShadowState createState() => _RemoveShadowState();
}

class _RemoveShadowState extends State<RemoveShadow> {
  Uint8List? processedImageBytes; // Variable to store processed image bytes

  Future<void> _fetchImage(FilePickerResult? pickedFile) async {
    try {
      if (pickedFile == null || pickedFile.files.isEmpty) {
        print('No file picked');
        return;
      }

      final pickedFilePath = pickedFile.files.first.path;
      if (pickedFilePath == null) {
        print('File path is null');
        return;
      }

      List<int> imageBytes = await File(pickedFilePath).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/process_image"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'image': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          processedImageBytes = response.bodyBytes;
        });
      } else {
        print('Image not found from backend');
      }
    } catch (e) {
      print('Something went wrong: $e');
    }
  }

  Future<void> saveImageToDevice(Uint8List bytes) async {
    try {
      // Get the local storage directory
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;

      // Create a file name with a timestamp or any unique identifier
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Write the image data to a file
      File file = File('$path/$fileName');
      await file.writeAsBytes(bytes);

      // Show a message indicating successful download
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image saved to local storage'),
      ));
    } catch (e) {
      // Show an error message if there's an error saving the image
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving image: $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImage(widget.pickedFile);
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
            SizedBox(width: 8.0),
            Text(
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
            Container(
              // width: 300,
              // height: 250,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.white),
              // ),
              child: Stack(
                children: [
                  Image.file(
                    File(widget.pickedFile.files[0].path ?? ""),
                    // width: 300,
                    // height: 250,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top:
                        10, // Adjust this value to position the text vertically
                    left:
                        10, // Adjust this value to position the text horizontally
                    child: Text(
                      "Before",
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Change text color as needed
                        fontSize: 16, // Adjust font size as needed
                        fontWeight:
                            FontWeight.bold, // Adjust font weight as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (processedImageBytes != null)
              Stack(
                children: [
                  Image.memory(
                    processedImageBytes!,
                    // width: 300,
                    // height: 250,

                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top:
                        10, // Adjust this value to position the text vertically
                    left:
                        10, // Adjust this value to position the text horizontally
                    child: Text(
                      "After",
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Change text color as needed
                        fontSize: 16, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                        // Adjust font weight as needed
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (processedImageBytes != null) {
                  saveImageToDevice(processedImageBytes!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Image unavailable to download'),
                  ));
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
              child: Text('  Download Image  '),
            ),
          ],
        ),
      ),
    );
  }
}
