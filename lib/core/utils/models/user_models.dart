
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User {

  int id;
  String password;
  String name;
  String address;
  String state;
  String city;
  String country;
  String email;

  User(this.id,this.password ,this.name, this.address, this.state, this.city, this.country, this.email);


  //CONVERTENDO OS DADOS EM MAPA
  Map<String, dynamic> toMap(){

    var map = <String, dynamic>{
      'id':id,
      'password': password,
      'name': name,
      'address': address,
      'state': state,
      'city': city,
      'country': country,
      'email': email,

    };

    return map;
  }
  //PROCESSO INVERSO
  User.fromMap(Map<String, dynamic> map){
  id = map['id'];
  password = map['password'];
  name = map['name'];
  address = map['address'];
  state = map['state'];
  city = map['city'];
  country = map['country'];
  email = map['email'];


  }


}