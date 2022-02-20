import 'package:faktura_nft_viewer/app/home/settings/report_bugs.dart';
import 'package:faktura_nft_viewer/app/home/settings/settings_login.dart';
import 'package:faktura_nft_viewer/app/routes/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/app/widgets/dialog.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeSettingsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          iconTheme: state.primaryIconTheme,
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
                      leading: SvgPicture.asset(
                          'assets/images/profile.svg',
                          color: state.textTheme.bodyText1!.color,
                          semanticsLabel: 'profile icon',
                          width: 24,
                        height: 24,
                      ),
                      title: Text(
                        "Profile",
                        style: state.textTheme.headline5,),
                      onTap: () {})),
              Card(
                  color: state.primaryColor,
                  child: ListTile(
                      leading: SvgPicture.asset(
                          'assets/images/wallets.svg',
                          color: state.textTheme.bodyText1!.color,
                          semanticsLabel: 'wallets icon',
                          width: 24,
                        height: 24,
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
                        Navigator.of(context).push(SlideRightRoute(SettingsLoginView()));
                      })),
              Card(
                  color: state.primaryColor,
                  child: ListTile(
                      leading: SvgPicture.asset(
                          'assets/images/theme.svg',
                          color: state.textTheme.bodyText1!.color,
                          semanticsLabel: 'theme icon',
                          width: 24,
                        height: 24,
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
              Card(
                  color: state.primaryColor,
                  child: ListTile(
                      leading: Icon(
                        Icons.feedback_outlined,
                        color: state.textTheme.bodyText1!.color,
                        size: 24,
                      ),
                      title: Text(
                        "Feedback",
                        style: state.textTheme.headline5,),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: state.textTheme.bodyText1!.color,
                      ),
                      onTap: () {
                        Navigator.of(context).push(SlideRightRoute(ReportBugsView()));
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);

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
