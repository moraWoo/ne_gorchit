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
    Database? db = await openDB();
    try {
      List<Map<String, dynamic>> existingData = await getShoppingData();

      for (var menu in data) {
        bool isUnique = true;
        for (var datum in menu.data) {
          bool alreadyExists = false;
          for (var dataItem in existingData) {
            if (dataItem['id'] == datum.id) {
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
                    'INSERT INTO menu_items(name, image, price, fav, rating, description, idTable, countOfItems) VALUES("${datum.name}", "${datum.image}", ${datum.price}, ${datum.fav}, ${datum.rating}, "${datum.description}", ${datum.idTable}, ${datum.countOfItems})';
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
          "countOfItems INTEGER,"
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
          "countOfItems INTEGER,"
          "datetime DATETIME)";

      await db?.execute(qry);
    } catch (e) {
      print("ERROR IN CREATE TABLE");
      print(e);
    }
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
    try {
      await openDB(); // Открываем базу данных, если она еще не открыта

      await db?.transaction((txn) async {
        // Проверяем, существует ли элемент с заданным id в таблице cart_list
        var selectQryCart = 'SELECT id FROM cart_list WHERE id = ?';
        var resultCart = await txn.rawQuery(selectQryCart, [item.id]);
        var existingItem = resultCart.isNotEmpty;

        if (existingItem) {
          // Обновляем countOfItems в таблице cart_list
          var updateQryCart =
              'UPDATE cart_list SET countOfItems = ? WHERE id = ?';
          await txn.rawUpdate(updateQryCart, [item.countOfItems, item.id]);
        } else {
          // Вставляем новую запись в таблицу cart_list с заданным id
          var insertQryCart =
              'INSERT INTO cart_list(id, name, image, price, fav, rating, description, idTable, countOfItems) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)';
          await txn.rawInsert(insertQryCart, [
            item.id,
            item.name,
            item.image,
            item.price,
            item.fav,
            item.rating,
            item.description,
            item.idTable,
            item.countOfItems
          ]);
        }

        // Обновляем countOfItems в таблице menu_items
        var updateQryMenu =
            'UPDATE menu_items SET countOfItems = ? WHERE id = ?';
        await txn.rawUpdate(updateQryMenu, [item.countOfItems, item.id]);
      });
    } catch (e) {
      print("ERROR IN SAVE DATA TO DB: $e");
    }
  }

  Future removeFromCart(Datum item, int id) async {
    try {
      await openDB(); // Открываем базу данных, если она еще не открыта
      await db?.transaction((txn) async {
        var selectQryCart = 'SELECT * FROM cart_list WHERE id = ${item.id}';
        var selectQryMenu = 'SELECT * FROM menu_items WHERE id = ${item.id}';

        var result = await txn.rawQuery(selectQryCart);
        var resultMenu = await txn.rawQuery(selectQryMenu);

        if (result.isNotEmpty) {
          if (item.countOfItems > 0) {
            var updateQryCart =
                'UPDATE cart_list SET countOfItems = ${item.countOfItems} WHERE id = ${item.id}';
            await txn.rawUpdate(updateQryCart);
          } else {
            var deleteQryCart = 'DELETE FROM cart_list WHERE id = ${item.id}';
            await txn.rawDelete(deleteQryCart);
          }

          if (resultMenu.isNotEmpty) {
            var updateQryMenu =
                'UPDATE menu_items SET countOfItems = ${item.countOfItems} WHERE id = ${item.id}';
            await txn.rawUpdate(updateQryMenu);
          }
        } else {
          print('item not found in cart with id ${item.id}');
        }
      });
    } catch (e) {
      print("ERROR IN SAVE DATA TO DB: $e");
    }
  }

  Future<bool> isTableNotEmpty() async {
    try {
      await openDB(); // Open the database if it's not already open

      var qry = "SELECT COUNT(*) FROM cart_list";
      var result;

      await db?.transaction((txn) async {
        result = await txn.rawQuery(qry);
      });

      if (result != null && result.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      print("ERROR IN isTableNotEmpty: $e");
      return false;
    }
  }

  Future<bool> isTableEmpty() async {
    // Изменено на isTableEmpty
    try {
      await openDB(); // Open the database if it's not already open

      var qry = "SELECT COUNT(*) FROM cart_list";
      var result;

      await db?.transaction((txn) async {
        result = await txn.rawQuery(qry);
      });

      if (result != null && result.isNotEmpty && result[0]['COUNT(*)'] == 0) {
        // Добавлено условие для проверки на пустоту
        return true;
      }

      return false;
    } catch (e) {
      print("ERROR IN isTableEmpty: $e");
      return false;
    }
  }

  Future<List<Datum>> getCartList() async {
    final db = await openDB();
    var result = await db?.query(_tableNameCart);
    if (result != null && result.isNotEmpty) {
      var cartList = result.map((row) => Datum.fromJson(row)).toList();
      return cartList;
    }
    return [];
  }
}
