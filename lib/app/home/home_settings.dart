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

    return Container(
      padding: const EdgeInsets.only(top: 50.0),
      color: state.primaryColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        //padding: const EdgeInsets.only(top: 40.0),
        children: [
          Text(
            'Settings',
            style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 40.0),
          ),
          SizedBox(
            height: 50.0,
          ),
          Card(
              color: state.primaryColor,
              child: ListTile(
                  leading: const Icon(
                    Icons.perm_identity_rounded,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onTap: () {})),
          Card(
              color: state.primaryColor,
              child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  title: const Text(
                    "Wallets",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsLoginView()));
                  })),
          Card(
              color: state.primaryColor,
              child: ListTile(
                  leading: const Icon(
                    Icons.bedtime_outlined,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  title: const Text(
                    "Theme",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.white,
                  ),
                  onTap: () {
                    showThemeChangerDialog(context);
                  })),
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
