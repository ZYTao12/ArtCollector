import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final String _uploadUrl = '';

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      uploadImageToAzure(); // Automatically upload after picking
    }
  }

  // Function to upload image to Azure Blob Storage
  Future<void> uploadImageToAzure() async {
    if (_imageFile != null) {
      var request = http.Request('PUT', Uri.parse(_uploadUrl));
      request.headers.addAll({
        'x-ms-blob-type': 'BlockBlob',
        'Content-Type': 'image/heic',
      });
      request.bodyBytes = await _imageFile!.readAsBytes();

      var response = await request.send();
      if (response.statusCode == 201) { // HTTP 201 Created
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Upload successful'),
          backgroundColor: Colors.green,
        ));
      } else {
        // Getting the error message from the response body if the upload fails
        String responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload image: Status code ${response.statusCode}, Error: $responseBody'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      // Handle case where no file was selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image selected'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Picture',
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickImage,
          child: Text('Upload Picture Here', style: 
          TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            )),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 108, 104, 98),
            foregroundColor: Color.fromARGB(255, 255, 255, 255), 
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          ),
        ),
      ),
    );
  }
}

