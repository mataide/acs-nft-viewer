import 'package:NFT_View/app/home/home_marketplace.dart';
import 'package:NFT_View/controllers/home/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/app/widgets/bottom_nav_bar.dart';
import 'home_search.dart';
import 'home_collection.dart';
import 'home_settings.dart';
import 'package:flutter/material.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class HomePage extends ConsumerWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataNotifier = watch(homeProvider.notifier);
    final data = watch(homeProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: state.primaryColor,
        elevation: 0,
        title: Text(
          'NTF-View',
          style: state.textTheme.headline5,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: state.textTheme.bodyText2!.color,
            ),
            onPressed: () =>
                showSearch(
                    context: context,
                    delegate: HomeSearch(themeData: state)),
          )
        ],
      ),
      body: Container(
        color: state.primaryColor,
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            dataNotifier.setIndex(index);
          },
          children: <Widget>[
            HomeCollection(),
            HomeMarketplace(),
            HomeSettings(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: data.selectedIndex,
        unselectedColor: state.textTheme.bodyText2!.color,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
        },
        selectedColor: state.colorScheme.secondary,
        backgroundColor: state.primaryColor,
        showElevation: false,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.palette_outlined),
            title: Text('My collections'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.work_outline),
            title: Text('Marketplace'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}