import 'package:floor/floor.dart';
import 'package:NFT_View/core/models/index.dart';

@dao
abstract class CollectionsDAO {

  @Query('SELECT * FROM Collections')
  Future<List<Collections>> findAll();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<List<int>> insertList(List<Collections> listCollections);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> create(Collections collections);

  @Update(onConflict: OnConflictStrategy.ignore)
  Future<void> update(Collections collections);

  @delete
  Future<void> deleteCollections(Collections collections);
}