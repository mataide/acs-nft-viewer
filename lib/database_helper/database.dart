import 'dart:async';
import 'package:NFT_View/core/dao/index.dart';
import 'package:NFT_View/core/models/index.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Eth721,Collections])
abstract class FlutterDatabase extends FloorDatabase {
  Eth721DAO get eth721DAO;
  CollectionsDAO get collectionsDAO;
}