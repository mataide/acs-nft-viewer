import 'package:flutter/material.dart';

void showModalAddress(BuildContext context, state, dataStateLogin) {
  final _formKey = GlobalKey<FormState>();
  final _keyCrontoller = TextEditingController();
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  List<String> stringList = [];


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
                                controller: _keyCrontoller,
                                style:state.textTheme.headline5,
                                decoration: InputDecoration(
                                  hintText: "Paste your wallet address here",
                                  //hintStyle: state.textTheme.headline5,
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
                              if (_keyCrontoller.text == "") {
                                final snackBar = SnackBar(
                                  content: Text('Insert a Public Key !', style: state.textTheme.headline5,),
                                  backgroundColor: state.primaryColor,
                                  duration: Duration(seconds: 3),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                stringList.add(_keyCrontoller.text);
                                dataStateLogin.sharedWrite(stringList);
                                Navigator.pop(context);
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

void showModalConnected(BuildContext context, state, dataState, address) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return Container(
            margin:
            EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
            //padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
                color: state.primaryColorDark,
                border: Border.all(color: state.primaryColorDark),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(height: height * 0.0185),
              Row(
                children: [
                  SizedBox(width: width * 0.13),
                  Text("wallet",
                      style: state.textTheme.bodyText2),
                  SizedBox(width: width * 0.08,),
                  Expanded(
                      child: Text(
                          address.toString().length > 8
                              ? address.toString().substring(0,
                              address.toString().length - 8)
                              : address.toString(),
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: state.textTheme.bodyText2)),
                  Expanded(
                      child: Text(
                        address.toString().length > 8
                            ? address.toString().substring(
                            address.toString().length - 8)
                            : '',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        softWrap: false,
                        style: state.textTheme.bodyText2,
                      )),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (width * 0.04), right: (width * 0.04)),
                child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: state.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        fixedSize: Size((width * 1.1), (height * 0.08)),
                        side: BorderSide(color: Colors.red),
                        alignment: Alignment.center),
                    child: Row(children: [
                      SizedBox(
                        width: width * 0.24,
                      ),
                      Icon(Icons.delete_outlined, color: Colors.red),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        "Remove wallet",
                        style: state.textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    onPressed: () {
                      dataState.sharedRemove(address);
                      Navigator.pop(context);
                    }
                ),
              ),
              SizedBox(height: height * 0.0185),
            ]));
      });
}
