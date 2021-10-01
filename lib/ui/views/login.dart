import 'package:flutter/material.dart';
import 'package:re_walls/database_helper/database_helper.dart';
import 'package:re_walls/ui/views/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final _emailCrontoller = TextEditingController();
  final _passCrontoller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final  _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller: _emailCrontoller,
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
                    controller: _passCrontoller,
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
                        if(_emailCrontoller.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Insira seu e-mail para recuperação"),
                                duration: Duration(seconds: 2),
                              )
                          );
                        else{
                          //model.recoverPass(_emailCrontoller.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Confira seu e-mail"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: 2),
                              )
                          );
                        }
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
                      /*model.signIn(
                          email: _emailCrontoller.text,
                          pass: _passCrontoller.text,
                          onSucess: _onSuccess,
                          onFail: _onFail
                      );*/
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
  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao Entrar!"),
          duration: Duration(seconds: 2),
        )
    );
  }
}

