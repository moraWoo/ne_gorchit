import 'package:ne_gorchit/services/item_service.dart';
import 'package:ne_gorchit/model/menu.dart';

import 'package:get/get.dart';
import 'package:ne_gorchit/services/sql_service.dart';

class HomePageController extends GetxController {
  ItemServices itemServices = ItemServices();
  List<Datum> items = [];
  List<Datum> cartItems = [];
  bool isLoading = true;
  SQLService sqlService = SQLService();

  List<Datum> cartList = [];

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  Future<bool> isAlreadyInCart(int id) async {
    try {
      List<Map<String, dynamic>> cartList = await sqlService.getShoppingData();
      List<Datum> newData = [];

      for (var item in cartList) {
        newData.add(Datum(
          name: item['name'],
          description: item['description'],
          id: item['id'],
          image: item['image'],
          price: item['price'],
          idTable: item['idTable'],
          fav: item['fav'],
          rating: item['rating'],
        ));
      }

      for (var datum in newData) {
        if (datum.id == id) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  loadDB() async {
    await sqlService.openDB(); // Открываем базу данных
  }

  Future<List<Datum>> getShoppingData() async {
    try {
      List<Map<String, dynamic>> shoppingData =
          await sqlService.getShoppingData();
      List<Datum> newData = [];

      for (var item in shoppingData) {
        newData.add(Datum(
          name: item['name'],
          description: item['description'],
          id: item['id'],
          image: item['image'],
          price: item['price'],
          idTable: item['idTable'],
          fav: item['fav'],
          rating: item['rating'],
          countOfItems: item['countOfItems'],
        ));
      }

      return newData; // Вернуть преобразованный список
    } catch (e) {
      print(e);
      return []; // Вернуть пустой список в случае ошибки
    }
  }

  Future<List<Datum>> getCartData() async {
    try {
      List<Map<String, dynamic>> cartData = await sqlService.getCartData();
      List<Datum> cartDataList = [];

      for (var item in cartData) {
        cartDataList.add(Datum(
          name: item['name'],
          description: item['description'],
          id: item['id'],
          image: item['image'],
          price: item['price'],
          idTable: item['idTable'],
          fav: item['fav'],
          rating: item['rating'],
          countOfItems: item['countOfItems'],
        ));
      }
      return cartDataList; // Вернуть преобразованный список
    } catch (e) {
      print(e);
      return []; // Вернуть пустой список в случае ошибки
    }
  }

  Future eraseCart() async {
    itemServices.eraseCart();
    cartItems.remove;
    update();
  }

  Future addToCart(Datum item) async {
    isLoading = true;
    update();
    var result = await itemServices.addToCart(item);
    isLoading = false;
    update();
    return result;
  }

  removeFromCart(Datum item, int id) async {
    await itemServices.removeFromCart(item, item.id);
    Datum removedItem;

    for (var item in cartItems) {
      if (item.id == id) {
        removedItem = item;
        break;
      }
    }
    update();
  }
}

void main() {
  ItemServices itemServices = ItemServices();
  itemServices.main(); // Вызов main() для заполнения списка items
}