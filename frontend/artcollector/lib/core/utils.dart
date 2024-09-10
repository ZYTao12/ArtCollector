import 'package:json_path/json_path.dart';

dynamic getJsonField(dynamic response, String jsonPath) {
  final field = JsonPath(jsonPath).read(response);
  return field.isNotEmpty ? field.first.value : null;
}