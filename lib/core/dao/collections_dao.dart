import 'package:floor/floor.dart';
import 'package:NFT_View/core/models/index.dart';

@dao
abstract class CollectionsDAO {

  @Query('SELECT INTO * FROM Collections')
  Future<List<Collections?>> findAll();

  @Insert(onConflict: OnConflictStrategy.rollback)
  Future<List<int>> insertList(List<Collections> listCollections);

  @Insert(onConflict: OnConflictStrategy.rollback)
  Future<int> create(Collections collections);

  @Update(onConflict: OnConflictStrategy.rollback)
  Future<void> update(Collections collections);

  @delete
  Future<void> deleteCollections(Collections collections);
}