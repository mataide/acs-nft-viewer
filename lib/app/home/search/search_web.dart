import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchWeb extends StatefulWidget {
  final String? title, initialPage;

  SearchWeb({Key? key, required this.title, required this.initialPage})
      : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<SearchWeb> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeNotifier>(context);
    final ThemeData themeData = state.getTheme();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.primaryColor,
        leading: IconButton(
            color: themeData.textTheme.bodyText2!.color,
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          widget.title!,
          style: themeData.textTheme.bodyText2,
        ),
      ),
      body: Container(
        color: themeData.primaryColor,
        child: WebView(
          initialUrl: widget.initialPage,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
