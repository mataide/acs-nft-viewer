import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCollection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ThemeData state = watch(themeProvider.notifier).state;
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
              subtitle: Text("BUSCAR DA API O NOME DO AUTOR",),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              dense: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Text("About"),
              subtitle: Text("BUSCAR DA API DESCRIÇÃO DA COLEÇÃO",),
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
                child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                  Column(children: [
                    Row(children: <Widget>[
                      Container(
                          child: Expanded(
                        child: FutureBuilder<List<DataModel>?>(
                            future: dataState.getData(),
                            // function where you call your api
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              final users = snapshot.data;
                              // AsyncSnapshot<Your object type>
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Some error occured!'));
                                  } else {
                                    return _buildImages(users);
                                  }
                              }
                            }),
                      )),
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                        child: FutureBuilder<List<DataModel>?>(
                            future: dataState.getData(),
                            // function where you call your api
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              final images = snapshot.data;
                              // AsyncSnapshot<Your object type>
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else {
                                    return _buildImages(images);
                                  }
                              }
                            }),
                      )
                    ])
                  ])
                ]))
          ]),
        ));
  }

  Widget _buildImages(List<DataModel> images) => ListView.builder(
        shrinkWrap: true,
        //Se passa para 2 o itemCount ele coloca a 1ª e 2ª imagem da Api uma embaixo da outra dos dois lados,
        // e não a 1ª de um lado e a 2ª do outro
        itemCount: 10,
        itemBuilder: (context, index) {
          final image = images[index];
          return Stack(
            children: [
              Image.network(
                image.url,
              ),
              Positioned(
                  bottom: 20.0,
                  left: 10.0,
                  child: Text(
                    image.title,
                  )),
            ],
          );
        },
      );
}
