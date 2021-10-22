import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/home/settings/login_controller.dart';

final loginProvider = StateNotifierProvider(
      (ref) => LoginController(),
);
