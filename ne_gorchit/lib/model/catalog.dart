import 'dart:core';
import 'package:flutter/material.dart';
import 'package:ne_gorchit/model/menu.dart';

class CatalogModel {
  get itemImages => null;
  get itemNames => null;
  get itemDescription => null;
  get itemPrice => null;

  /// Get item by [id].
  /// In this sample, the catalog is infinite, looping over [itemNames].
  Item getById(int id) => Item(
      id, itemImages[id], itemNames[id], itemDescription[id], itemPrice[id]);

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }
}

@immutable
class Item {
  int id;
  String image;
  String name;
  String description;
  double price;

  Item(this.id, this.image, this.name, this.description, this.price);
  // To make the sample app look nicer, each item is given one of the
  // Material Design primary color
  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
