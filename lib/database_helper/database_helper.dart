import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:re_walls/core/utils/models/user_models.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = 'user';
  String colId ='id';
  String colName = 'name';
  String colPassword = 'passoword';
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
      '$colName TEXT, $colPassword,''$coladdress TEXT, $colCity TEXT, $colState TEXT, $colCountry TEXT, '
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
    columns: [colId,colPassword, colName, coladdress,colCity,colState,colCountry, colEmail ],
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
//SELECIONANDO USUARIOS
  Future<User> selectUser(User user) async {
    var dbClient = await this.database;
    List<Map<String, dynamic>> maps = await dbClient.query(userTable,
        columns: [colEmail, colPassword],
        where: "$colEmail = ? and $colPassword = ?",
        whereArgs: [user.email, user.password]);
    print(maps);
    if (maps.length > 0) {
      print("User Exist !!!");
      return user;
    } else {
      return null;
    }
  }
  //FECHANDO O BANCO DE DADOS
Future close() async {
    Database db = await this.database;
    db.close();
}


}