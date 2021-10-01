import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_walls/core/utils/models/user_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';


class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = 'user';
  String colId ='id';
  String colName = 'name';
  String coladdress = 'address';
  String colState= 'state';
  String colCity = 'city';
  String colCountry = 'country';
  String colEmail = 'email';


  //CONSTRUTOR PARA CRIAR INSTANCIA DA CLASSE
  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async {
    //ESCOLHENDO ONDE SALVAR O BANCO DE DADOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'user.db';
      //CRIANDO O BANCO DE DADOS
    var userDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }
   void _createDb(Database db, int newVersion) async {
  await db.execute('CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$colName TEXT, ''$coladdress TEXT, $colState TEXT, $colCity TEXT, $colCountry TEXT, '
      '$colEmail TEXT)');
   }
  //INCLUIR USER NO BANCO DE DADOS
  Future<int> insertUser(User user) async{

    Database db = await this.database;
    var result = await db.insert(userTable, user.toMap());
    return result;

}
  //RETORNANDO UM CONTATO
  Future<User> getUser(int id) async {

    Database db = await this.database;

    List<Map> maps = await db.query(userTable,
    columns: [colId, colName, coladdress,colState,colCity,colCountry, colEmail ],
    where: "$colId = ?",whereArgs: [id]);

    if(maps.length > 0){
      return User.fromMap(maps.first);
    }else{
      return null;
    }
  }
  //ATUALIZAR USUARIO
  Future<int> updateUser (User user) async {

    var db =  await this.database;

    var result =
        await db.update(userTable, user.toMap(),
        where: '$colId = ?',
          whereArgs: [user.id]);

    return result;
  }
  //DELETAR USUARIO
  Future<int> deleteUser(int id) async {
    var db =  await this.database;

    int result =
        await db.delete(userTable,
        where: "$colId = ?",
        whereArgs: [id]);
    return result;
  }
//OBTENDO NUMERO DE USUARIOS
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $userTable');

    int result = Sqflite.firstIntValue(x);
    return result;
  }
  //FECHANDO O BANCO DE DADOS
Future close() async {
    Database db = await this.database;
    db.close();
}


}