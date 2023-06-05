import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ne_gorchit/model/menu.dart';
import 'package:flutter/foundation.dart';

Future<List<Menu>> fetchItems(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://localhost:4000/api/items'));
  // Use the compute function to run parsePhotos in a separate isolate.
  print(response.body);
  return compute(parseItems, response.body);
}

List<Menu> parseItems(String responseBody) {
  final dynamic parsed = jsonDecode(responseBody);

  if (parsed is List<dynamic>) {
    return parsed
        .map<Menu>((json) => Menu.fromJson(json as Map<String, dynamic>))
        .toList();
  } else if (parsed is Map<String, dynamic>) {
    // Обработка случая, когда возвращается объект, а не список
    return [Menu.fromJson(parsed)];
  }

  throw Exception(
      'Failed to parse JSON'); // Обработка непредвиденного формата данных
}
