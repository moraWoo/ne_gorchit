import 'package:ne_gorchit/services/item_service.dart';
import 'package:ne_gorchit/model/menu.dart';

import 'package:get/get.dart';
import 'package:ne_gorchit/services/sql_service.dart';

class HomePageController extends GetxController {
  ItemServices itemServices = ItemServices();
  List<Menu> items = [];
  List<Menu> cartItems = [];
  bool isLoading = true;
  SQLService sqlService = SQLService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await itemServices.openDB();
    print('loadDB');
    // await sqlService.saveDataToDB(data);
    getCardList();
  }

  Menu? getItem(int id) {
    for (var menu in items) {
      for (var datum in menu.data) {
        if (datum.id == id) {
          return menu;
        }
      }
    }
    return null; // Если элемент с заданным id не найден
  }

  bool isAlreadyInCart(int id) {
    for (var menu in cartItems) {
      for (var datum in menu.data) {
        if (datum.idTable == id) {
          return true;
        }
      }
    }
    return false;
  }

  getCardList() async {
    try {
      List list = await itemServices.getCartList();
      cartItems.clear();
      list.forEach((element) {
        Menu menu = Menu.fromJson(element);
        cartItems.addAll(menu.data as Iterable<Menu>);
      });
      update();
    } catch (e) {
      print(e);
    }
  }

  loadItems() async {
    try {
      isLoading = true;
      update();
      print('loadItems');

      List list = await itemServices.loadItems();
      print('list: $list');

      items.clear();
      list.forEach((element) {
        Menu menu = Menu.fromJson(element);
        items.add(menu);
      });

      isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  setToFav(int id, int flag) async {
    for (var menu in items) {
      for (var datum in menu.data) {
        if (datum.id == id) {
          datum.fav = flag;
          update();
          try {
            await itemServices.setItemAsFavourite(id, flag);
          } catch (e) {
            print(e);
          }
          return;
        }
      }
    }
  }

  Future addToCart(Menu item) async {
    isLoading = true;
    update();
    var result = await itemServices.addToCart(item);
    isLoading = false;
    update();
    return result;
  }

  removeFromCart(int idTable) async {
    itemServices.removeFromCart(idTable);
    for (var menu in cartItems) {
      int index = menu.data.indexWhere((element) => element.idTable == idTable);
      if (index > -1) {
        menu.data.removeAt(index);
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
