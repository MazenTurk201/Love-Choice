import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// ignore: unnecessary_import
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  static Future<Database> initDatabase() async {
    final docsDir = await getApplicationDocumentsDirectory();

    final dbName = 'love_choice3.db';

    final exists = await File(join(docsDir.path, dbName)).exists();
    if (!exists) {
      ByteData data = await rootBundle.load('assets/$dbName');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(join(docsDir.path, dbName)).writeAsBytes(bytes);
    }

    return await openDatabase(join(docsDir.path, dbName));
  }

  static Future<List<Map<String, dynamic>>> getUsers(String tablee) async {
    final db = await database;
    // return await db.query(tablee, orderBy: 'RANDOM()');
    return await db.query(tablee);
  }

  static Future<List<Map<String, dynamic>>> getRandUsers(String tablee) async {
    final db = await database;
    return await db.query(tablee, orderBy: 'RANDOM()');
  }

  static Future<void> insertUser(
    String tablee,
    String choice,
    String dare,
  ) async {
    final db = await database;
    await db.insert(tablee, {'choice': choice, 'dare': dare});
  }

  static Future<void> updateUser(
    String tablee,
    String choice,
    String dare,
    int index,
  ) async {
    final db = await database;
    // await db.update(
    //   tablee,
    //   {'choice': choice, 'dare': dare},
    //   where: 'rowid = ?',
    //   whereArgs: [index],
    // );
    await db.rawUpdate(
      " UPDATE $tablee SET choice = ?, dare = ? WHERE ROWID = (SELECT ROWID FROM $tablee ORDER BY ROWID LIMIT 1 OFFSET $index)",
      [choice, dare],
    );
    // await db.update(
    //   tablee,
    //   {'choice': choice, 'dare': dare},
    //   where: "rowid = ?",
    //   whereArgs: [
    //     "( SELECT ROWID FROM $tablee ORDER BY ROWID LIMIT 1 OFFSET $index)",
    //   ],
    // );
  }

  static Future<Map<String, dynamic>?> getupdateUser(
    String tablee,
    int index,
  ) async {
    final db = await database;
    final result = await db.query(tablee, limit: 1, offset: index - 1);
    // await db.execute("SELECT * FROM $tablee LIMIT 1 OFFSET $index");
    return result.first;
  }

  static Future<void> deleteUser(String tablee, String index) async {
    final db = await database;
    List<String> parts = index.split(",");
    int p1 = int.parse(parts[0]) - 1;
    int? p2;

    if (parts.length > 1) {
      try {
        p2 = int.parse(parts[1]);
      } catch (e) {
        p2 = null;
      }
    }

    if (p2 != null) {
      if (p1 > p2) {
        int temp = p1;
        p1 = p2;
        p2 = temp;
      }

      if (p1 < 0) p1 = 0;
      int limit = (p2 - p1);

      await db.rawDelete(
        'DELETE FROM $tablee WHERE ROWID IN (SELECT ROWID FROM $tablee LIMIT $limit OFFSET $p1)',
      );
    } else {
      if (p1 < 0) p1 = 0;

      await db.rawDelete(
        'DELETE FROM $tablee WHERE ROWID = (SELECT ROWID FROM $tablee LIMIT 1 OFFSET $p1)',
      );
    }
  }

  static Future<Map<String, dynamic>?> getRandomUser(String tablee) async {
    final db = await database;
    final result = await db.query(tablee);
    if (result.isNotEmpty) {
      final rand = Random();
      return result[rand.nextInt(result.length)];
    }
    return null;
  }
}
