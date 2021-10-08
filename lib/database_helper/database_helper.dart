import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:NFT_View/core/utils/models/user_models.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {

  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  // DatabaseHelper con = new DatabaseHelper();
  bool isLoading = false;
  String userTable = 'user';
  String colId = 'id';
  String colName = 'name';
  String colPassword = 'passoword';
  String coladdress = 'address';
  String colState = 'state';
  String colCity = 'city';
  String colCountry = 'country';
  String colEmail = 'email';


  //CONSTRUTOR PARA CRIAR INSTANCIA DA CLASSE
  DatabaseHelper._createInstance();

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //ESCOLHENDO ONDE SALVAR O BANCO DE DADOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'user.db';
    //CRIANDO O BANCO DE DADOS
    var userDatabase = await openDatabase(
        path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colName TEXT, $colEmail,''$colPassword TEXT, $coladdress TEXT, $colCity TEXT, $colState TEXT, '
            '$colCountry TEXT)');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await (instance.database as FutureOr<Database>);
    return await db.insert(userTable, row);
  }

  //Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await (instance.database as FutureOr<Database>);
    return await db.query(userTable);
  }
}