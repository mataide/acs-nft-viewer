import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/constants.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class ThemeChangerWidget extends ConsumerWidget {
  final List<String> string = ['Light', 'Dark', 'Amoled'];
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider.notifier);
    final stateData = watch(themeProvider);

    return Theme(
      data: stateData.copyWith(unselectedWidgetColor: stateData.accentColor),
      child: AlertDialog(
          backgroundColor: stateData.primaryColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text('Select Theme', style: stateData.textTheme.bodyText2),
          content: Container(
            width: 0.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: index,
                  groupValue: themes.indexOf(stateData),
                  onChanged: (dynamic ind) {
                    state.onThemeChanged(ind, state);
                  },
                  title: Text(
                    string[index],
                    style: stateData.textTheme.bodyText1,
                  ),
                );
              },
              itemCount: string.length,
            ),
          )),
    );
  }
}


//SELEÇÃO DOS TEMAS

void showLoadingDialog(BuildContext context, ScopedReader watch) {
  final state = watch(themeProvider);

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
            onWillPop: _willPopCallback,
            child: AlertDialog(
              backgroundColor: state.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              content: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Please Wait....',
                        style: state.textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}

Future<bool> _willPopCallback() async {
  return false;
}

void showAlertDialog(BuildContext context, String error, String title) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('$title'),
        content: Text(error),
        actions: <Widget>[
          TextButton(
            child: Text('Okay', style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}

showConfirmationDialog(BuildContext context, String title, String content, ScopedReader watch) async {
  bool confirm = false;
  final state = watch(themeProvider);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: state.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('$title', style: state.textTheme.bodyText2),
        content: Text(content, style: state.textTheme.bodyText1),
        actions: <Widget>[
          TextButton(
            child: Text('Yes', style: TextStyle(color: state.accentColor)),
            onPressed: () {
              confirm = true;
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('No', style: TextStyle(color: state.accentColor)),
            onPressed: () {
              confirm = false;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );

  return confirm;
}

showThemeChangerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => ThemeChangerWidget(),
  );
}
