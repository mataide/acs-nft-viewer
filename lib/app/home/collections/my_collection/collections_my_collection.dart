import 'package:NFT_View/app/widgets/wallpaper_list.dart';
import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCollection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(apiProvider.notifier);

    return Scaffold(
        backgroundColor: state.primaryColor,
        appBar: AppBar(
          title: Text('BUSCAR NOME DA COLEÇÃO'),
          backgroundColor: state.primaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            ListTile(
              title: Text('Author'),
              subtitle: Text(
                "BUSCAR DA API O NOME DO AUTOR",
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              dense: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Text("About"),
              subtitle: Text(
                "BUSCAR DA API DESCRIÇÃO DA COLEÇÃO",
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              dense: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Owned',
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 28.0,
            ),
            Container(
              child: WallpaperList(),
            ),
          ]),
        ));
  }
}
