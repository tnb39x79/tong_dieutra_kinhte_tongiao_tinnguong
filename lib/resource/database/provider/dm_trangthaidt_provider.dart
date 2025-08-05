import 'dart:developer' as developer;

import 'package:gov_tongdtkt_tongiao/resource/database/table/filed_common.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_trangthaidt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_tongdtkt_tongiao/common/common.dart';

import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/database_helper.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider.dart';

class DmTrangThaiDTProvider extends BaseDBProvider<TableDmTrangThaiDT> {
  static final DmTrangThaiDTProvider _singleton =
      DmTrangThaiDTProvider._internal();

  factory DmTrangThaiDTProvider() {
    return _singleton;
  }

  Database? db;

  DmTrangThaiDTProvider._internal();

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
  Future<List<int>> insert(
      List<TableDmTrangThaiDT> value, String createdAt) async {
    try {
      await db!.delete(tableDmTrangThaiDT);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableDmTrangThaiDT, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmTrangThaiDT
      (
        $columnDmTrangThaiDTId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmTrangThaiDTMaTrangThaiDT INTEGER,
        $columnDmTrangThaiDTTenTrangThaiDT TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDmTrangThaiDT);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmTrangThaiDT value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmTrangThaiDT');
    } catch (e) {
      return null;
    }
  }
}
