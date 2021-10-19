import 'package:floor/floor.dart';
import 'package:NFT_View/core/models/eth721.dart';

@dao
abstract class Eth721Dao {
  @insert
  Future<void> createEth721(Eth721 eth721);

  @update
  Future<void> updateEth721(Eth721 eth721);

  @delete
  Future<void> deleteEth721(Eth721 eth721);
}