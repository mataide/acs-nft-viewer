import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/core/method_channel/conectar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerWidget {
  /// Initialize NetworkStreamWidget with [key].
  static const String EVENT_CHANNEL_WALLET =
      "com.bimsina.re_walls/WalletStreamHandler";
  final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);
  final _formKey = GlobalKey<FormState>();
  final _keyCrontollers = TextEditingController();
  var rest;
  var address;


  @override
  Widget _buildChild() {
    _sharedRead();
    if (rest == null) {
      final networkStream = _eventChannel
          .receiveBroadcastStream()
          .distinct()
          .map((dynamic event) => event as String);
      return StreamBuilder<String>(
          initialData: rest.toString(),
          stream: networkStream,
          builder: (context, snapshot) {
            address = snapshot.data ?? null;
            print(address);
            return ListView(padding: EdgeInsets.all(16.0), children: [
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
                          hintStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        /* if (_keyCrontollers.text == "" && rest == null) {
                              final snackBar = SnackBar(content: Text(
                                  'Insert a Public Key !'),
                                duration: Duration(seconds: 3),);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            } else if (rest != null) {
                              setState(() {});
                            } else {*/
                        address = _keyCrontollers.text;
                        rest = _keyCrontollers.text;
                        _sharedWrite();
                        setState(() {});
                      },
                      //},
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  openMetaMesk();
                  {
                    _sharedWrite();
                  }
                },
                child: Text(
                  "Wallet Connect",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ]);
          });
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              rest,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              _sharedRemove();
              setState(() {});
            },
            child: new Icon(Icons.delete_forever),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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

  Future<void> _sharedWrite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', address);
  }

  Future<void> _sharedRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rest = prefs.getString('key');
  }

  Future<void> _sharedRemove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('key');
  }
}
