import 'package:NFT_View/core/providers/login_provider.dart';
import 'package:NFT_View/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

// Controllers
import 'package:NFT_View/controllers/home/settings/settings_login_controller.dart';

class LoginAddress extends ConsumerWidget {
  LoginAddress( {Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _keyCrontollers = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(loginProvider.notifier);

    return
    modalAddress(context, state, dataState);
  }
     Widget modalAddress (BuildContext context, state, dataState){
     showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Form(
              key: _formKey,
              //FORM é para validar os campos
              child: ListView(
                padding: EdgeInsets.all(40.0),
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _keyCrontollers,
                      style: TextStyle(color: state.textTheme.bodyText1!.color),
                      decoration: InputDecoration(
                        hintText: "Insert Public Key",
                        hintStyle: TextStyle(
                            fontSize: 20.0, color: state.textTheme.bodyText1!.color),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0))),
                    onPressed: () {
                      if (_keyCrontollers.text == "") {
                        final snackBar = SnackBar(
                          content: Text('Insert a Public Key !'),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        dataState.sharedWrite(_keyCrontollers.text);
                        //key.rest(_keyCrontollers.text);
                      }
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            );
          });

      return Container(color: Colors.red,);
    }


        /*return Scaffold(
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
                controller: _keyCrontollers,
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
                if (_keyCrontollers.text == "") {
                  final snackBar = SnackBar(
                    content: Text('Insert a Public Key !'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  key.sharedWrite(_keyCrontollers.text);
                  //key.rest(_keyCrontollers.text);
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
  }*/
}
