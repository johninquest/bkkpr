import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'dart:io';

class SQLiteDatabaseHelper {
  final String dbName = 'transporter.db';
  final int schemaVersion = 1;
  final String bkTable = 'bookkeeping';
  final String pTable = 'person';
  final String vTable = 'vehicle';

  Future<Database> initializeDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, dbName);
    var dbOpened = await openDatabase(dbPath, onCreate: (db, version) async {
      String sql = '''
      CREATE TABLE IF NOT EXISTS $bkTable (
	    "id"	INTEGER NOT NULL UNIQUE,
	    "category"	TEXT,
	    "source"	TEXT,
	    "amount"	TEXT,
	    "created_at"	TEXT,
	    "last_update_at"	TEXT,
	    PRIMARY KEY("id" AUTOINCREMENT)
      );

      CREATE TABLE IF NOT EXISTS $pTable (
	    "id"	INTEGER NOT NULL UNIQUE,
	    "first_name"	TEXT,
	    "last_name"	TEXT,
	    "role"	TEXT,
	    "phone"	TEXT,
	    "email"	TEXT,
	    "created_at"	TEXT,
	    "last_update_at"	TEXT,
	    PRIMARY KEY("id" AUTOINCREMENT)
      );

      CREATE TABLE IF NOT EXISTS $vTable (
	    "id"	INTEGER NOT NULL UNIQUE,
	    "plate_number"	TEXT,
	    "manufacturer"	TEXT,
	    "model"	TEXT,
	    "mileage"	TEXT,
    	"first_registration"	TEXT,
	    "created_at"	TEXT,
	    "last_update_at"	TEXT,
	    PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';
      await db.execute(sql);
    }, version: schemaVersion);
    return dbOpened;
  }

  Future insertRow(String tCategory, String tSource, String tAmount) async {
    final Database? db = await initializeDB();
    if (db != null) {
      List qData = ["$tCategory", "$tSource", "$tAmount"];
      String sql =
          '''INSERT INTO $bkTable (category, source, amount, created_at) VALUES (?, ?, ?, datetime('now', 'localtime'))''';
      List<Map> qResult = await db.rawQuery(sql, qData);
      print(qResult);
      return qResult;
    } else {
      print('SQL SELECT query returned an error!');
    }
  }

  Future getAllRows() async {
    final Database? db = await initializeDB();
    if (db != null) {
      String sql = 'SELECT * FROM $bkTable ORDER BY created_at DESC';
      final qResult = await db.rawQuery(sql);
      return qResult.toList();
    } else {
      print('SQL SELECT query returned an error!');
    }
  }
}
