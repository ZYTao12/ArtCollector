import 'package:flutter/material.dart';
import '../api_call.dart';
import '../core/base_imports.dart';
import 'result_page.dart';

class FolderArtworksPage extends StatelessWidget {
  final String folderId;
  final String folderName;

  const FolderArtworksPage({Key? key, required this.folderId, required this.folderName}) : super(key: key);

  Future<List<dynamic>> _getFolderArtworks() async {
    final folderArtworksCall = GetFolderArtworksCall();
    final response = await folderArtworksCall.call(folderId: folderId);
    
    if (response.statusCode == 200) {
      return response.jsonBody;
    } else {
      throw Exception('Failed to get folder artworks: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(folderName),
        backgroundColor: AppTheme.tertiaryColor,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getFolderArtworks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No artworks in this folder'));
          }

          final artworks = snapshot.data!;
          print('Number of artworks: ${artworks.length}');
          return ListView.builder(
            itemCount: artworks.length,
            itemBuilder: (context, index) {
              final artwork = artworks[index];
              print('Artwork $index: $artwork');
              final String title = (artwork['name'] as String?)?.isNotEmpty == true ? artwork['name'] : 'Untitled';
              final String author = (artwork['author'] as String?)?.isNotEmpty == true ? artwork['author'] : 'Unknown artist';
              print('Artwork $index - Title: $title, Author: $author');
              return ListTile(
                title: Text(title),
                subtitle: Text(author),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(artwork: artwork),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}