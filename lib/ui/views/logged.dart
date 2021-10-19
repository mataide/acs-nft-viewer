import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/ui/views/conectar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new_login.dart';

class Logged extends StatefulWidget {
  const Logged({Key? key}) : super(key: key);

  @override
  _LoggedState createState() => _LoggedState();
}

class _LoggedState extends State<Logged> {
  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();
    return Scaffold(
      backgroundColor: state.primaryColor,
      appBar: AppBar(
        title: Text("Logged Wallet"),
        backgroundColor: state.primaryColor,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
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
                    result = null;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                    print(result);
                  },
                  child: new Icon(Icons.delete_forever),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
