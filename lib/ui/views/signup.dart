import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/theme.dart';
import 'package:re_walls/database_helper/database_helper.dart';
import 'package:re_walls/core/utils/models/user_models.dart';
import 'package:re_walls/ui/views/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String _name, _email, _pass, _address,  _city,_state, _country;

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
                onSaved: (val) => _name = val,
                decoration: InputDecoration(
                    hintText: "Nome Completo"
                ),
                validator: (text) {
                  if (text.isEmpty)
                    return "Nome inválido!"; //se texto vazio OU não contem arroba
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onSaved: (val) => _email = val,
                decoration: InputDecoration(
                    hintText: "E-mail"
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "E-mail inválido!"; //se texto vazio OU não contem arroba
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onSaved: (val) => _pass = val,
                decoration: InputDecoration(
                    hintText: "Senha"
                ),
                obscureText: true,
                //PARA NÃO MOSTRAR A SENHA
                validator: (text) {
                  if (text.isEmpty || text.length < 6) return "Senha inválida!";
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                onSaved: (val) => _address = val,
                decoration: InputDecoration(
                    hintText: "Endereço"
                ),
                validator: (text) {
                  if (text.isEmpty) return "Endereço inválido!";
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                onSaved: (val) => _city = val,
                decoration: InputDecoration(
                    hintText: "Cidade"
                ),
                validator: (text) {
                  if (text.isEmpty) return "Cidade Inválida!";
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                onSaved: (val) => _state = val,
                decoration: InputDecoration(
                    hintText: "Estado"
                ),
                validator: (text) {
                  if (text.isEmpty) return "Estado inválido!";
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                onSaved: (val) => _pass = val,
                decoration: InputDecoration(
                    hintText: "País"
                ),
                validator: (text) {
                  if (text.isEmpty) return "País inválido!";
                },
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Criar Conta",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          ),

        )
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> Login()));
        var user = new User(
            null,
            _name,
            _email,
            _pass,
            _address,
            _state,
            _city,
            _country);
        var db = new DatabaseHelper();
        db.insertUser(user);
        _isLoading = false;

      });
    }
  }

}