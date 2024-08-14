import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api_call.dart';
import 'artwork_detail_page.dart';
//import 'dart:developer' as dev;

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImageAndUploadPath() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      await _uploadPathToApi(image.path);
    }
  }

  Future<void> _uploadPathToApi(String filePath) async {
    final createArtworkCall = CreateArtworkCall();

    final response = await createArtworkCall.call(
      label_path: filePath,// You might want to add a field for the user to input this
    );

  if (response.statusCode == 201) {
    final artworkId = response.jsonBody['id'];
    await processArtwork(artworkId);
  } else {
      throw Exception('Failed to create artwork, ${response.statusCode}');
    }
  }

  Future<void> processArtwork(String artworkId) async {
    final processArtworkCall = ProcessArtworkCall();
    final processed_response =await processArtworkCall.call(id: artworkId);

    final response;
    final Map<String, dynamic> artworkData;

    if (processed_response.statusCode == 200) {
      final updateArtworkCall = UpdateArtworkCall();
      response = await updateArtworkCall.call(id: artworkId, jsonBody: processed_response.jsonBody);
    } else {
      throw Exception('Failed to process artwork, ${processed_response.statusCode}');
    }

    if (response.statusCode == 200) {
      artworkData = json.decode(processed_response.jsonBody);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtworkDetailPage(artwork: artworkData),
        ),
      );
    } else {
      throw Exception('Failed to update artwork, ${response.statusCode}');
    }
  }
      


/*     final response = await http.get(
      Uri.parse('${APIServerGroup.baseUrl}/api/artwork/$artworkId/process/'),
    );

    await http.put(
      Uri.parse('${APIServerGroup.baseUrl}/api/artwork/$artworkId/change/'),
    );

    if (response.statusCode == 200) {
      final artworkData = Map.fromJson(jsonDecode(response.body));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtworkDetailPage(artwork: artworkData),
        ),
      );
    } else {
      throw Exception('Failed to process artwork');
    } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your Artwork'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageAndUploadPath,
              child: Text('Select Artwork', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 108, 104, 98),
                foregroundColor: Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}