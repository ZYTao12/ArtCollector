import 'dart:io';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class APIServerGroup {
  static String baseUrl = 'http://127.0.0.1:8000';
  static Map<String, String> headers = {};
  static CreateArtworkCall createArtworkCall = CreateArtworkCall();
  static GetArtworkCall getArtworkCall = GetArtworkCall();
}

class CreateArtworkCall {
  Future<ApiCallResponse> call({
    required String label_path,
    String? folder = '1',
    String? name = '',
    String? date_of_creation = '',
    String? medium = '',
    String? description = '',
    String? author = '',
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
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN_HERE',
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
      apiUrl: '${APIServerGroup.baseUrl}/api/artwork/$id/process/',
      callType: ApiCallType.PUT,
      headers: {
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