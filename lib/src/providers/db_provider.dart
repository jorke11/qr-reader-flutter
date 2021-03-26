import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_reader/src/models/scan_model.dart';
export 'package:qr_reader/src/models/scan_model.dart';



class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, verion) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

  nuevoScanRaw(ScanModel scanModel) async {
    final db = await database;

    print(scanModel.toString());

    int res = await db.rawInsert("INSERT INTO Scans (id, tipo,valor) "
        "VALUES (${scanModel.id},'${scanModel.tipo}','${scanModel.valor}')");
    return res;
  }

  nuevoScan(ScanModel scanModel) async {
    final db = await database;
    final res = db.insert('Scans', scanModel.toJson());
    // db.transaction((txn)  async{
    //     int id1 = await txn.rawInsert(
    //   'INSERT INTO Scans(tipo, valor) VALUES("some name", "asdsa")');
    //   print('inserted1: $id1');
    
    // });
    
    return res;
  }

  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScan() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> lista =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return lista;
  }


  Future<List<ScanModel>> getScanTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = ${tipo} ");

    List<ScanModel> lista =
        res.isEmpty ? res.map((c) => ScanModel.fromJson(c)).toString() : [];

    return lista;
  }

  Future<int> updateScan(ScanModel scanModel) async{
    final db = await database;
    final res = await db.update("Scans", scanModel.toJson(),where: 'id=?',whereArgs: [scanModel.id]);
    return res;
  } 
  Future<int> deleteScan(int id) async{
    final db = await database;
    final res = await db.delete("Scans",where: 'id=?',whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async{
    final db = await database;
    final res = await db.rawDelete("DELETE FROM Scans");
    return res;
  }


}
