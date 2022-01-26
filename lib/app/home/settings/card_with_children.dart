import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

class CardWithChildren extends ConsumerWidget {
  final List<Widget>? children;
  final String title;
  CardWithChildren({Key? key, this.children, this.title = 'Title'})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: state.primaryColorDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: TextStyle(color: state.hoverColor, fontSize: 14),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: children!,
          )
        ],
      ),
    );
  }
}
