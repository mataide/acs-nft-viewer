import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/database_helper/database_helper.dart';
import 'package:NFT_View/core/utils/models/user_models.dart';
import 'package:NFT_View/ui/views/login.dart';
import 'package:sqflite/sqflite.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _emailCrontoller = TextEditingController();
  final _nameCrontoller = TextEditingController();
  final _passCrontoller = TextEditingController();
  final _addressCrontoller = TextEditingController();
  final _cityCrontoller = TextEditingController();
  final _stateCrontoller = TextEditingController();
  final _countryCrontoller = TextEditingController();

  final dbHelper = DatabaseHelper.instance;
  bool _isLoading = false;
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
              TextFormField(
                controller: _emailCrontoller,
                decoration: InputDecoration(
                    hintText: "E-mail"
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text!.isEmpty || !text.contains("@"))
                    return "E-mail inválido!"; //se texto vazio OU não contem arroba
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passCrontoller,
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
              SizedBox(height: 16.0,),
              TextFormField(
                controller: _addressCrontoller,
                decoration: InputDecoration(
                    hintText: "Endereço"
                ),
                validator: (text) {
                  if (text!.isEmpty) return "Endereço inválido!";
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                controller: _cityCrontoller,
                decoration: InputDecoration(
                    hintText: "Cidade"
                ),
                validator: (text) {
                  if (text!.isEmpty) return "Cidade Inválida!";
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                controller: _stateCrontoller,
                decoration: InputDecoration(
                    hintText: "Estado"
                ),
                validator: (text) {
                  if (text!.isEmpty) return "Estado inválido!";
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                controller: _countryCrontoller,
                decoration: InputDecoration(
                    hintText: "País"
                ),
                validator: (text) {
                  if (text!.isEmpty) return "País inválido!";
                },
              ),
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
    DatabaseHelper.instance.colEmail : _emailCrontoller.text,
    DatabaseHelper.instance.colCountry: _countryCrontoller.text,
    DatabaseHelper.instance.colCity : _cityCrontoller.text,
    DatabaseHelper.instance.colPassword: _passCrontoller.text,
    DatabaseHelper.instance.colState: _stateCrontoller.text,
    DatabaseHelper.instance.coladdress: _addressCrontoller.text,
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