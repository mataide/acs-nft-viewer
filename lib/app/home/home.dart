import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/collections.dart';
import 'home_collections.dart';
import 'home_settings.dart';
import 'package:flutter/material.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

class HomePage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final dataNotifier = ref.watch(homeProvider.notifier);
    final data = ref.watch(homeProvider);
    final settingsNotifier = ref.watch(homeSettingsProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: state.indicatorColor)),
            color: state.primaryColor),
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            dataNotifier.setIndex(index);
          },
          children: <Widget>[
            //HomeMarketplace(),
            HomeCollectionsView(),
            HomeSettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: data.selectedIndex,
        //selectedIndex: data.selectedIndex,
        unselectedItemColor: state.textTheme.bodyText2!.color,
        //unselectedColor: state.textTheme.bodyText2!.color,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        //onItemSelected: (index) {
        //   _pageController.jumpToPage(index);
        // },
        selectedItemColor: state.indicatorColor,
        //selectedColor: state.indicatorColor,
        backgroundColor: state.primaryColor,
        elevation: 0.0,
        //showElevation: false,
        items: [
          // BottomNavyBarItem(
          //   icon: Icon(Icons.work_outline),
          //   title: Text('Marketplace'),
          // ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.palette_outlined,
              size: 23.3,
            ),
            label: 'My Collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              size: 23.3,
            ),
            label: settingsNotifier.title,
          ),

        ],
      ),
    );
  }
}
