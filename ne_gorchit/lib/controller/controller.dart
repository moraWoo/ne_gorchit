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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await sqlService.openDB(); // Открываем базу данных
  }

  // Future<<List<Menu>> getShoppingData() async {
  //   items = await sqlService.getShoppingData();
  // return items;
  // }

  // Future<List<Map<String, dynamic>>> getShoppingData() async {
  //   return sqlService.getShoppingData();
  // }

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
        ));
      }

      return newData; // Вернуть преобразованный список
    } catch (e) {
      print(e);
      return []; // Вернуть пустой список в случае ошибки
    }
  }

  // Future<void> getShoppingData() async {
  //   try {
  //     List<Map<String, dynamic>> shoppingData =
  //         await sqlService.getShoppingData();

  //     for (var item in shoppingData) {
  //       items.add(Datum(
  //         name: item['name'],
  //         description: item['description'],
  //         id: item['id'],
  //         image: item['image'],
  //         price: item['price'],
  //         idTable: item['idTable'],
  //         fav: item['fav'],
  //         rating: item['rating'],
  //       ));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Menu? getItem(int id) {
  //   for (var menu in items) {
  //     for (var datum in menu) {
  //       if (datum.id == id) {
  //         return menu;
  //       }
  //     }
  //   }
  //   return null; // Если элемент с заданным id не найден
  // }

  bool isAlreadyInCart(int id) {
    for (var datum in cartItems) {
      if (datum.id == id) {
        return true;
      }
    }
    return false;
  }

  // getCardList() async {
  //   try {
  //     List list = await itemServices.getCartList();
  //     cartItems.clear();
  //     list.forEach((element) {
  //       Menu menu = Menu.fromJson(element);
  //       cartItems.addAll(menu.data as Iterable<Menu>);
  //     });
  //     update();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // loadItems() async {
  //   try {
  //     isLoading = true;
  //     update();
  //     print('loadItems');

  //     List list = await itemServices.loadItems();
  //     print('list: $list');

  //     items.clear();
  //     list.forEach((element) {
  //       Menu menu = Menu.fromJson(element);
  //       items.add(menu);
  //     });

  //     isLoading = false;
  //     update();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // setToFav(int id, int flag) async {
  //   for (var menu in items) {
  //     for (var datum in menu.data) {
  //       if (datum.id == id) {
  //         datum.fav = flag;
  //         update();
  //         try {
  //           await itemServices.setItemAsFavourite(id, flag);
  //         } catch (e) {
  //           print(e);
  //         }
  //         return;
  //       }
  //     }
  //   }
  // }

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

  removeFromCart(int id) async {
    itemServices.removeFromCart(id);
    if (id > -1) {
      cartItems.removeAt(id);
    }
    update();
  }
}

void main() {
  ItemServices itemServices = ItemServices();
  itemServices.main(); // Вызов main() для заполнения списка items
}
