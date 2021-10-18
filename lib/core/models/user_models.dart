
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User {




  int? id;
  String? name;


  User(this.id,this.name);


  //CONVERTENDO OS DADOS EM MAPA
  Map<String, dynamic> toMap(){

    var map = <String, dynamic>{
      'id':id,
      'name': name,//name vai ser usada para keyMetaMask
    };

    return map;
  }
  //PROCESSO INVERSO
  User.fromMap(Map<String, dynamic> map){
  id = map['id'];
  name = map['name'];

  }

}