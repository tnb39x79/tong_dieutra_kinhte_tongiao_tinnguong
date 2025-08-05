import 'dart:developer' as developer;
 
import 'package:gov_tongdtkt_tongiao/resource/database/table/filed_common.dart'; 
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_tg_dm_loai_tongiao.dart';
 
import 'package:sqflite/sqflite.dart';
import 'package:gov_tongdtkt_tongiao/common/common.dart';

import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/database_helper.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider.dart';

class TGDmLoaiTonGiaoProvider extends BaseDBProvider<TableDmLoaiTonGiao> {
  static final TGDmLoaiTonGiaoProvider _singleton =
      TGDmLoaiTonGiaoProvider._internal();

  factory TGDmLoaiTonGiaoProvider() {
    return _singleton;
  }

  Database? db;

  TGDmLoaiTonGiaoProvider._internal();

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
  Future<List<int>> insert(List<TableDmLoaiTonGiao> value, String createdAt) async {
    try {
      await db!.delete(tableDmLoaiTonGiao);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableDmLoaiTonGiao, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmLoaiTonGiao
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableDmLoaiTonGiao);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmLoaiTonGiao value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmLoaiTonGiao');
    } catch (e) {
      return null;
    }
  }
}
