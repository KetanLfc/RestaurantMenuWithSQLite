import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../model/menu_item.dart';

class MenuRepository {
  Future<int> insertMenuItem(MenuItem menuItem) async {
    final db = await DBHelper.instance.database;
    return await db.insert('menu', menuItem.toMap());
  }

  Future<int> updateMenuItem(MenuItem menuItem) async {
    final db = await DBHelper.instance.database;
    return await db.update(
      'menu',
      menuItem.toMap(),
      where: 'id = ?',
      whereArgs: [menuItem.id],
    );
  }

  Future<int> deleteMenuItem(int id) async {
    final db = await DBHelper.instance.database;
    return await db.delete(
      'menu',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MenuItem>> fetchMenuItems() async {
    final db = await DBHelper.instance.database;
    final result = await db.query('menu');
    return result.map((map) => MenuItem.fromMap(map)).toList();
  }
}
