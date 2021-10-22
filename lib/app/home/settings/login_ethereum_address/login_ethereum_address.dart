import 'package:NFT_View/core/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginAddress extends StatelessWidget {
  LoginAddress({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final keyCrontollers = TextEditingController();

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
        key: _formKey,
        //FORM é para validar os campos
        child: ListView(
          padding: EdgeInsets.all(40.0),
          children: [
            Expanded(
              child: TextFormField(
                controller: keyCrontollers,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Insert Public Key",
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0))),
              onPressed: () {
                if (keyCrontollers.text == "") {
                  final snackBar = SnackBar(
                    content: Text('Insert a Public Key !'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  stateLogin.rest = keyCrontollers.text;
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
    );
  }
}
