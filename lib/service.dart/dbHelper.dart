import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitecrud/models/contact.dart';

class Dbhelper {
  static Database? _database;

  Dbhelper._createObject();

  static final Dbhelper _dbhelper = Dbhelper._createObject();

  factory Dbhelper() {
    return _dbhelper;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/contact.db";
    var contactDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return contactDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute("""CREATE TABLE contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        phone TEXT
      )""");
  }

  //cek database
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }

  //read single contact
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await database;
    var hasil = db.query("contact", orderBy: "nama");
    return hasil;
  }

  //get all Data contact
  Future<List<Contact>> getAllData() async {
    var hasilData = await select();
    List<Contact> resultHasil = [];
    for (var element in hasilData) {
      resultHasil.add(Contact.fromJson(element));
    }
    return resultHasil;
  }

  //keyword search
  Future<List<Contact>> searchKeyword(String keyword) async {
    Database db = await database;
    var result = await db.query(
      "contact",
      where: "nama LIKE?",
      whereArgs: ["%$keyword%"],
      orderBy: "nama",
    );
    return result.map((e) => Contact.fromJson(e)).toList();
  }

  //create contact
  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    var count = await db.insert("contact", contact.toJson());
    return count;
  }

  //update contact
  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    var count = await db.update(
      "contact",
      contact.toJson(),
      where: "id=?",
      whereArgs: [contact.id],
    );
    return count;
  }

  //delete contact
  Future<int> deleteContact(int id) async {
    Database db = await database;
    var count = db.delete("contact", where: "id=?", whereArgs: [id]);
    return count;
  }
}
