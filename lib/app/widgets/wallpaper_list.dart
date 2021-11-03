import 'package:NFT_View/core/models/api_model.dart';
import 'package:NFT_View/core/providers/providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalpaperList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dataState = watch(apiProvider.notifier);
    final ThemeData state = watch(themeProvider.notifier).state;

    return FutureBuilder<List<DataModel>?>(
        future: dataState.getData(),
        // function where you call your api
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final images = snapshot.data;
          // AsyncSnapshot<Your object type>
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return GestureDetector(
                          onTap: () {
                            print('apertado');
                          },
                          child: Stack(
                            children: [
                              Image.network(image.url),
                              Positioned(
                                bottom: 15.0,
                                left: 20.0,
                                child: Text(
                                  image.title,
                                ),
                              ),
                            ],
                          ));
                    },
                  )),
                );
              }
          }
        });
  }
}
