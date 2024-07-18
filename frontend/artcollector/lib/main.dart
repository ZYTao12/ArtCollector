import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ArtworkListScreen(),
    );
  }
}

class ArtworkListScreen extends StatefulWidget {
  @override
  _ArtworkListScreenState createState() => _ArtworkListScreenState();
}

class _ArtworkListScreenState extends State<ArtworkListScreen> {
  List<dynamic> artworks = [];
  bool isLoading = true;
  String errorMessage = '';
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    // Storing credentials for the first time (do this once, or manage it properly)
    secureStorage.writeCredentials('admin', 'Sunny20031022');
    fetchArtworks();
  }

  Future<void> fetchArtworks() async {
    try {
      // Retrieve stored credentials
      final credentials = await secureStorage.readCredentials();
      final username = credentials['username'];
      final password = credentials['password'];

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/artworks/'), // Use correct IP
        headers: <String, String>{
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$username:$password')),
        },
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}'); // Debug print
        List<dynamic> data = json.decode(response.body);
        print('Parsed data: $data'); // Debug print
        setState(() {
          artworks = data;
          isLoading = false;
        });
      } else {
        print('Failed to load artworks. Status code: ${response.statusCode}');
        setState(() {
          errorMessage = 'Failed to load artworks';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Titles'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: artworks.length,
                  itemBuilder: (context, index) {
                    var artwork = artworks[index];
                    print('Artwork at index $index: $artwork'); // Debug print
                    return ListTile(
                      title: Text(artwork['name']),
                    );
                  },
                ),
    );
  }
}
