import 'package:flutter/material.dart';
import '../api_call.dart';
import 'dart:convert';

class ArtworkDetailPage extends StatefulWidget {
  final Map<String, dynamic> artwork;
  const ArtworkDetailPage({Key? key, required this.artwork}) : super(key: key);

  @override
  _ArtworkDetailPageState createState() => _ArtworkDetailPageState();
}

class _ArtworkDetailPageState extends State<ArtworkDetailPage> {
  late Map<String, TextEditingController> controllers;

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
      'id': widget.artwork['id'], // Assuming you have an id field
      'name': controllers['name']!.text,
      'author': controllers['author']!.text,
      'date_of_creation': controllers['date_of_creation']!.text,
      'medium': controllers['medium']!.text,
      'description': controllers['description']!.text,
    };
    try {
      // Call the UpdateArtworkCall
      final updateArtworkCall = UpdateArtworkCall();
      await updateArtworkCall.call(id: updatedArtwork['id'], jsonBody: json.encode(updatedArtwork));
      
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', 'name'),
            _buildTextField('Author', 'author'),
            _buildTextField('Date of Creation', 'date_of_creation'),
            _buildTextField('Medium', 'medium'),
            _buildTextField('Description', 'description'),
          ],
        ),
      ),
    );
  }


}