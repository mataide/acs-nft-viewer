// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:NFT_View/core/utils/models/user_models.dart';
import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/ui/views/home.dart';
import 'package:NFT_View/ui/views/signup.dart';
import 'package:NFT_View/database_helper/database_helper.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final dbHelper = DatabaseHelper.instance;
  final _passCrontollers = TextEditingController();
  final _emailCrontollers = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext? _ctx;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();
    return Scaffold(
      backgroundColor: state.primaryColor,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(
                  fontSize: 15.0
              ),
            ),
            textColor: Colors.white,
          )
        ],
      ),
      body: Form( //FORM é para validar os campos
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _emailCrontollers,
              decoration: InputDecoration(
                  hintText: "E-mail"
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text!.isEmpty || text.length < 6)
                  return "E-mail inválido!"; //se texto vazio OU não contem arroba
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passCrontollers,
              decoration: InputDecoration(
                  hintText: "Senha"
              ),
              obscureText: true,
              //PARA NÃO MOSTRAR A SENHA
              validator: (text) {
                if (text!.isEmpty || text.length < 6) return "Senha inválida!";
              },
              keyboardType: TextInputType.number,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  //CRIAR RECUPERAÇÃO DA SENHA
                },
                child: Text("Esqueci minha senha",
                    textAlign: TextAlign.right),
              ),
            ),
            SizedBox(height: 16.0,),
            //ElevatedButton(
            RaisedButton(
              onPressed: () {  },
              child: Text("Entrar",
                style: TextStyle(fontSize: 18.0),
              ),

            )
          ],
        ),
      ),

    );
  }
 /* void rawQuery() async {
    final queryResult = await dbHelper.rawQuery('query', null);
    print('Consulta todas as linhas:');
    //todasLinhas.forEach((row) => print(row));
    queryResult.forEach((row) => print(row));
    setState(() {});
  }*/
}