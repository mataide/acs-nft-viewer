import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/widgets/flag_list_controller.dart';

final flagListProvider = StateNotifierProvider(
      (ref) => FlagListController(),
);
