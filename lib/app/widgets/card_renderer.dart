import 'package:faktura_nft_viewer/core/models/collections_item.dart';
import 'package:faktura_nft_viewer/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class CardRenderer extends ConsumerWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final CollectionsItem collectionsItem;

  const CardRenderer(this.offset, {Key key = const Key(""), this.cardWidth = 250, required this.collectionsItem, required this.cardHeight}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData state = ref.watch(themeProvider);

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(top: 8),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          // Card background color & decoration
          Container(
            margin: EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: state.primaryColorDark,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(color: Colors.black12, blurRadius: 10 + 6 * offset.abs()),
              ],
            ),
          ),
          // City image, out of card by 15px
          Positioned(top: -15, child: _buildCityImage()),
          // City information
          _buildCityData(state)
        ],
      ),
    );
  }

  Widget _buildCityImage() {
    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return Container(
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildPositionedLayer(collectionsItem.image, containerWidth * .8, maxParallax * .1, globalOffset),
          // _buildPositionedLayer("images/${collectionsItem.name}/${collectionsItem.name}-Middle.png", containerWidth * .9, maxParallax * .6, globalOffset),
          // _buildPositionedLayer("images/${collectionsItem.name}/${collectionsItem.name}-Front.png", containerWidth * .9, maxParallax, globalOffset),
        ],
      ),
    );
  }

  Widget _buildCityData(state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .57),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(collectionsItem.name, style: state.textTheme.headline4, textAlign: TextAlign.center),
        ),
        Expanded(child: SizedBox(),),
        FlatButton(
          disabledColor: Colors.transparent,
          color: Colors.transparent,
          child: Text('Learn More'.toUpperCase(), style: state.textTheme.headline4),
          onPressed: null,
        ),
        SizedBox(height: 8)
      ],
    );
  }

  Widget _buildPositionedLayer(String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 24;
    double layerWidth = cardWidth - cardPadding;
    return Positioned(
        left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) + globalOffset,
        bottom: cardHeight * .45,
        child: path.contains('http') ? Image.network(
          path,
          fit: BoxFit.cover,
        ) : Image.file(
          File(path),
          height: cardHeight,
          fit: BoxFit.cover,
        ));
  }
}

class City {
  final String name;
  final String title;
  final String description;
  final Color color;

  City(
    this.title,
    this.name,
    this.description,
    this.color,
  );
}
