import 'dart:developer' as developer;
 
import 'package:gov_tongdtkt_tongiao/resource/database/table/filed_common.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_ct_dm_trinhdo_chuyenmon.dart'; 
import 'package:sqflite/sqflite.dart'; 
import 'package:gov_tongdtkt_tongiao/resource/database/database_helper.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider.dart';

class CTDmTrinhDoChuyenMonProvider extends BaseDBProvider<TableCTDmTrinhDoChuyenMon> {
  static final CTDmTrinhDoChuyenMonProvider _singleton =
      CTDmTrinhDoChuyenMonProvider._internal();

  factory CTDmTrinhDoChuyenMonProvider() {
    return _singleton;
  }

  Database? db;

  CTDmTrinhDoChuyenMonProvider._internal();

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<int>> insert(List<TableCTDmTrinhDoChuyenMon> value, String createdAt) async {
    try {
      await db!.delete(tableCTDmTrinhDoCm);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableCTDmTrinhDoCm, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableCTDmTrinhDoCm
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableCTDmTrinhDoCm);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmTrinhDoChuyenMon value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableCTDmTrinhDoCm');
    } catch (e) {
      return null;
    }
  }
}
