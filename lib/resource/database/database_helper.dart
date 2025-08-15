import 'dart:developer';

import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_cokhong_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_dantoc_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_gioitinh_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_linhvuc_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/tg_dm_loai_tongiao_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'provider/provider.dart';
import 'provider/provider_p07mau.dart';
import 'provider/provider_p08.dart';
import 'provider/provider_p08dm.dart';

class DatabaseHelper {
  static const _databaseVersion = 1;
  static const _databaseName = 'DTKinhTeTonGiao.db';
  final dataProvider = DataProvider();
  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();
  final bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();
  final dmLinhvucProvider = DmLinhvucProvider();

  final diaBanCoSoTonGiaoProvider = DiaBanCoSoTonGiaoProvider();

  final dmTinhTrangHDProvider = DmTinhTrangHDProvider();
  final dmTrangThaiDTProvider = DmTrangThaiDTProvider();
  final dmCoKhongProvider = DmCoKhongProvider();
  final dmDanTocProvider = DmDanTocProvider();
  final dmGioiTinhProvider = DmGioiTinhProvider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  final userInfoProvider = UserInfoProvider();

  ///Phiếu Tôn giáo
  final tgDmCapCongNhanProvider = TGDmCapCongNhanProvider();
  final tgDmLoaiCoSoProvider = TGDmLoaiCoSoProvider();
  final tgDmLoaiHinhTonGiaoProvider = TGDmLoaiHinhTonGiaoProvider();
  final tgDmNangLuongProvider = TGDmNangLuongProvider();
  final tgDmSuDungPhanMemProvider = TGDmSuDungPhanMemProvider();
  final tgDmTrinhDoChuyenMonProvider = TGDmTrinhDoChuyenMonProvider();
  final tgDmXepHangProvider = TGDmXepHangProvider();
  final tgDmXepHangDiTichProvider = TGDmXepHangDiTichProvider();
  final tgDmLoaiTonGiaoProvider = TGDmLoaiTonGiaoProvider();

  final phieuTonGiaoProvider = PhieuTonGiaoProvider();
  final phieuTonGiaoA43Provider = PhieuTonGiaoA43Provider();

