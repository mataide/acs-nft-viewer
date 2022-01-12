import 'package:floor/floor.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';

@dao
abstract class CollectionsDAO {

  @Query('SELECT * FROM Collections')
  Future<List<Collections>> findAllCollections();

  @Query('DELETE FROM Collections')
  Future<void> deleteAllCollections();

  @Query('DELETE FROM Collections WHERE to LIKE :ethAddress')
  Future<void> deleteCollectionsByAddress(String ethAddress);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<List<int>> insertList(List<Collections> listCollections);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> create(Collections collections);

  @Update(onConflict: OnConflictStrategy.ignore)
  Future<void> update(Collections collections);

  @delete
  Future<void> deleteCollections(Collections collections);
}