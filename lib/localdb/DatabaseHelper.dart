import 'package:flutter_app_test/model/doctorcontact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "record.db";
  static final _databaseVersion = 1;

  static final table = 'doctor';
  static final id = 'id';
  static final firstName = 'first_name';
  static final lastName = 'last_name';
  static final profilePic = 'profile_pic';
  static final favourite = 'favorite';
  static final primaryContactNo = 'primary_contact_no';
  static final rating = 'rating';
  static final emailAddress = 'email_address';
  static final qualification = 'qualification';
  static final description = 'description';
  static final specialization = 'specialization';
  static final languageKnown = 'languagesKnown';
  static final dob = 'dob';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ("
        "$id INTEGER PRIMARY KEY,"
        "$firstName TEXT,"
        "$lastName TEXT,"
        "$profilePic TEXT,"
        "$favourite INTEGER DEFAULT 0,"
        "$primaryContactNo TEXT,"
        "$rating TEXT,"
        "$emailAddress TEXT,"
        "$qualification TEXT,"
        "$description TEXT"
        "$specialization TEXT,"
        "$languageKnown TEXT,"
        "$dob TEXT"
        ")");
  }

  Future<int> insert(DoctorContact doctorContact) async {
    Database db = await instance.database;
    var res = await db.insert(table, doctorContact.toJson());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnId DESC");
    return res;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}
