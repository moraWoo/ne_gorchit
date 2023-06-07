import 'package:ne_gorchit/model/menu.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLService {
  Database? db;

  Future<void> saveDataToDB(List<Menu> data) async {
    try {
      await openDB(); // Открываем базу данных, если она еще не открыта

      await db?.transaction((txn) async {
        for (var menu in data) {
          for (var datum in menu.data) {
            var qry =
                'INSERT INTO shopping(name, image, price, fav, rating, description, idTable) VALUES("${datum.name}", "${datum.image}", ${datum.price}, ${datum.fav}, ${datum.rating}, "${datum.description}", ${datum.idTable})';
            await txn.rawInsert(qry);
          }
        }
      });
    } catch (e) {
      print("ERROR IN SAVE DATA TO DB: $e");
    }
  }

  Future openDB() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'shopping_new1.db');

      // open the database
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          print(db);
          this.db = db;
          createTables();
        },
      );
      return true;
    } catch (e) {
      print("ERROR IN OPEN DATABASE $e");
      return Future.error(e);
    }
  }

  createTables() async {
    try {
      var qry = "CREATE TABLE IF NOT EXISTS shopping ( "
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
            'INSERT INTO shopping(name, image, price, fav, rating, description, idTable) VALUES("${datum.name}", "${datum.image}", ${datum.price}, ${datum.fav}, ${datum.rating}, "${datum.description}", ${datum.idTable})';
        int id1 = await txn.rawInsert(qry);
        return id1;
      }
    });
  }

  Future setItemAsFavourite(int id, int flag) async {
    var query = "UPDATE shopping set fav = ? WHERE id = ?";
    return await this.db?.rawUpdate(query, [flag, id]);
  }

  Future getItemsRecord() async {
    try {
      var list = await db?.rawQuery('SELECT * FROM shopping', []);
      return list ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future getCartList() async {
    try {
      var list = await db?.rawQuery('SELECT * FROM cart_list', []);
      return list ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future addToCart(Menu menu) async {
    await this.db?.transaction((txn) async {
      for (var datum in menu.data) {
        var qry =
            'INSERT INTO cart_list(name, image, price, fav, rating, description, idTable) VALUES("${datum.name}", "${datum.image}", ${datum.price}, ${datum.fav}, ${datum.rating}, "${datum.description}", ${datum.idTable})';
        print('qry: $qry');
        int id1 = await txn.rawInsert(qry);
        return id1;
      }
    });
  }

  Future removeFromCart(int shopId) async {
    var qry = "DELETE FROM cart_list where shop_id = ${shopId}";
    return await this.db?.rawDelete(qry);
  }
}
