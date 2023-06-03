import 'package:ne_gorchit/model/item_model.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/services/sql_service.dart';
import 'package:ne_gorchit/services/storage_service.dart';

class ItemServices {
  SQLService sqlService = SQLService();
  StorageService storageService = StorageService();
  List<Menu> shoppingList = [];
  // List<Menu> get items => getShoppingItems(Menu);

  List<Menu> getShoppingItems(Menu menu) {
    int count = 1;
    for (var element in menu.data[0].length) {
      element.id = count;
      shoppingList.add(element);
      count++;
    }
    print('====2=');
    print(menu);
    print(menu.data[0].length);

    print(shoppingList);
    return shoppingList;
  }

  // List<Menu> getShoppingItems(Menu menu) {
  //   int count = 1;
  //   Datum element = menu.data[0];
  //   element.id = count;
  //   Menu menuObject = Menu(data: [element]);
  //   shoppingList.add(menuObject);
  //   count++;

  //   print('=====');
  //   print(menu);
  //   print(shoppingList);

  //   return shoppingList;
  // }

  List<Menu> get items => shoppingList;

  Future openDB() async {
    print('openDB');
    return await sqlService.openDB();
  }

  loadItems() async {
    bool isFirst = await isFirstTime();
    print('loadItems');

    if (isFirst) {
      // Load From local DB
      List items = await getLocalDBRecord();
      print(items);
      return items;
    } else {
      // Save Record into DB & load record
      List items = await saveToLocalDB();
      print(items);

      return items;
    }
  }

  Future<bool> isFirstTime() async {
    print('isFirstTime');

    return await storageService.getItem("isFirstTime") == 'true';
  }

  Future saveToLocalDB() async {
    List<Menu> items = this.items;
    for (var i = 0; i < items.length; i++) {
      await sqlService.saveRecord(items[i]);
    }
    storageService.setItem("isFirstTime", "true");
    return await getLocalDBRecord();
  }

  Future getLocalDBRecord() async {
    return await sqlService.getItemsRecord();
  }

  Future setItemAsFavourite(id, flag) async {
    return await sqlService.setItemAsFavourite(id, flag);
  }

  Future addToCart(Menu data) async {
    return await sqlService.addToCart(data);
  }

  Future getCartList() async {
    return await sqlService.getCartList();
  }

  removeFromCart(int shopId) async {
    return await sqlService.removeFromCart(shopId);
  }
}
