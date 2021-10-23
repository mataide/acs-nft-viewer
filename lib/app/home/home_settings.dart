import 'package:NFT_View/app/home/settings/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/dialog.dart';
import 'package:NFT_View/app/home/settings/card_with_children.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class HomeSettings extends ConsumerWidget {
  bool get wantKeepAlive => true;
  String cacheSize = 'N/A';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      color: Colors.white,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          CardWithChildren(
            title: 'Select Theme',
            children: <Widget>[
              CustomListTile(
                title: 'Themes',
                icon: FontAwesomeIcons.palette,
                subtitle: 'Select the way you app looks.',
                onTap: () {
                  showThemeChangerDialog(context);
                },
              ),
            ],
          ),
          CardWithChildren(
            title: "User",
            children: <Widget>[
              CustomListTile(
                title: "Login",
                icon: FontAwesomeIcons.user,
                subtitle: 'Login to your app.',
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }, //AGUARDANDO BANCO DE DADOS DE LOGIN
              )
            ],
          )

          //DESATIVANDO AS OPÇOES DE DESENVOLVIMENTO
          //_supportDev(state),
        ],
      ),
    );
  }
}

class CustomListTile extends ConsumerWidget {
  final String? title, subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  CustomListTile(
      {Key? key,
      this.title = 'Title',
      this.subtitle,
      this.icon = Icons.star,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ThemeData state = watch(themeProvider.notifier).state;

    return ListTile(
      onTap: onTap,
      dense: true,
      leading: Icon(
        icon,
        color: Color(0xff909090),
      ),
      title: Text(
        title!,
        style: state.textTheme.bodyText1,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: state.textTheme.caption,
            ),
    );
  }
}
