//import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_manager.dart';
export 'api_manager.dart' show ApiCallResponse;

class APIServerGroup {
  static String baseUrl = 'http://127.0.0.1:8000';
  static Map<String, String> headers = {};
  static CreateArtworkCall createArtworkCall = CreateArtworkCall();
  static GetArtworkCall getArtworkCall = GetArtworkCall();
  static GetFoldersCall getFoldersCall = GetFoldersCall();
}

class CreateArtworkCall {
  Future<ApiCallResponse> call({
    required String label_path,
    String? folder = '',
    String? name = '',
    String? date_of_creation = '',
    String? medium = '',
    String? description = '',
    String? author = '',
    String? picture_path = '',
    //File? image,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'createArtwork',
      apiUrl: '${APIServerGroup.baseUrl}/api/artwork/',
      callType: ApiCallType.POST,
      headers: {
        //'Authorization': 'Bearer YOUR_ACCESS_TOKEN_HERE',
        'Content-Type': 'application/json',
        'contentType': 'multipart/form-data',
      },
      params: {
        'label_path': label_path,
        if (folder != null) 'folder': folder,
        if (name != null) 'name': name,
        if (date_of_creation != null) 'date_of_creation': date_of_creation,
        if (medium != null) 'medium': medium,
        if (description != null) 'description': description,
        if (author != null) 'author': author,
        if (picture_path != null) 'picture_path': picture_path,
      },
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetArtworkCall {
  Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getArtwork',
      apiUrl: '${APIServerGroup.baseUrl}/artwork/<pk>/',
      callType: ApiCallType.GET,
      headers: {
        //'Authorization': 'Bearer YOUR_ACCESS_TOKEN_HERE',
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ProcessArtworkCall {
  Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'processArtwork',
      apiUrl: '${APIServerGroup.baseUrl}/api/artwork/$id/process/',
      callType: ApiCallType.GET,
    );
  }
}

class UpdateArtworkCall {
  Future<ApiCallResponse> call({
    String? id = '',
    String? jsonBody = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'updateArtwork',
      apiUrl: '${APIServerGroup.baseUrl}/api/artwork/$id/change/',
      callType: ApiCallType.PUT,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      body: jsonBody,
      bodyType: BodyType.JSON,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFoldersCall {
  Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getFolders',
      apiUrl: '${APIServerGroup.baseUrl}/api/folder/',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateFolderCall {
  Future<ApiCallResponse> call({
    required String displayName,
    String? folderDescription,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'createFolder',
      apiUrl: '${APIServerGroup.baseUrl}/api/folder/',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        //'contentType': 'multipart/form-data',
      },
      params: {
        'displayName': displayName,
        if (folderDescription != null) 'folderDescription': folderDescription,
      },
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFolderArtworksCall {
  Future<ApiCallResponse> call({
    required String folderId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getFolderArtworks',
      apiUrl: '${APIServerGroup.baseUrl}/api/folder/$folderId/artwork/',
      callType: ApiCallType.GET,
            headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GenerateArtworkCall {
  Future<ApiCallResponse> call({
    required String query,
    required String id,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'generateArtwork',
      apiUrl: 'https://api.artic.edu/api/v1/search',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: query,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}
