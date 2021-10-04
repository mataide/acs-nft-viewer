import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_walls/core/utils/models/user_models.dart';
import 'package:re_walls/core/utils/theme.dart';
import 'package:re_walls/ui/views/login_presenter.dart';
import 'package:re_walls/ui/views/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginContract {


  String _email, _password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _ctx;
  bool _isLoading = false;
  final  _formKey = GlobalKey<FormState>();
  LoginPagePresenter _presenter;

  _LoginState() {
    _presenter = new LoginPagePresenter(this);
  }

  void _register() {
    Navigator.of(context).pushNamed("/register");
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _presenter.doLogin(_email, _password);
      });
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();
    return Scaffold(
      backgroundColor: state.primaryColor,
        key: _scaffoldKey,
        appBar: AppBar (
          title: Text("Entrar"),
          centerTitle: true,
          actions: [
            FlatButton(
              onPressed:(){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>SignUp())
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
        body: Form(  //FORM é para validar os campos
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    onSaved: (val) => _email = val,
                    decoration: InputDecoration(
                        hintText: "E-mail"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";  //se texto vazio OU não contem arroba
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    onSaved: (val) => _password = val,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true, //PARA NÃO MOSTRAR A SENHA
                    validator: (text){
                      if(text.isEmpty || text.length < 6) return "Senha inválida!";
                    },
                    keyboardType: TextInputType.number,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: (){
                        //CRIAR RECUPERAÇÃO DA SENHA
                      },
                      child: Text("Esqueci minha senha",
                          textAlign: TextAlign.right),
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  //ElevatedButton(
                  RaisedButton(
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                      }
                      _submit();
                    },
                    child: Text("Entrar",
                      style: TextStyle(fontSize: 18.0),
                    ),

                  )
                ],
              ),
            ),

        );
  }
  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar("Login not successful");
    setState(() {
      _isLoading = false;
    });
  }
  @override
  void onLoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    if(user.email == ""){
      _showSnackBar("Login not successful");
    }else{
      _showSnackBar(user.toString());
      Navigator.of(context).pushNamed("/home");
    }
    setState(() {
      _isLoading = true;
    });

  }
}