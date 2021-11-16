import 'package:NFT_View/app/home/settings/settings_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/dialog.dart';
import 'package:NFT_View/app/home/settings/card_with_children.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class HomeSettingsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dataNotifier = watch(homeProvider.notifier);
    final data = watch(homeProvider);
    final state = watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: state.primaryColor),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          margin: EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
          color: state.primaryColor,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                'Settings',
                style: state.textTheme.caption,

              ),
              SizedBox(
                height: height * 0.0768,
              ),
              Card(
                  color: state.primaryColor,
                  child: ListTile(
                      leading: Icon(
                        Icons.perm_identity_rounded,
                        color: state.textTheme.bodyText1!.color,
                        size: 40.0,
                      ),
                      title: Text(
                        "Profile",
                        style: state.textTheme.headline5,),
                      onTap: () {})),
              Card(
                  color: state.primaryColor,
                  child: ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: state.textTheme.bodyText1!.color,
                        size: 40.0,
                      ),
                      title: Text(
                        "Wallets",
                        style: state.textTheme.headline5,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: state.textTheme.bodyText1!.color,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsLoginView()));
                      })),
              Card(
                  color: state.primaryColor,
                  child: ListTile(
                      leading: Icon(
                        Icons.bedtime_outlined,
                        color: state.textTheme.bodyText1!.color,
                        size: 40.0,
                      ),
                      title: Text(
                        "Theme",
                        style: state.textTheme.headline5,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: state.textTheme.bodyText1!.color,
                      ),
                      onTap: () {
                        showThemeChangerDialog(context);
                      })),
            ],
          ),
        ));
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
    final state = watch(themeProvider);

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
