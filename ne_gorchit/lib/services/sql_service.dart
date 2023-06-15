import 'package:flutter/foundation.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLService {
  Database? db;
  final String _databaseName = 'menu_current.db';

  final String _tableNameMenu = 'menu_items';
  final String _tableNameCart = 'cart_list';

  Future<List<Map<String, dynamic>>> getShoppingData() async {
    final db = await openDB();
    return await db?.query(_tableNameMenu) ??
        []; // Добавлено условие и возврат пустого списка при null
  }

  Future<Database?> openDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, _databaseName);

      bool dbExists = await checkDBExistence();

      if (!dbExists) {
        // База данных не существует, выполните необходимые действия
        // для создания базы данных и таблиц
        db = await openDatabase(
          path,
          version: 1,
          onCreate: (Database db, int version) async {
            print('db: $db');
            this.db = db;
            createTables();
          },
        );
      } else {
        // База данных уже существует, просто открываем ее
        db = await openDatabase(path, version: 1);
        createTables(); // Добавьте вызов createTables здесь
      }

      return db;
    } catch (e) {
      print("ERROR IN OPEN DATABASE $e");
      return null;
    }
  }

  Future<void> saveDataToDB(List<Menu> data) async {
    print('data: $data');
    Database? db = await openDB();
    try {
      List<Map<String, dynamic>> existingData = await getShoppingData();
      print('existingData: $existingData');

      for (var menu in data) {
        bool isUnique = true;
        for (var datum in menu.data) {
          bool alreadyExists = false;
          for (var dataItem in existingData) {
            // Изменено имя переменной на dataItem
            if (dataItem['id'] == datum.id) {
              // Изменено имя переменной на dataItem
              alreadyExists = true;
              break;
            }
          }

          if (alreadyExists) {
            isUnique = false;
            break;
          }
        }

        if (isUnique) {
          await db?.transaction((txn) async {
            for (var menu in data) {
              for (var datum in menu.data) {
                var qry =
                    'INSERT INTO menu_items(name, image, price, fav, rating, description, idTable) VALUES("${datum.name}", "${datum.image}", ${datum.price}, ${datum.fav}, ${datum.rating}, "${datum.description}", ${datum.idTable})';
                await txn.rawInsert(qry);
              }
            }
          });
          break;
        }
      }
    } catch (e) {
      print("ERROR IN SAVE DATA TO DB: $e");
      debugPrint;
    }
  }

  Future<List<Map<String, dynamic>>> getCartData() async {
    final db = await openDB();
    return await db?.query(_tableNameCart) ?? [];
  }

  Future<void> saveDataToCartDB(Datum item) async {
    try {
      await openDB(); // Открываем базу данных, если она еще не открыта
      await db?.transaction((txn) async {
        var qry =
            'INSERT INTO cart_list(name, image, price, fav, rating, description, idTable) VALUES("${item.name}", "${item.image}", "${item.price}", "${item.fav}", "${item.rating}", "${item.description}", "${item.idTable}")';
        await txn.rawInsert(qry);
      });
    } catch (e) {
      print("ERROR IN SAVE DATA TO DB: $e");
    }
  }

  Future<bool> checkDBExistence() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await databaseExists(path);
  }

  createTables() async {
    try {
      var qry = "CREATE TABLE IF NOT EXISTS menu_items ( "
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image Text,"
          "price REAL,"
          "fav INTEGER,"
          "rating REAL,"
          "description TEXT,"
          "idTable INTEGER,"
          "datetime DATETIME)";
      await db?.execute(qry);
      qry = "CREATE TABLE IF NOT EXISTS cart_list ( "
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image Text,"
          "price REAL,"
          "fav INTEGER,"
          "rating REAL,"
          "description TEXT,"
          "idTable INTEGER,"
          "datetime DATETIME)";

      await db?.execute(qry);
    } catch (e) {
      print("ERROR IN CREATE TABLE");
      print(e);
    }
  }

  Future saveRecord(Menu menu) async {
    await this.db?.transaction((txn) async {
      for (var datum in menu.data) {
        var qry =
            'INSERT INTO menu_items(name, image, price, fav, rating, description, idTable) VALUES("${datum.name}", "${datum.image}", ${datum.price}, ${datum.fav}, ${datum.rating}, "${datum.description}", ${datum.idTable})';
        int id1 = await txn.rawInsert(qry);
        return id1;
      }
    });
  }

  Future setItemAsFavourite(int id, int flag) async {
    var query = "UPDATE menu_items set fav = ? WHERE id = ?";
    return await this.db?.rawUpdate(query, [flag, id]);
  }

  Future getItemsRecord() async {
    try {
      var list = await db?.rawQuery('SELECT * FROM menu_items', []);
      return list ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future addToCart(Datum item) async {
    await this.db?.transaction((txn) async {
      var qry =
          'INSERT INTO cart_list(name, image, price, fav, rating, description, idTable,) VALUES("${item.name}", "${item.image}", "${item.price}", "${item.fav}", "${item.rating}", "${item.description}", "${item.idTable}")';
      print('qry: $qry');
      int id1 = await txn.rawInsert(qry);
      print('item saved in cart');
      return id1;
    });
  }

  Future removeFromCart(int id) async {
    var qry = "DELETE FROM cart_list where id = ${id}";
    return await this.db?.rawDelete(qry);
  }

// Метод для удаления содержимого таблицы cart_list при выполнении команды Заказать в экране Корзина
  Future eraseCart() async {
    var qry = "DELETE FROM cart_list";
    return await this.db?.rawDelete(qry);
  }

  Future<bool> isTableNotEmpty() async {
    var qry = "SELECT COUNT(*) FROM cart_list";
    var result = await this.db?.rawQuery(qry);

    if (result != null && result.isNotEmpty) {
      var count = Sqflite.firstIntValue(result);
      return count != null && count > 0;
    }
    return false;
  }

  Future<List<Datum>> getCartList() async {
    final db = await openDB();
    var result = await db?.query(_tableNameCart);
    if (result != null && result.isNotEmpty) {
      var cartList = result.map((row) => Datum.fromJson(row)).toList();
      print('cartList: $cartList');
      return cartList;
    }
    return [];
  }
}
