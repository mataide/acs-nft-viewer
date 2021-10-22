import 'package:NFT_View/app/widgets/bottom_nav_bar.dart';
import 'search_page.dart';
import 'category.dart';
import 'main_page.dart';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class HomePage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ThemeData state = watch(themeNotifierProvider.notifier).state;

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
            onPressed: () => showSearch(
                context: context, delegate: WallpaperSearch(themeData: state)),
          )
        ],
      ),
      body: Container(
        color: state.primaryColor,
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            // setState(() {
            //   _selectedIndex = index;
            // });
          },
          children: <Widget>[
            MainBody(),
            Category(),
            //ForYou(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        unselectedColor: state.textTheme.bodyText2!.color,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
        },
        selectedColor: state.accentColor,
        backgroundColor: state.primaryColor,
        showElevation: false,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.category),
            title: Text('Categories'),
          ),
          //RETIRANDO O BOTAO DO EXACT FIT POIS ACREDITO SER DESNECESSARIA UMA BUSCA POR TAMANHO DA IMAGEM
          //NESTE PROJETO.

         /* BottomNavyBarItem(
            icon: Icon(Icons.phone_android),
            title: Text('Exact Fit'),
          ),*/
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

  /*Widget oldBody(ThemeData state) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: state.primaryColor,
            elevation: 4,
            title: Text(
              'NTF-View',
              style: state.textTheme.headline5,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: state.accentColor),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: WallpaperSearch(themeData: state));
                },
              )
            ],
            floating: true,
            pinned: _selectedIndex == 0 ? false : true,
            snap: false,
            centerTitle: false,
          ),
        ];
      },
      body: Container(
        color: state.primaryColor,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            MainBody(),
            Category(),
            //ForYou(), RETIRANDO O CODIGO DO EXACT FIT POIS ACREDITO SER DESNECESSARIA UMA BUSCA POR TAMANHO DA IMAGEM
            //           //NESTE PROJETO.
            SettingsPage(),
          ],
        ),
      ),
    );
  }*/
}
