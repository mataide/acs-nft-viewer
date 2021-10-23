import 'package:floor/floor.dart';
import 'package:NFT_View/core/models/eth721.dart';
import 'package:sqflite/sqflite.dart';

@dao
abstract class Eth721DAO {

  @Query('SELECT INTO * FROM Eth721')
  Future<List<Eth721?>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertListEth721(List<Eth721> listEth721);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> createEth721(Eth721 eth721);

  @update
  Future<void> updateEth721(Eth721 eth721);

  @delete
  Future<void> deleteEth721(Eth721 eth721);
}