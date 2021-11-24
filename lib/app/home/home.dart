import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/app/widgets/bottom_nav_bar.dart';
import 'home_collections.dart';
import 'home_search.dart';
import 'home_settings.dart';
import 'package:flutter/material.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

class HomePage extends ConsumerWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataNotifier = watch(homeProvider.notifier);
    final data = watch(homeProvider);
    final settingsNotifier = watch(homeSettingsProvider.notifier);


    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: state.primaryColor,
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            dataNotifier.setIndex(index);
          },
          children: <Widget>[
            HomeCollectionsView(),
            //HomeMarketplace(),
            HomeSettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: data.selectedIndex,
        unselectedColor: state.textTheme.bodyText2!.color,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
        },
        selectedColor: state.textTheme.bodyText2!.color,
        backgroundColor: state.primaryColor,
        showElevation: false,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.palette_outlined, size: 23.3,),
            title: Text('My Collections', style: state.textTheme.bodyText2),
          ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.work_outline),
          //   title: Text('Marketplace'),
          // ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings_outlined, size: 23.3,),
            title: Text(settingsNotifier.title, style: state.textTheme.bodyText2,),
          ),
        ],
      ),
    );
  }
}