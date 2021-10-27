import 'package:NFT_View/controllers/home/collections/api_controler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = ChangeNotifierProvider<GetDataFromApi>((ref)=> GetDataFromApi());
