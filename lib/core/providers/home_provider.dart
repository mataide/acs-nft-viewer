import 'package:faktura_nft_viewer/controllers/home/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = StateNotifierProvider<HomeController, HomeState>(
      (ref) => HomeController(),
);