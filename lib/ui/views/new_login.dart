import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/ui/views/conectar.dart';
import 'package:NFT_View/ui/views/logged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BuildContext? _ctx;
  final _formKey = GlobalKey<FormState>();
  final _keyCrontollers = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _ctx = context;
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
          child: ListView(padding: EdgeInsets.all(16.0),
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
                        hintStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                      ),
                      validator: (text) {
                        if (text!.isEmpty || text.length < 21)
                          return "Invalid Public Key!"; //
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                   ElevatedButton(
                      onPressed: () {
                      keyMetaMask();
                      if(result != "")
                        {
                          print(result);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Logged()));
                        }
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 16.0),
                      ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            ElevatedButton(
                onPressed: (){
                  openMetaMesk();
                },
                child: Text("Wallet Connect", style: TextStyle(fontSize: 20.0),
                ),
            )
          ]),
        ));
  }

}
