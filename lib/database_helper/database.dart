import 'dart:async';
import 'package:NFT_View/core/models/eth721.dart';
import 'package:NFT_View/core/dao/eth721.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Eth721])
abstract class FlutterDatabase extends FloorDatabase {
  Eth721Dao get eth721Dao;
}