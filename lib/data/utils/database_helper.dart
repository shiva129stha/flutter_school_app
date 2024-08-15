

// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    final String pathToDb = path.join(dbPath, 'flutterjunction.db');

    return sql.openDatabase(
      pathToDb,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  static Future<void> _createTables(sql.Database db) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  static Future<int> createItem(String? title, String? description) async {
    final db = await database();
    final data = {'title': title, 'description': description};
    try {
      return await db.insert(
        'items',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw 'Error inserting item: $e';
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await database();
    return db.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String? description) async {
    final db = await database();
    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };
    try {
      return await db.update('items', data, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw 'Error updating item: $e';
    }
  }

  static Future<void> deleteItem(int id) async {
    final db = await database();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}



