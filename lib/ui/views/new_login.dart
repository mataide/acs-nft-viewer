import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/ui/views/conectar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _keyCrontollers = TextEditingController();

  Widget _buildChild(){
    if(rest == null){
      return ListView(padding: EdgeInsets.all(16.0),
        children: [
        Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _keyCrontollers,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Insert Public Key",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors
                    .white),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
            ElevatedButton(
            onPressed: () {
              keyMetaMask();//FUNÇÃO QUE TEM QUE IR PARA O WALLET PARA FUNCIONAR OS TESTES TENHO QUE CLICAR 2X NO OK
              if(_keyCrontollers.text == "" && rest == null) {
                final snackBar = SnackBar(content: Text(
                    'Insert a Public Key !'),
                  duration: Duration(seconds: 3),);
                ScaffoldMessenger.of(context).showSnackBar(
                    snackBar);
              }else if (rest!= null) {
                setState(() {
                });
              }else{
                rest = _keyCrontollers.text;
                setState(() {});
              }
              },
              child: Text(
                      "OK",
                    style: TextStyle(fontSize: 16.0),
                    ),
              ),
              ],
              ),
              ),
          SizedBox(height: 20.0,),
          ElevatedButton(
          onPressed: () {
          openMetaMesk();
          },
          child: Text(
            "Wallet Connect", style: TextStyle(fontSize: 20.0),
          ),
          ),
          ]
       );
    }else{
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              "Connected", textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10.0,),
          ElevatedButton(
            onPressed: () {
              rest = null;
              setState(() {
              });
              print(rest);
            },
            child: new Icon(Icons.delete_forever),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();
          return Scaffold(
              backgroundColor: state.primaryColor,
              appBar: AppBar(
                title: Text("Acess Wallet"),
                backgroundColor: state.primaryColor,
                centerTitle: true,
              ),
              body: Form(
                //FORM é para validar os campos
                key: _formKey,
                child: _buildChild(),
              ),
              );
  }
}

