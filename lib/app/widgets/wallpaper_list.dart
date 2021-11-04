import 'package:NFT_View/core/models/api_model.dart';
import 'package:NFT_View/core/providers/providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallpaperList extends ConsumerWidget {
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
                return
                  ListView.builder(
                      itemCount: 60,
                      itemBuilder: (context, index) {
                        final image = images[index];
                        print(images);
                        return Image.network(image.url);

                      }
                  );
              }
          }
        }
        );
              }
          }

