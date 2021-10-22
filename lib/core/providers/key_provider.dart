import 'package:NFT_View/controllers/widgets/wallet_connect_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyProvider = StateNotifierProvider(
  (ref) => WalletConnect(),
);
