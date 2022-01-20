import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/controllers/widgets/html_controller.dart';

final htmlProvider = StateNotifierProvider<HtmlController, HtmlState>(
      (ref) => HtmlController(),
);
