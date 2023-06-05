import 'package:ne_gorchit/model/menu.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ne_gorchit/model/item_model.dart';

class SQLService {
  Database? db;

  Future openDB() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'shopping.db');

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
          "shop_id INTEGER,"
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
      var qry =
          'INSERT INTO shopping(name, price, image,rating,fav) VALUES("${menu.data[0].name}",${menu.data[0].price}, "${menu.data[0].image}",${menu.data[0].rating},${menu.data[0].fav})';
      int id1 = await txn.rawInsert(qry);
      return id1;
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
      var qry =
          'INSERT INTO cart_list(shop_id, name, price, image,rating,fav) VALUES(${menu.data[0].id}, "${menu.data[0].name}",${menu.data[0].price}, "${menu.data[0].image}",${menu.data[0].rating},${menu.data[0].fav})';
      int id1 = await txn.rawInsert(qry);
      return id1;
    });
  }

  Future removeFromCart(int shopId) async {
    var qry = "DELETE FROM cart_list where shop_id = ${shopId}";
    return await this.db?.rawDelete(qry);
  }
}
