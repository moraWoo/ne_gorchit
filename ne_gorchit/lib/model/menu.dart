import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:ne_gorchit/services/item_service.dart';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  List<Datum> data;

  Menu({
    required this.data,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String description;
  int id;
  String image;
  String name;
  double price;
  int idTable;
  bool fav;
  double rating;

  Datum({
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.idTable,
    required this.fav,
    required this.rating,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        description: json["description"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        price: json["price"],
        idTable: json["idTable"],
        fav: json["fav"],
        rating: json["rating"],
      );

  get length => null;

  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "image": image,
        "name": name,
        "price": price,
        "idTable": idTable,
        "fav": fav,
        "rating": rating,
      };
}
