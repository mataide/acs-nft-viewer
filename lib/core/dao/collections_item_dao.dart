import 'package:floor/floor.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';

@dao
abstract class CollectionsItemDAO {

  @Query('SELECT * FROM CollectionsItem')
  Future<List<CollectionsItem>> findAll();

  @Query('DELETE FROM CollectionsItem')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<List<int>> insertList(List<CollectionsItem> listCollectionsItem);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> create(CollectionsItem collectionsItem);

  @Update(onConflict: OnConflictStrategy.ignore)
  Future<void> update(CollectionsItem collectionsItem);

  @delete
  Future<void> deleteCollectionsItem(CollectionsItem collectionsItem);
}