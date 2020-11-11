import 'package:litesql_app/pages/model/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal();

  static Database _db;
  String tname = 'plane';
  //Create table in database
  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db;
    }

    //Creatae file in database path
    String path = join(await getDatabasesPath(), 'todo_list.db');

    //Create Table
    _db = await openDatabase(
      path,
      onCreate: (db, int version) {
        db.execute(
            "CREATE TABLE plane(id INTEGER PRIMARY KEY, name TEXT, content TEXT,hours INTEGER)");
      },
      version: 1,
    );

    return _db;
  }

  //insert data to database
  Future<int> insertModel(Model model) async {
    Database db = await createDatabase();

    return db.insert(
      tname,
      model.toMap(),
    );
  }

  //Get all the data from database
  Future<List> query() async {
    Database db = await createDatabase();

    return db.query(tname);
  }

  //Delete data in database
  Future<int> deleteData(int id) async {
    Database db = await createDatabase();

    return db.delete(tname, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Model model) async {
    Database db = await createDatabase();

    return db.update(
      tname,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
