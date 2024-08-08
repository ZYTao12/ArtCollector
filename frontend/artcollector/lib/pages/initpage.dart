import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'resultpage.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final String _uploadUrl = 'https://artcollector.blob.core.windows.net/testing-data/myimage.heic?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-08-07T00:54:58Z&st=2024-08-06T16:54:58Z&spr=https&sig=QobW7Kmf2w60evqVs3xby%2F8FlcSDzmP1uaGsKu1DS6o%3D';

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
      var contentType = lookupMimeType(_imageFile!.path) ?? 'application/octet-stream';
      var request = http.Request('PUT', Uri.parse(_uploadUrl));
      request.headers.addAll({
        'x-ms-blob-type': 'BlockBlob',
        'Content-Type': contentType,
      });
      request.bodyBytes = await _imageFile!.readAsBytes();
      request.headers['Content-Length'] = request.bodyBytes.length.toString();

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

  Future<void> callUtilityService(BuildContext context) async {
    // URL of the Flask service
    var url = 'http://<your-server-ip>:5000/process_image';

    // POST request to the Flask backend
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'additionalData': 'Your additional data here if needed' // Replace or remove as necessary
      }),
    );

    // Handle the response
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, parse the JSON.
      var jsonResponse = jsonDecode(response.body);
      // Navigate to the ResultScreen with the JSON response.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(result: jsonResponse)),
      );
    } else {
      // If the server did not return a 200 OK response, then display an error.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to process image: ${response.statusCode}'),
          backgroundColor: Colors.red,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Picture'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickImage,
          child: Text('Upload Picture Here', style: TextStyle(
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