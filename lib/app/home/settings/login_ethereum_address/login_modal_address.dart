import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalAdrress {
  modalAddress(BuildContext context, state, dataState) {
    final _formKey = GlobalKey<FormState>();
    final _keyCrontollers = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                  border: Border.all(color: state.primaryColor),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Wrap(children: <Widget>[
                    Center(
                      child: Text('Connect Wallet'),
                    ),
                    SizedBox(
                      height: 43.0,
                    ),
                    Form(
                        key: _formKey,
                        //FORM é para validar os campos
                        child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: state.primaryColor,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: _keyCrontollers,
                                style: TextStyle(
                                    color: state.textTheme.bodyText1!.color),
                                decoration: InputDecoration(
                                  hintText: "Paste your wallet address here",
                                  hintStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: state.textTheme.bodyText1!.color,
                                  ),
                                ),
                              ),
                            ))),
                    SizedBox(
                      height: 65.0,
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.only(
                              left: 135.0,
                              top: 18.0,
                              right: 146.0,
                              bottom: 18.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
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
                        "Connect",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: state.textTheme.bodyText1!.color),
                      ),
                    ),
                  ])));
        });
    //return Container();
  }
}
