import 'dart:async';
import 'package:re_walls/core/utils/models/user_models.dart';
import 'package:re_walls/database_helper/database_helper.dart';


class RestData {
  static final BASE_URL = "";
  static final LOGIN_URL = BASE_URL + "/";

  Future<User> login( String name, String password, String address,
      String state, String city, String country,String email) async {
    String flagLogged = "logged";
    //simulate internet connection by selecting the local database to check if user has already been registered
    var user = new User(null,password,name,null,null,null,null,email);
    var db = new DatabaseHelper();
    var userRetorn = new User(null,null,null,null, null,null,null,null);
    userRetorn = await db.selectUser(user);
    if(userRetorn != null){
      flagLogged = "logged";
      return new Future.value(new User(null, name, password,address, city,state,country,email));
    }else {
      flagLogged = "not";
      return new Future.value(new User(null, name, password, address, city,state,country,email));
    }
  }
}