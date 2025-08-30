import 'dart:io';
import 'dart:math';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static late CombinedDatabase database;

  static Future<void> init() async {
    // مجلد التخزين الآمن للتطبيق
    final downloadsDir = await getExternalStorageDirectory();
    final dbDir = Directory(join(downloadsDir!.path, 'Love Choice'));
    // final downloadsDir = "/storage/emulated/0/Download";
    // final dbDir = Directory(join(downloadsDir, 'Love Choice'));
    if (!dbDir.existsSync()) dbDir.createSync(recursive: true);

    // مسار defaultDb
    final defaultDbPath = join(dbDir.path, 'love_choice3.db');
    final defaultDbFile = File(defaultDbPath);

    // انسخ من assets لو مش موجود
    if (!defaultDbFile.existsSync()) {
      ByteData data = await rootBundle.load("assets/love_choice3.db");
      List<int> bytes = data.buffer.asUint8List();
      await defaultDbFile.writeAsBytes(bytes, flush: true);
    }

    final defaultDb = await openDatabase(defaultDbPath, version: 1);

    // مسار userDb
    final userDbPath = join(dbDir.path, 'user_database.db');
    if (!File(userDbPath).existsSync()) {
      // ignore: unused_local_variable
      final userDb = await openDatabase(
        userDbPath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ahl_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS metgawzen_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ma5toben_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS shella_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS t3arof_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS couples_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS bestat_choices (id INTEGER PRIMARY KEY, choice TEXT, dare TEXT)',
          );
        },
      );
    }

    final userDb = await openDatabase(userDbPath, version: 1);

    // الدمج
    database = CombinedDatabase(defaultDb, userDb);
  }

  static Future<void> close() async {
    await database.defaultDb.close();
    await database.userDb.close();
  }

  ///================= CRUD =================///

  // GET جميع العناصر من القاعدتين
  static Future<List<Map<String, dynamic>>> getUsers(String table) async {
    return await database.query(table);
  }

  // GET عناصر عشوائية
  static Future<List<Map<String, dynamic>>> getRandUsers(String table) async {
    return await database.query(table, orderBy: 'RANDOM()');
  }

  // INSERT على userDb فقط
  // INSERT على userDb فقط
  static Future<void> insertUser(
    String table,
    String choice,
    String dare,
  ) async {
    await database.userDb.insert(table, {'choice': choice, 'dare': dare});
  }

  // UPDATE على القاعدتين حسب الرقم
  // UPDATE عنصر بالindex بعد دمج الاتنين
  static Future<void> updateUser(
    String table,
    String choice,
    String dare,
    int index,
  ) async {
    final defaultCount = Sqflite.firstIntValue(
      await database.defaultDb.rawQuery('SELECT COUNT(*) FROM $table'),
    )!;
    final userCount = Sqflite.firstIntValue(
      await database.userDb.rawQuery('SELECT COUNT(*) FROM $table'),
    )!;

    if (index < defaultCount) {
      // تحديث في defaultDb
      await database.defaultDb.rawUpdate(
        'UPDATE $table SET choice = ?, dare = ? '
        'WHERE ROWID = (SELECT ROWID FROM $table ORDER BY ROWID LIMIT 1 OFFSET ?)',
        [choice, dare, index],
      );
    } else if (index - defaultCount < userCount) {
      // تحديث في userDb
      int userIndex = index - defaultCount;
      await database.userDb.rawUpdate(
        'UPDATE $table SET choice = ?, dare = ? '
        'WHERE ROWID = (SELECT ROWID FROM $table ORDER BY ROWID LIMIT 1 OFFSET ?)',
        [choice, dare, userIndex],
      );
    }
  }

  // GET عنصر محدد بالindex بعد دمج الاتنين
  static Future<Map<String, dynamic>?> getupdateUser(
    String table,
    int index,
  ) async {
    final defaultData = await database.defaultDb.query(table);
    final userData = await database.userDb.query(table);

    final combined = [...defaultData, ...userData];

    if (combined.isNotEmpty && index >= 0 && index < combined.length) {
      return combined[index];
    }
    return null;
  }

  // DELETE على القاعدتين
  static Future<void> deleteUser(String tablee, String index) async {
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

    final defaultCount = Sqflite.firstIntValue(
      await database.defaultDb.rawQuery('SELECT COUNT(*) FROM $tablee'),
    )!;
    final userCount = Sqflite.firstIntValue(
      await database.userDb.rawQuery('SELECT COUNT(*) FROM $tablee'),
    )!;

    if (p2 != null) {
      if (p1 > p2) {
        int temp = p1;
        p1 = p2;
        p2 = temp;
      }
      if (p1 < 0) p1 = 0;

      // حلقات على كل رقم بين p1 و p2
      for (int i = p1; i <= p2; i++) {
        if (i < defaultCount) {
          await database.defaultDb.rawDelete(
            'DELETE FROM $tablee WHERE ROWID = '
            '(SELECT ROWID FROM $tablee ORDER BY ROWID LIMIT 1 OFFSET ?)',
            [i],
          );
        } else if (i - defaultCount < userCount) {
          int userIndex = i - defaultCount;
          await database.userDb.rawDelete(
            'DELETE FROM $tablee WHERE ROWID = '
            '(SELECT ROWID FROM $tablee ORDER BY ROWID LIMIT 1 OFFSET ?)',
            [userIndex],
          );
        }
      }
    } else {
      if (p1 < 0) p1 = 0;

      if (p1 < defaultCount) {
        await database.defaultDb.rawDelete(
          'DELETE FROM $tablee WHERE ROWID = '
          '(SELECT ROWID FROM $tablee ORDER BY ROWID LIMIT 1 OFFSET ?)',
          [p1],
        );
      } else if (p1 - defaultCount < userCount) {
        int userIndex = p1 - defaultCount;
        await database.userDb.rawDelete(
          'DELETE FROM $tablee WHERE ROWID = '
          '(SELECT ROWID FROM $tablee ORDER BY ROWID LIMIT 1 OFFSET ?)',
          [userIndex],
        );
      }
    }
  }

  // GET عنصر عشوائي
  static Future<Map<String, dynamic>?> getRandomUser(String table) async {
    final result = await database.query(table);
    if (result.isNotEmpty) {
      final rand = Random();
      return result[rand.nextInt(result.length)];
    }
    return null;
  }
}

