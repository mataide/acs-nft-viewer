// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:NFT_View/core/models/user_models.dart';
import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/ui/views/home.dart';
import 'package:NFT_View/ui/views/signup.dart';
import 'package:NFT_View/database_helper/database_helper.dart';

import 'conectar.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final dbHelper = DatabaseHelper.instance;
  final _keyCrontollers = TextEditingController();
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
        title: Text("Acess Wallet"),
        backgroundColor: state.primaryColor,
        centerTitle: true,
      ),
      body: Form( //FORM é para validar os campos
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _keyCrontollers,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Insert Public Key",
                hintStyle: TextStyle(fontSize: 20.0,color: Colors.white),
              ),
              validator: (text) {
                if (text!.isEmpty || text.length < 15)
                  return "Invalid Public Key!"; //
              },
            ),
            SizedBox(height: 16.0),
          Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    Expanded(
              child: ElevatedButton(
                    onPressed: () {
                        openMetaMesk();
                    },
                    child: Text("Fetch my PUBLIC KEY",
                     textAlign: TextAlign.right,),
                    ),
                ),
                  SizedBox(width: 16.0,),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            keyMetaMask();
                          },
                          child: Text("Enter",
                            style: TextStyle(fontSize: 16.0),),
            ),
    )
            ],
        ),
      ),
        ]
    )
    )
    );
  }

}