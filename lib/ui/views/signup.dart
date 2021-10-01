import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameCrontoller = TextEditingController();
  final _emailCrontoller = TextEditingController();
  final _passCrontoller = TextEditingController();
  final _addressCrontoller = TextEditingController();

  final  _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar (
          title: Text("Criar Conta"),
          centerTitle: true,

        ),
        body: Form(  //FORM é para validar os campos
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameCrontoller,
                    decoration: InputDecoration(
                        hintText: "Nome Completo"
                    ),

                    validator: (text){
                      if(text.isEmpty) return "Nome inválido!";  //se texto vazio OU não contem arroba
                    },
                  ),
                  SizedBox(height: 16.0),
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
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _addressCrontoller,
                    decoration: InputDecoration(
                        hintText: "Endereço"
                    ),
                    validator: (text){
                      if(text.isEmpty) return "Endereço inválido!";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  ElevatedButton(
                    onPressed: (){
                      /*if(_formKey.currentState.validate()){

                        Map<String, dynamic> userData = {
                          "name": _nameCrontoller.text,
                          "email": _emailCrontoller.text,
                          "address": _addressCrontoller.text

                        }*/

                       /* model.signUp(
                            userData: userData,
                            pass:_passCrontoller.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }*/
                    },
                    child: Text("Criar Conta",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),



        )
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Usúario criado com sucesso"),
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao criar o usuáro!"),
          duration: Duration(seconds: 2),
        )
    );
  }

}

