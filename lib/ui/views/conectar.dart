
import 'package:NFT_View/database_helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

  var name = String;
  var result;
  final dbHelper = DatabaseHelper.instance;
  bool test = false;

  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
      test = true;
      print('Connected....');
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
    if (test == true){
      result = await platform.invokeMethod('keyApproved', null);
      inserir();
    }
  }
/*keyMetaMask() async {
  const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
  try {
    result = await platform.invokeMethod('keyApproved', null);
    inserir();
  } on PlatformException catch (e) {
    print("Failed to initWalletConnection: '${e.message}'.");
  }
}*/

inserir() async {
  if(result != ""){
    Map<String, dynamic> row = {
      DatabaseHelper.instance.colName : result.toString(),
    };
//final id = await dbHelper.insert(row);
//print('linha inserida id: $id');
    final name = await dbHelper.insert(row);
    print(name);
// final todasLinhas = await dbHelper.queryAllRows();
// print('Consulta todas as linhas:');
// todasLinhas.forEach((row) => print(row));
  }else{
    print("ERRO");
  }
}