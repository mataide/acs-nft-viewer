import 'package:NFT_View/ui/views/conectar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/database_helper/database_helper.dart';
import 'package:NFT_View/core/models/user_models.dart';
import 'package:NFT_View/ui/views/login.dart';
import 'package:sqflite/sqflite.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  final _nameCrontoller = result();


  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();

    return Scaffold(
        backgroundColor: state.primaryColor,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,

        ),
        body: Form( //FORM é para validar os campos
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              TextFormField(
                controller: _nameCrontoller,
                decoration: InputDecoration(
                    hintText: "Nome Completo"
                ),
                validator: (text) {
                  if (text!.isEmpty)
                    return "Nome inválido!"; //se texto vazio OU não contem arroba
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed:(){ _inserir();},
                child: Text("Criar Conta",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          ),
        )
    );
  }

  // métodos dos Buttons
  void _inserir() async {
    // linha para incluir
    Map<String, dynamic> row = {
      DatabaseHelper.instance.colName : _nameCrontoller.text,
    };
    final id = await dbHelper.insert(row);
    print('linha inserida id: $id');
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Usúario criado com sucesso"),
          duration: Duration(seconds: 2),
        ));
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> Login())
      );
    });
  }

}