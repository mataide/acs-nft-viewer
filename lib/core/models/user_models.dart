
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User {




  int? id;
  String? password;
  String? name;
  String? address;
  String? state;
  String? city;
  String? country;
  String? email;

  User(this.id,this.password ,this.name, this.address, this.state, this.city, this.country, this.email);


  //CONVERTENDO OS DADOS EM MAPA
  Map<String, dynamic> toMap(){

    var map = <String, dynamic>{
      'id':id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'city': city,
      'state': state,
      'country': country,


    };

    return map;
  }
  //PROCESSO INVERSO
  User.fromMap(Map<String, dynamic> map){
  id = map['id'];
  name = map['name'];
  email = map['email'];
  password = map['password'];
  address = map['address'];
  city = map['city'];
  state = map['state'];
  country = map['country'];


  }

}