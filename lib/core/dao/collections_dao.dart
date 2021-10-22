import 'package:floor/floor.dart';
import 'package:NFT_View/core/models/eth721.dart';

@dao
abstract class CollectionsDAO {

  @Query('INSERT INTO * FROM Eth721')
  Future<List<Eth721?>> findAll();

  @insert
  Future<List<int>> insertListEth721(List<Eth721> listEth721);

  @insert
  Future<void> createEth721(Eth721 eth721);

  @update
  Future<void> updateEth721(Eth721 eth721);

  @delete
  Future<void> deleteEth721(Eth721 eth721);
}