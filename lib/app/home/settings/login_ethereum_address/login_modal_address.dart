import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalAdrress {
  modalAddress(BuildContext context, state, dataState) {
    final _formKey = GlobalKey<FormState>();
    final _keyCrontollers = TextEditingController();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              margin: EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
              //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
              decoration: BoxDecoration(
                  color: state.primaryColorDark,
                  border: Border.all(color: state.primaryColorDark),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: height * 0.0185),
                        Center(
                      child: Text('Connect Wallet', style: state.textTheme.headline5,),
                    ),
                    SizedBox(
                      height: height * 0.0185,
                    ),
                      Form(
                        key: _formKey,
                        //FORM é para validar os campos
                        child: Container(
                            margin: EdgeInsets.only(left: (width * 0.04), right: (width * 0.04)),
                            decoration: BoxDecoration(
                              border: Border.all(color: state.primaryColor),
                                color: state.primaryColor,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Center(
                              child: TextFormField(
                                //autofocus: true,
                                textAlign: TextAlign.center,
                                controller: _keyCrontollers,
                                style:state.textTheme.headline5,
                                decoration: InputDecoration(
                                  hintText: "Paste your wallet address here",
                                  hintStyle: state.textTheme.headline5,
                                  ),
                                ),
                              ),
                            )),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: (width * 0.04), right: (width * 0.04)),
                        child: ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          fixedSize: Size((width * 1.1), (height * 0.08)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      onPressed: () {
                        if (_keyCrontollers.text == "") {
                          final snackBar = SnackBar(
                            content: Text('Insert a Public Key !', style: state.textTheme.headline5,),
                            backgroundColor: state.primaryColor,
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          dataState.sharedWrite(_keyCrontollers.text);
                          //key.rest(_keyCrontollers.text);
                        }
                      },
                      child:Text(
                        "Connect", textAlign: TextAlign.center,
                        style: state.textTheme.headline5,
                      )),
                        ),
                        SizedBox(height: height * 0.024,),
                  ]
                  )


              ));
        });
    //return Container();
  }
}
