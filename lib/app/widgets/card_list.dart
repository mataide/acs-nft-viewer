import 'package:faktura_nft_viewer/app/transform/rotation_3d.dart';
import 'package:faktura_nft_viewer/controllers/widgets/card_list_controller.dart';
import 'package:faktura_nft_viewer/core/models/collections_item.dart';
import 'package:faktura_nft_viewer/core/providers/card_list_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card_renderer.dart';

class CardListWidget extends ConsumerWidget implements TickerProvider {
  final double _maxRotation = 20;
  //int _focusedIndex = 0;
  Tween<double>? _tween;
  Animation<double>? _tweenAnim;
  Ticker? _ticker;
  final List<CollectionsItem> collectionsItemList;

  CardListWidget(this.collectionsItemList);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(cardListProvider(collectionsItemList).notifier);
    final CardListState dataState = ref.watch(cardListProvider(collectionsItemList));

    Size size = MediaQuery.of(context).size;
    double _cardHeight = (size.height * .48).clamp(300.0, 400.0);
    double _cardWidth = _cardHeight * .8;
    //Calculate the viewPort fraction for this aspect ratio, since PageController does not accept pixel based size values
    PageController _pageController = PageController(initialPage: 1, viewportFraction: _cardWidth / size.width);

    //Create our main list
    Widget listContent = Container(
      //Wrap list in a container to control height and padding
      height: _cardHeight,
      //Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
      child: PageView.builder(
        //Use bounce-style scroll physics, feels better with this demo
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: dataState.collectionsItemList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => _buildItemRenderer(i, _cardHeight, _cardWidth, dataState, ref),
      ),
    );

    //Wrap our list content in a Listener to detect PointerUp events, and a NotificationListener to detect ScrollStart and ScrollUpdate
    //We have to use both, because NotificationListener does not inform us when the user has lifted their finger.
    //We can not use GestureDetector like we normally would, ListView suppresses it while scrolling.
    return Listener(
      onPointerUp: (PointerUpEvent event) {
        if (ref.read(cardListProvider(collectionsItemList)).isScrolling) {
          controller.setIsScrolling(false);
          _startOffsetTweenToZero(dataState, controller);
        }
      },
      child: NotificationListener(
        onNotification: (notification) {
          //Scroll Update, add to our current offset, but clamp to -1 and 1
          if (notification is ScrollUpdateNotification) {
            if (ref.read(cardListProvider(collectionsItemList)).isScrolling) {
              double dx = notification.metrics.pixels - dataState.prevScrollX;
              double scrollFactor = .01;
              double newOffset = (dataState.normalizedOffset + dx * scrollFactor);
              _setOffset(newOffset.clamp(-1.0, 1.0), dataState);
            }
            controller.setPrevScrollX(notification.metrics.pixels);
            //Calculate the index closest to middle
            //_focusedIndex = (_prevScrollX / (_itemWidth + _listItemPadding)).round();
            //dataState.onCityChange(dataState.collectionsItemList.elementAt(_pageController.page!.round() % dataState.collectionsItemList.length));
          }
          //Scroll Start
          else if (notification is ScrollStartNotification) {
            controller.setIsScrolling(true);
            controller.setPrevScrollX(notification.metrics.pixels);
            if (_tween != null) {
              dataState.tweenController!.stop();
            }
          }
          return true;
        },
        child: listContent,
      ),
    );
  }

  //Create a renderer for each list item
  Widget _buildItemRenderer(int itemIndex, _cardHeight, _cardWidth, dataState, ref) {
    return Container(
      //Vertically pad all the non-selected items, to make them smaller. AnimatedPadding widget handles the animation.
      child: Rotation3d(
        rotationY: dataState.normalizedOffset * _maxRotation,
        //Create the actual content renderer for our list
        child: CardRenderer(
          //Pass in the offset, renderer can update it's own view from there
          dataState.normalizedOffset,
          //Pass in city path for the image asset links
          collectionsItem: dataState.collectionsItemList[itemIndex],
          cardWidth: _cardWidth,
          cardHeight: _cardHeight,
        ),
      ),
    );
  }

  //Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value, dataState) {
    dataState.normalizedOffset = value;
  }

  //Tweens our offset from the current value, to 0
  void _startOffsetTweenToZero(dataState, controller) {
    //The first time this runs, setup our controller, tween and animation. All 3 are required to control an active animation.
    int tweenTime = 1000;
    if (dataState.tweenController == null) {
      //Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
      controller.setTweenController(AnimationController(vsync: this, duration: Duration(milliseconds: tweenTime)));

      //Create Tween, which defines our begin + end values
      _tween = Tween<double>(begin: -1, end: 0);
      //Create Animation, which allows us to access the current tween value and the onUpdate() callback.
      _tweenAnim = _tween!.animate(new CurvedAnimation(parent: dataState.tweenController!, curve: Curves.elasticOut))
        //Set our offset each time the tween fires, triggering a rebuild
        ..addListener(() {
          _setOffset(_tweenAnim!.value, dataState);
        });
    }
    //Restart the tweenController and inject a new start value into the tween
    _tween!.begin = dataState.normalizedOffset;
    dataState.tweenController!.reset();
    _tween!.end = 0;
    dataState.tweenController!.forward();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null)
        return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$runtimeType is a SingleTickerProviderStateMixin but multiple tickers were created.'),
        ErrorDescription('A SingleTickerProviderStateMixin can only be used as a TickerProvider once.'),
        ErrorHint(
          'If a State is used for multiple AnimationController objects, or if it is passed to other '
              'objects and those objects might use it more than one time in total, then instead of '
              'mixing in a SingleTickerProviderStateMixin, use a regular TickerProviderStateMixin.',
        ),
      ]);
    }());
    _ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null);
    // We assume that this is called from initState, build, or some sort of
    // event handler, and that thus TickerMode.of(context) would return true. We
    // can't actually check that here because if we're in initState then we're
    // not allowed to do inheritance checks yet.
    return _ticker!;
  }
}
