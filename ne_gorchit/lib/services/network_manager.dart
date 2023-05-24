import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ne_gorchit/model/menu.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<List<Menu>> fetchItems(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://localhost:4000/api/items'));
  print(response);
  print(parseItems);
  print(response.body);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseItems, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Menu> parseItems(String responseBody) {
  final dynamic parsed = jsonDecode(responseBody);

  if (parsed is List<dynamic>) {
    print('parsed: $parsed');
    return parsed
        .map<Menu>((json) => Menu.fromJson(json as Map<String, dynamic>))
        .toList();
  } else if (parsed is Map<String, dynamic>) {
    // Обработка случая, когда возвращается объект, а не список
    print('parsed: $parsed');
    return [Menu.fromJson(parsed)];
  }

  throw Exception(
      'Failed to parse JSON'); // Обработка непредвиденного формата данных
}

// Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

// String menuToJson(Menu data) => json.encode(data.toJson());
