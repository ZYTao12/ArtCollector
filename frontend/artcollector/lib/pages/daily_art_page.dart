import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class DailyArtPage extends StatefulWidget {
  final Map<String, dynamic> artwork;

  DailyArtPage({Key? key, required this.artwork}) : super(key: key);

  @override
  _DailyArtPageState createState() => _DailyArtPageState();
}

class _DailyArtPageState extends State<DailyArtPage> {
  late String _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _processArtwork();
  }

  void _processArtwork() {
    setState(() {
      _isLoading = true;
    });

    // Process the download URL from data
    String? imageId = widget.artwork['data'][0]['image_id'];
    _imageUrl = 'https://www.artic.edu/iiif/2/$imageId/full/843,/0/default.jpg';
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Art'),
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    widget.artwork['title'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.artwork['artist_title'] ?? ''}, ${widget.artwork['date_display'] ?? ''}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Image.network(
                    _imageUrl,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('View on Art Institute of Chicago'),
                    onPressed: () {
                      String titleSlug = widget.artwork['title']?.toLowerCase().replaceAll(' ', '-') ?? '';
                      String url = 'https://www.artic.edu/artworks/${widget.artwork['image_id']}/$titleSlug';
                      // TODO: Implement url launcher to open the link
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
