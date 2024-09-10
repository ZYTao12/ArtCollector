import 'dart:io';
//import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:artcollector/core/base_imports.dart';
import 'package:image_picker/image_picker.dart';
import '../api_call.dart';
import 'result_page.dart';
import 'folder_artworks_page.dart';
import '../core/utils.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  Future<dynamic> _getFolders() async {
    final getFoldersCall = GetFoldersCall(); // Assuming this is the correct class name
    final response = await getFoldersCall.call();
    
    if (response.statusCode == 200) {
      return response.jsonBody;
    } else {
      throw Exception('Failed to get folders: ${response.statusCode}');
    }
  }

  Future<String> _createFolder(String folderName) async {
    final createFolderCall = CreateFolderCall();
    final response = await createFolderCall.call(
      displayName: folderName,
    );
    if (response.statusCode == 201) {
      return response.jsonBody['folderId'];
    } else {
      throw Exception('Failed to create folder, ${response.statusCode}');
    }
  }

  Future<void> _pickImageAndUploadPath() async {  
    // Show dialog to choose upload option
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text('Choose upload option'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'existing'),
            child: Text('Upload to existing folder'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'new'),
            child: Text('Create new folder and upload'),
          ),
        ],
      ),
    );

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    // show loading dialog
    // void showLoadingDialog() {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(
    //         builder: (context, setState) {
    //           return AlertDialog(
    //             content: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 CircularProgressIndicator(),
    //                 SizedBox(height: 16),
    //                 Text('Processing your image...'),
    //                 SizedBox(height: 8),
    //                 Text('Please wait'),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   );
    // }

    if (result == 'existing') {
      final selectedFolder = await _selectExistingFolder();
      if (image != null) {
        await _uploadPathToApi(image.path, folderId: selectedFolder);
      }
    } else if (result == 'new') {
      if (image != null) {
        final newFolder = await _createNewFolder();
        await _uploadPathToApi(image.path, folderId: newFolder);
      }
    }
  
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<String?> _selectExistingFolder() async {
    final getFoldersCall = GetFoldersCall();
    final folders = await getFoldersCall.call();
    if (folders.statusCode == 200) {
      final List<dynamic> folderList = folders.jsonBody;
      return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select a folder'),
            children: folderList.map((folder) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, folder['folderId']),
                child: Text(folder['displayName']),
              );
            }).toList(),
          );
        },
      );
    } else {
      throw Exception('Failed to load folders: ${folders.statusCode}');
    }
  }

  Future<String?> _createNewFolder() async {
    final TextEditingController folderNameController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter new folder name'),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(hintText: 'Folder Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final folderName = folderNameController.text;
                final newFolderId = await _createFolder(folderName);
                Navigator.pop(context, newFolderId);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadPathToApi(String filePath, {String? folderId}) async {
    final createArtworkCall = CreateArtworkCall();

    final response = await createArtworkCall.call(
      label_path: filePath,
      folder: folderId,
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
          builder: (context) => ResultPage(artwork: artworkData),
        ),
      );
    } else {
      throw Exception('Failed to update artwork, ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(child: Image.asset('lib/assets/logo/logo-banner.png', height: 320, width: double.infinity, fit: BoxFit.fitWidth,),),
            Align(
              alignment: Alignment(0,0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width:double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () async {
//TODO
                              },
                              child: Icon(
                                Icons.search,
                                color: AppTheme.tertiaryColor,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 2),
                                child: TextFormField(
                                  controller: textController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Search for an artwork',
                                    hintStyle: AppTheme.bodyText1.override(fontFamily: 'Playfair Display', fontSize: 16,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: 
                                          const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: 
                                        const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                    ),

                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<dynamic>(
                        future: _getFolders(),
                        builder: (context, snapshot) {
                          // debug snapshots
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData) {
                            return Center(child: Text('No data available'));
                          }
                          //final folders = getJsonField(snapshot.data, r'$.folders');
                          final List<dynamic> folders = snapshot.data as List<dynamic>;
                            return GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.6,
                              ),
                              shrinkWrap: true,
                              itemCount: folders.length,
                              itemBuilder: (context, index) {
                                final folder = folders[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FolderArtworksPage(
                                            folderId: getJsonField(folder, r'$.folderId').toString(),
                                            folderName: getJsonField(folder, r'$.displayName').toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  child:Card(
                                  color: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      getJsonField(folder, r'$.displayName').toString(),
                                      textAlign: TextAlign.center,
                                      style: AppTheme.title1.override(
                                        fontFamily: 'Playfair Display',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 480,
                      child: ElevatedButton(
                        onPressed: _pickImageAndUploadPath,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.tertiaryColor,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                        ),
                        child: Icon(
                          Icons.file_upload,
                          size: 48,
                          color: AppTheme.secondaryColor,
                        ),
                    ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }       
}