  // only have a single app-wide reference to the database
  static Database? _database;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    await createTable(_database!);
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    String path = p.join(await getMyDatabasePath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onUpgrade: (db, int? oldVersion, int? newVersion) async {
        if (newVersion != oldVersion) await deleteAll(db);
        createTable(db);
      },
      onCreate: _onCreateTable,
    );
  }

  // get path location database
  Future<String> getMyDatabasePath() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, _databaseName);
    return path;
  }

  Future<String> getOnlyDatabasePath() async {
    var databasesPath = await getDatabasesPath();
    return databasesPath;
  }

  //delete
  Future deleteDB() async {
    // Delete the database
    await deleteDatabase(await getMyDatabasePath());
  }

  // close
  Future closeDB() async {
    // Close the database
    await _database?.close();
  }

  Future _onCreateTable(Database db, int databaseVersion) async {
    log('onCreated table');
    // todo: create table when start app if not exist db
  }

  Future createTable(Database db) async {
    log('BEGIN::createTable', name: 'DatabaseHelper');
    await Future.wait([
      dataProvider.onCreateTable(db),
      doiTuongDieuTraProvider.onCreateTable(db),
      userInfoProvider.onCreateTable(db),
      bkCoSoTonGiaoProvider.onCreateTable(db),
      dmMotaSanphamProvider.onCreateTable(db),
      dmLinhvucProvider.onCreateTable(db),
      diaBanCoSoTonGiaoProvider.onCreateTable(db),
      dmTinhTrangHDProvider.onCreateTable(db),
      dmTrangThaiDTProvider.onCreateTable(db),
      dmCoKhongProvider.onCreateTable(db),
      dmDanTocProvider.onCreateTable(db),
      dmGioiTinhProvider.onCreateTable(db),
      xacNhanLogicProvider.onCreateTable(db)
    ]);

    // Dm phieu tôn giáo

    await Future.wait([
      tgDmCapCongNhanProvider.onCreateTable(db),
      tgDmLoaiCoSoProvider.onCreateTable(db),
      tgDmLoaiHinhTonGiaoProvider.onCreateTable(db),
      tgDmNangLuongProvider.onCreateTable(db),
      tgDmSuDungPhanMemProvider.onCreateTable(db),
      tgDmTrinhDoChuyenMonProvider.onCreateTable(db),
      tgDmXepHangProvider.onCreateTable(db),
      tgDmXepHangDiTichProvider.onCreateTable(db),
      tgDmLoaiTonGiaoProvider.onCreateTable(db)
    ]);

    // phieu tôn giáo

    await Future.wait([
      phieuTonGiaoProvider.onCreateTable(db),
      phieuTonGiaoA43Provider.onCreateTable(db),
    ]);

    log('END::Create all table compelete');
  }

  Future deleteAll(Database db) async {
    log('BEGIN::deleteAll table', name: 'DatabaseHelper');

    await dataProvider.deletedTable(db);
    await doiTuongDieuTraProvider.deletedTable(db);
    await userInfoProvider.deletedTable(db);
    await bkCoSoTonGiaoProvider.deletedTable(db);

    await dmMotaSanphamProvider.deletedTable(db);
    await dmLinhvucProvider.deletedTable(db);

    await diaBanCoSoTonGiaoProvider.deletedTable(db);
    // await dmTongHopKQProvider.deletedTable(db);
    await xacNhanLogicProvider.deletedTable(db);

    await dmTinhTrangHDProvider.deletedTable(db);
    await dmTrangThaiDTProvider.deletedTable(db);
    await dmCoKhongProvider.deletedTable(db);
    await dmDanTocProvider.deletedTable(db);
    await dmGioiTinhProvider.deletedTable(db);

    // DM phieu ton giao
    await tgDmCapCongNhanProvider.deletedTable(db);
    await tgDmLoaiCoSoProvider.deletedTable(db);
    await tgDmLoaiHinhTonGiaoProvider.deletedTable(db);
    await tgDmNangLuongProvider.deletedTable(db);
    await tgDmSuDungPhanMemProvider.deletedTable(db);
    await tgDmTrinhDoChuyenMonProvider.deletedTable(db);
    await tgDmXepHangProvider.deletedTable(db);
    await tgDmXepHangDiTichProvider.deletedTable(db);
    await tgDmLoaiTonGiaoProvider.deletedTable(db);
    await phieuTonGiaoProvider.deletedTable(db);
    await phieuTonGiaoA43Provider.deletedTable(db);

    // phieu ton giao
    await phieuTonGiaoProvider.deletedTable(db);
    await phieuTonGiaoA43Provider.deletedTable(db);

    log('END::deleteAll table compelete');
    createTable(db);
  }

  ///DÙNG CHO LẤY DỮ LIỆU PHỎNG VẤN KHI NHẤN NÚT LẤY DỮ LIỆU PHỎNG VẤN : Chỉ tạo các talbe dữ liệu
  Future createOnlyDataTable(Database db) async {
    log('BEGIN::createDataTable', name: 'DatabaseHelper');
    await Future.wait([
      dataProvider.onCreateTable(db),
      doiTuongDieuTraProvider.onCreateTable(db),
      userInfoProvider.onCreateTable(db),
      bkCoSoTonGiaoProvider.onCreateTable(db),

      diaBanCoSoTonGiaoProvider.onCreateTable(db),
      // dmTongHopKQProvider.onCreateTable(db),
      xacNhanLogicProvider.onCreateTable(db)
    ]);

    // phieu 08

    await Future.wait([
      phieuTonGiaoProvider.onCreateTable(db),
      phieuTonGiaoA43Provider.onCreateTable(db)
    ]);

    log('END::Create all table compelete');
  }

  ///DÙNG CHO LẤY DỮ LIỆU PHỎNG VẤN KHI NHẤN NÚT LẤY DỮ LIỆU PHỎNG VẤN : Chỉ delete các table dữ liệu
  Future deleteOnlyDataTable(Database db) async {
    log('BEGIN::deleteDataTableAll table', name: 'DatabaseHelper');

    await dataProvider.deletedTable(db);
    await doiTuongDieuTraProvider.deletedTable(db);
    await userInfoProvider.deletedTable(db);
    await bkCoSoTonGiaoProvider.deletedTable(db);
    await diaBanCoSoTonGiaoProvider.deletedTable(db);
    //  await dmTongHopKQProvider.deletedTable(db);
    await xacNhanLogicProvider.deletedTable(db);

    // phieu 05
    phieuTonGiaoProvider.deletedTable(db);
    phieuTonGiaoA43Provider.deletedTable(db);

    log('END::deleteAll table compelete');
    createOnlyDataTable(db);
  }
}
