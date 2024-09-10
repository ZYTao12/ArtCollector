import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api_call.dart';
import 'dart:convert';
import 'dart:io';
import '../api_call.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> artwork;
  const ResultPage({Key? key, required this.artwork}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Map<String, TextEditingController> controllers;

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllers = {
      'name': TextEditingController(text: widget.artwork['name']),
      'author': TextEditingController(text: widget.artwork['author']),
      'date_of_creation': TextEditingController(text: widget.artwork['date_of_creation']),
      'medium': TextEditingController(text: widget.artwork['medium']),
      'description': TextEditingController(text: widget.artwork['description']),
    };
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Widget _buildTextField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controllers[key],
        maxLines: key == 'description' ? 5 : 1,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _saveArtwork() async {
    // Fetch the edited content
    Map<String, dynamic> updatedArtwork = {
      'id': widget.artwork['id'], 
      'name': controllers['name']!.text,
      'author': controllers['author']!.text,
      'date_of_creation': controllers['date_of_creation']!.text,
      'medium': controllers['medium']!.text,
      'description': controllers['description']!.text,
      'picture_path': _image!.path,
    };
    try {
      // Call the UpdateArtworkCall
      final updateArtworkCall = UpdateArtworkCall();
      await updateArtworkCall.call(id: updatedArtwork['id'], jsonBody: json.encode(updatedArtwork));
      print(json.encode(updatedArtwork));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artwork updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update artwork: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveArtwork,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTextField('Name', 'name'),
          _buildTextField('Author', 'author'),
          _buildTextField('Date of Creation', 'date_of_creation'),
          _buildTextField('Medium', 'medium'),
          _buildTextField('Description', 'description'),
          GestureDetector(
            onTap: getImage,
            child: Container(
              width: 240,
              height: 320,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey),
              ),
              child: _image == null
                  ? Icon(Icons.add, size: 50)
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}