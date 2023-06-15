import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ne_gorchit/model/menu.dart';
import 'package:flutter/foundation.dart';
import 'package:ne_gorchit/services/item_service.dart';

Future<List<Menu>> fetchItems(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://localhost:4000/api/items'));
  print(response);
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    List<Menu> items = [Menu.fromJson(responseData)];
    // Сохранение данных в базу данных
    ItemServices itemServices = ItemServices();
    await itemServices.openDB(); // Открываем базу данных
    print('items: $items');
    await itemServices.saveToLocalDB(items); // Сохраняем данные в базу данных
    return items;
  } else {
    throw Exception('Failed to fetch items');
  }
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

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ne_gorchit/model/menu.dart';
// import 'package:flutter/foundation.dart';
// import 'package:ne_gorchit/services/item_service.dart';

// Future<List<Menu>> fetchItems(http.Client client) async {
//   final response =
//       await client.get(Uri.parse('http://localhost:4000/api/items'));
//   print(response);
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> responseData = json.decode(response.body);
//     List<Menu> items = parseItems(responseData); // Парсинг данных с проверкой
//     if (items.isNotEmpty) {
//       // Сохранение уникальных данных в базу данных
//       ItemServices itemServices = ItemServices();
//       await itemServices.openDB(); // Открываем базу данных
//       await saveUniqueItems(
//           itemServices, items); // Сохраняем уникальные данные в базу данных
//     }
//     return items;
//   } else {
//     throw Exception('Failed to fetch items');
//   }
// }

// Future<void> saveUniqueItems(
//     ItemServices itemServices, List<Menu> items) async {
//   for (Menu item in items) {
//     bool isUnique =
//         await itemServices.checkIfUnique(item); // Проверка уникальности
//     if (isUnique) {
//       await itemServices.saveToLocalDB(
//           [item]); // Сохранение уникального элемента в базу данных
//     }
//   }
// }

// List<Menu> parseItems(Map<String, dynamic> responseData) {
//   final dynamic parsed = responseData['data'];

//   if (parsed is List<dynamic>) {
//     return parsed
//         .map<Menu>((json) => Menu.fromJson(json as Map<String, dynamic>))
//         .toList();
//   } else if (parsed is Map<String, dynamic>) {
//     // Обработка случая, когда возвращается объект, а не список
//     return [Menu.fromJson(parsed)];
//   }

//   throw Exception(
//       'Failed to parse JSON'); // Обработка непредвиденного формата данных
// }

// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:ne_gorchit/model/menu.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:ne_gorchit/services/item_service.dart';

// // Future<List<Datum>> fetchItems(http.Client client) async {
// //   final response =
// //       await client.get(Uri.parse('http://localhost:4000/api/items'));
// //   print(response);
// //   if (response.statusCode == 200) {
// //     final Map<String, dynamic> responseData = json.decode(response.body);
// //     List<Datum> items = parseItems(responseData); // Парсинг данных с проверкой
// //     if (items.isNotEmpty) {
// //       // Сохранение уникальных данных в базу данных
// //       ItemServices itemServices = ItemServices();
// //       await itemServices.openDB(); // Открываем базу данных
// //       await saveUniqueItems(
// //           itemServices, items); // Сохраняем уникальные данные в базу данных
// //     }
// //     return items;
// //   } else {
// //     throw Exception('Failed to fetch items');
// //   }
// // }

// // Future<void> saveUniqueItems(
// //     ItemServices itemServices, List<Datum> items) async {
// //   for (Datum item in items) {
// //     bool isUnique =
// //         await itemServices.checkIfUnique(item); // Проверка уникальности
// //     if (isUnique) {
// //       await itemServices.saveToLocalDB(
// //           items); // Сохранение уникального элемента в базу данных
// //     }
// //   }
// // }

// // List<Datum> parseItems(Map<String, dynamic> responseData) {
// //   final dynamic parsed = responseData['data'];

// //   if (parsed is List<dynamic>) {
// //     return parsed
// //         .map<Datum>((json) => Datum.fromJson(json as Map<String, dynamic>))
// //         .toList();
// //   } else if (parsed is Map<String, dynamic>) {
// //     // Обработка случая, когда возвращается объект, а не список
// //     return [Datum.fromJson(parsed)];
// //   }

// //   throw Exception(
// //       'Failed to parse JSON'); // Обработка непредвиденного формата данных
// // }
