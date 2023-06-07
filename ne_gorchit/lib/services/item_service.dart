import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/services/sql_service.dart';
import 'package:ne_gorchit/services/storage_service.dart';
import 'package:ne_gorchit/model/menu.dart';

class ItemServices {
  SQLService sqlService = SQLService();
  StorageService storageService = StorageService();
  List<Menu> shoppingList = [];

  List<Menu> getShoppingItems() {
    int count = 1;
    for (int i = 0; i < shoppingList.length; i++) {
      shoppingList[i].data.forEach((element) {
        element.id = count;
        count++;
      });
    }
    return shoppingList;
  }

  List<Menu> items = [];

  void main() {
    items = getShoppingItems();
    // Дополнительный код, использующий переменную items
  }

  Future openDB() async {
    return await sqlService.openDB();
  }

  loadItems() async {
    bool isFirst = await isFirstTime();

    if (isFirst) {
      // Load From local DB
      List items = await getLocalDBRecord();
      return items;
    } else {
      // Save Record into DB & load record
      bool loadedItems = await saveToLocalDB(items);
      return loadedItems;
    }
  }

  Future<bool> isFirstTime() async {
    return await storageService.getItem("isFirstTime") == 'true';
  }

  Future<bool> saveToLocalDB(List<Menu> items) async {
    try {
      await sqlService.openDB(); // Открываем базу данных
      await sqlService.saveDataToDB(items); // Сохраняем данные в базу данных
      return true; // Успешное сохранение
    } catch (e) {
      print('Error saving data to local DB: $e');
      return false; // Ошибка при сохранении
    }
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

  removeFromCart(int idTable) async {
    return await sqlService.removeFromCart(idTable);
  }
}
