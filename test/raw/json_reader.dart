import 'dart:convert';

Map<String, dynamic> jsonReader(String name) {
  Map<String, dynamic> response = json.decode(name);
  return response;
}
