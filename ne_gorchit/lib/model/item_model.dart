class ShopItemModel {
  String name;
  double price;
  bool fav;
  double rating;
  String image;
  int id;
  int? tableId;

  ShopItemModel(
      {this.tableId,
      required this.id,
      required this.fav,
      required this.rating,
      required this.price,
      required this.image,
      required this.name});

  factory ShopItemModel.fromJson(Map<String, dynamic> json) {
    return ShopItemModel(
      id: json['id'],
      fav: json['fav'] == 1,
      rating: json['rating'],
      price: json['price'],
      image: json['image'],
      name: json['name'],
      tableId: json['table_id'] ?? 0,
    );
  }
}