class CombinedDatabase {
  final Database defaultDb;
  final Database userDb;

  CombinedDatabase(this.defaultDb, this.userDb);

  /// ================= INSERT =================
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    // INSERT بس على userDb
    return userDb.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// ================= UPDATE =================
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    int count = 0;

    try {
      count += await defaultDb.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm,
      );
    } catch (e) {
      print("⚠️ update failed on defaultDb: $e");
    }

    try {
      count += await userDb.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm,
      );
    } catch (e) {
      print("⚠️ update failed on userDb: $e");
    }

    return count;
  }

  /// ================= DELETE =================
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    int count = 0;

    try {
      count += await defaultDb.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      print("⚠️ delete failed on defaultDb: $e");
    }

    try {
      count += await userDb.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      print("⚠️ delete failed on userDb: $e");
    }

    return count;
  }

  /// ================= QUERY =================
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final results = <Map<String, Object?>>[];

    // جلب البيانات من defaultDb
    try {
      results.addAll(
        await defaultDb.query(
          table,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy?.toUpperCase() == "RANDOM()" ? "RANDOM()" : orderBy,
        ),
      );
    } catch (_) {}

    // جلب البيانات من userDb
    try {
      results.addAll(
        await userDb.query(
          table,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy?.toUpperCase() == "RANDOM()" ? "RANDOM()" : orderBy,
        ),
      );
    } catch (_) {}

    // معالجة DISTINCT
    if (distinct == true && columns != null && columns.isNotEmpty) {
      final seen = <String>{};
      results.retainWhere((row) {
        final key = columns.map((c) => row[c].toString()).join('|');
        if (seen.contains(key)) return false;
        seen.add(key);
        return true;
      });
    }

    if (orderBy?.toUpperCase() == "RANDOM()") {
    // Shuffle تاني بعد الدمج
    results.shuffle();
  } else if (orderBy != null && orderBy.isNotEmpty) {
    final parts = orderBy.split(' ');
    final column = parts[0];
    final desc = parts.length > 1 && parts[1].toUpperCase() == 'DESC';
    results.sort((a, b) {
      final aValue = a[column];
      final bValue = b[column];
      int cmp;
      if (aValue is num && bValue is num) {
        cmp = aValue.compareTo(bValue);
      } else {
        cmp = aValue.toString().compareTo(bValue.toString());
      }
      return desc ? -cmp : cmp;
    });
  }

    // // معالجة ORDER BY
    // if (orderBy != null && orderBy.isNotEmpty) {
    //   final parts = orderBy.split(' ');
    //   final column = parts[0];
    //   final desc = parts.length > 1 && parts[1].toUpperCase() == 'DESC';
    //   results.sort((a, b) {
    //     final aValue = a[column];
    //     final bValue = b[column];
    //     int cmp;
    //     if (aValue is num && bValue is num) {
    //       cmp = aValue.compareTo(bValue);
    //     } else {
    //       cmp = aValue.toString().compareTo(bValue.toString());
    //     }
    //     return desc ? -cmp : cmp;
    //   });
    // }

    // تطبيق OFFSET و LIMIT
    final start = offset ?? 0;
    final end = limit != null
        ? (start + limit).clamp(0, results.length)
        : results.length;
    if (start >= results.length) return [];
    return results.sublist(start, end);
  }

  /// ================= RAW QUERY =================
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final results = <Map<String, Object?>>[];
    try {
      results.addAll(await defaultDb.rawQuery(sql, arguments));
    } catch (_) {}
    try {
      results.addAll(await userDb.rawQuery(sql, arguments));
    } catch (_) {}
    return results;
  }

  Future<int> rawInsert(String sql, [List<Object?>? arguments]) =>
      userDb.rawInsert(sql, arguments);
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    int count = 0;
    try {
      count += await defaultDb.rawUpdate(sql, arguments);
    } catch (_) {}
    try {
      count += await userDb.rawUpdate(sql, arguments);
    } catch (_) {}
    return count;
  }

  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    int count = 0;
    try {
      count += await defaultDb.rawDelete(sql, arguments);
    } catch (_) {}
    try {
      count += await userDb.rawDelete(sql, arguments);
    } catch (_) {}
    return count;
  }
}
