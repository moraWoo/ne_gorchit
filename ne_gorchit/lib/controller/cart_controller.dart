import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/services/item_service.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  ItemServices itemServices = ItemServices();
  List<Menu> shoppingList = [];
  List<Menu> cartItems = [];

  List<Menu> getShoppingItems(Menu menu) {
    int count = 1;
    for (var element in menu.data[0].length) {
      element.id = count;
      shoppingList.add(element);
      count++;
      print(element);
    }
    print('=====1');
    print(shoppingList);
    return shoppingList;
  }

  List<Menu> get items => shoppingList;

  bool isLoading = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await itemServices.openDB();
    loadItems();
    getCardList();
  }

  getItem(int id) {
    return items.singleWhere((element) => element.data[0].id == id);
  }

  bool isAlreadyInCart(id) {
    return cartItems.indexWhere((element) => element.data[0].id == id) > -1;
  }

  getCardList() async {
    try {
      List list = await itemServices.getCartList();
      cartItems.clear();
      list.forEach((element) {
        cartItems.add(element);
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

      List list = await itemServices.loadItems();
      list.forEach((element) {
        items.add(element);
      });

      isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  setToFav(int id, bool flag) async {
    int index = items.indexWhere((element) => element.data[0].id == id);

    items[index].data[0].fav = flag;
    update();
    try {
      await itemServices.setItemAsFavourite(id, flag);
    } catch (e) {
      print(e);
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
    int index =
        cartItems.indexWhere((element) => element.data[0].idTable == idTable);
    cartItems.removeAt(index);
    update();
  }
}
