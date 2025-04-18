import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/models/home_screen_models/categries_res_model.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {
  static late Database database;

  static Future initDb() async {
    database = await openDatabase(
      "cart.db",
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE ${AppConfig.tableName} (${AppConfig.primaryKey} INTEGER PRIMARY KEY, ${AppConfig.itemTitle} TEXT, ${AppConfig.itemPrice} REAL, ${AppConfig.productId} INTEGER, ${AppConfig.itemQty} INTEGER,${AppConfig.itemImage} TEXT)');
      },
    );
  }

  static Future<List<Map>> getAllData() async {
    // Get the records
    List<Map> items =
        await database.rawQuery('SELECT * FROM ${AppConfig.tableName}');
    return items;
  }

  static Future<void> addNewData(
      {required String? title,
      required String? image,
      required double? price,
      required int? productId,
      int qty = 1}) async {
    await database.rawInsert(
        'INSERT INTO ${AppConfig.tableName}(${AppConfig.itemTitle}, ${AppConfig.itemPrice}, ${AppConfig.productId}, ${AppConfig.itemQty},${AppConfig.itemImage}) VALUES(?, ?, ?,?,?)',
        [title, price, productId, qty, image]);
  }

  static Future<void> updateData({required int qty, required int id}) async {
    await database.rawUpdate(
        'UPDATE ${AppConfig.tableName} SET ${AppConfig.itemQty} = ? WHERE id = ?',
        [qty, id]);
  }

  static Future<void> delteData({required int id}) async {
    await database.rawDelete(
        'DELETE FROM ${AppConfig.tableName} WHERE ${AppConfig.primaryKey} = ?',
        [id]);
  }

  static Future<void> delteAllData() async {
    await database.delete(AppConfig.tableName);
  }
}
