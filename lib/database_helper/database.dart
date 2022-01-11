import 'dart:async';
import 'package:faktura_nft_viewer/core/dao/index.dart';
import 'package:faktura_nft_viewer/core/models/AttributesConverter.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@TypeConverters([AttributesConverter])
@Database(version: 1, entities: [Eth721,Collections, CollectionsItem])
abstract class FlutterDatabase extends FloorDatabase {
  Eth721DAO get eth721DAO;
  CollectionsDAO get collectionsDAO;
  CollectionsItemDAO get collectionsItemDAO;
}