import 'package:floor/floor.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';

@dao
abstract class Eth721DAO {

  @Query('SELECT * FROM Eth721')
  Future<List<Eth721?>> findAll();

  @Query('DELETE FROM Eth721')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.rollback)
  Future<List<int>> insertList(List<Eth721> listEth721);

  @Insert(onConflict: OnConflictStrategy.rollback)
  Future<int> create(Eth721 eth721);

  @Update(onConflict: OnConflictStrategy.rollback)
  Future<int> update(Eth721 eth721);

  @delete
  Future<int> deleteEth721(Eth721 eth721);
}