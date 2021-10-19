
import 'package:flutter/services.dart';

  var result;
 // final dbHelper = DatabaseHelper.instance;

  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
      print('Connected....');
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
  }
  keyMetaMask() async {
  const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
  try {
    result = await platform.invokeMethod('keyApproved', null);
    //inserir();
  } on PlatformException catch (e) {
    print("Failed to initWalletConnection: '${e.message}'.");
  }
}

/*inserir() async {
  if(result != ""){
    Map<String, dynamic> row = {
      DatabaseHelper.instance.colName : result.toString(),
    };
      final id = await dbHelper.insert(row);
      print('linha inserida id: $id');
      final name = await dbHelper.insert(row);
       print(name);
// final todasLinhas = await dbHelper.queryAllRows();
// print('Consulta todas as linhas:');
// todasLinhas.forEach((row) => print(row));
  }else{
    print("ERRO");
  }
}*/