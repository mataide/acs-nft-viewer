// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  Eth721DAO? _eth721DAOInstance;

  CollectionsDAO? _collectionsDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Eth721` (`hash` TEXT NOT NULL, `blockNumber` TEXT NOT NULL, `timeStamp` TEXT NOT NULL, `nonce` TEXT NOT NULL, `blockHash` TEXT NOT NULL, `from` TEXT NOT NULL, `contractAddress` TEXT NOT NULL, `to` TEXT NOT NULL, `tokenID` TEXT NOT NULL, `tokenName` TEXT NOT NULL, `tokenSymbol` TEXT NOT NULL, `tokenDecimal` TEXT NOT NULL, `transactionIndex` TEXT NOT NULL, `gas` TEXT NOT NULL, `gasPrice` TEXT NOT NULL, `gasUsed` TEXT NOT NULL, `cumulativeGasUsed` TEXT NOT NULL, `input` TEXT NOT NULL, `confirmations` TEXT NOT NULL, PRIMARY KEY (`hash`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Collections` (`contractAddress` TEXT NOT NULL, `hash` TEXT NOT NULL, `timeStamp` TEXT NOT NULL, `blockHash` TEXT NOT NULL, `from` TEXT NOT NULL, `to` TEXT NOT NULL, `tokenID` TEXT NOT NULL, `tokenName` TEXT NOT NULL, `tokenSymbol` TEXT NOT NULL, `tokenDecimal` TEXT NOT NULL, `amount` TEXT, `thumbnail` TEXT, `image` TEXT, `totalSupply` TEXT, PRIMARY KEY (`contractAddress`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  Eth721DAO get eth721DAO {
    return _eth721DAOInstance ??= _$Eth721DAO(database, changeListener);
  }

  @override
  CollectionsDAO get collectionsDAO {
    return _collectionsDAOInstance ??=
        _$CollectionsDAO(database, changeListener);
  }
}

class _$Eth721DAO extends Eth721DAO {
  _$Eth721DAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _eth721InsertionAdapter = InsertionAdapter(
            database,
            'Eth721',
            (Eth721 item) => <String, Object?>{
                  'hash': item.hash,
                  'blockNumber': item.blockNumber,
                  'timeStamp': item.timeStamp,
                  'nonce': item.nonce,
                  'blockHash': item.blockHash,
                  'from': item.from,
                  'contractAddress': item.contractAddress,
                  'to': item.to,
                  'tokenID': item.tokenID,
                  'tokenName': item.tokenName,
                  'tokenSymbol': item.tokenSymbol,
                  'tokenDecimal': item.tokenDecimal,
                  'transactionIndex': item.transactionIndex,
                  'gas': item.gas,
                  'gasPrice': item.gasPrice,
                  'gasUsed': item.gasUsed,
                  'cumulativeGasUsed': item.cumulativeGasUsed,
                  'input': item.input,
                  'confirmations': item.confirmations
                }),
        _eth721UpdateAdapter = UpdateAdapter(
            database,
            'Eth721',
            ['hash'],
            (Eth721 item) => <String, Object?>{
                  'hash': item.hash,
                  'blockNumber': item.blockNumber,
                  'timeStamp': item.timeStamp,
                  'nonce': item.nonce,
                  'blockHash': item.blockHash,
                  'from': item.from,
                  'contractAddress': item.contractAddress,
                  'to': item.to,
                  'tokenID': item.tokenID,
                  'tokenName': item.tokenName,
                  'tokenSymbol': item.tokenSymbol,
                  'tokenDecimal': item.tokenDecimal,
                  'transactionIndex': item.transactionIndex,
                  'gas': item.gas,
                  'gasPrice': item.gasPrice,
                  'gasUsed': item.gasUsed,
                  'cumulativeGasUsed': item.cumulativeGasUsed,
                  'input': item.input,
                  'confirmations': item.confirmations
                }),
        _eth721DeletionAdapter = DeletionAdapter(
            database,
            'Eth721',
            ['hash'],
            (Eth721 item) => <String, Object?>{
                  'hash': item.hash,
                  'blockNumber': item.blockNumber,
                  'timeStamp': item.timeStamp,
                  'nonce': item.nonce,
                  'blockHash': item.blockHash,
                  'from': item.from,
                  'contractAddress': item.contractAddress,
                  'to': item.to,
                  'tokenID': item.tokenID,
                  'tokenName': item.tokenName,
                  'tokenSymbol': item.tokenSymbol,
                  'tokenDecimal': item.tokenDecimal,
                  'transactionIndex': item.transactionIndex,
                  'gas': item.gas,
                  'gasPrice': item.gasPrice,
                  'gasUsed': item.gasUsed,
                  'cumulativeGasUsed': item.cumulativeGasUsed,
                  'input': item.input,
                  'confirmations': item.confirmations
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Eth721> _eth721InsertionAdapter;

  final UpdateAdapter<Eth721> _eth721UpdateAdapter;

  final DeletionAdapter<Eth721> _eth721DeletionAdapter;

  @override
  Future<List<Eth721?>> findAll() async {
    return _queryAdapter.queryList('SELECT INTO * FROM Eth721',
        mapper: (Map<String, Object?> row) => Eth721(
            row['hash'] as String,
            row['blockNumber'] as String,
            row['timeStamp'] as String,
            row['nonce'] as String,
            row['blockHash'] as String,
            row['from'] as String,
            row['contractAddress'] as String,
            row['to'] as String,
            row['tokenID'] as String,
            row['tokenName'] as String,
            row['tokenSymbol'] as String,
            row['tokenDecimal'] as String,
            row['transactionIndex'] as String,
            row['gas'] as String,
            row['gasPrice'] as String,
            row['gasUsed'] as String,
            row['cumulativeGasUsed'] as String,
            row['input'] as String,
            row['confirmations'] as String));
  }

  @override
  Future<List<int>> insertList(List<Eth721> listEth721) {
    return _eth721InsertionAdapter.insertListAndReturnIds(
        listEth721, OnConflictStrategy.rollback);
  }

  @override
  Future<int> create(Eth721 eth721) {
    return _eth721InsertionAdapter.insertAndReturnId(
        eth721, OnConflictStrategy.rollback);
  }

  @override
  Future<int> update(Eth721 eth721) {
    return _eth721UpdateAdapter.updateAndReturnChangedRows(
        eth721, OnConflictStrategy.rollback);
  }

  @override
  Future<int> deleteEth721(Eth721 eth721) {
    return _eth721DeletionAdapter.deleteAndReturnChangedRows(eth721);
  }
}

class _$CollectionsDAO extends CollectionsDAO {
  _$CollectionsDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _collectionsInsertionAdapter = InsertionAdapter(
            database,
            'Collections',
            (Collections item) => <String, Object?>{
                  'contractAddress': item.contractAddress,
                  'hash': item.hash,
                  'timeStamp': item.timeStamp,
                  'blockHash': item.blockHash,
                  'from': item.from,
                  'to': item.to,
                  'tokenID': item.tokenID,
                  'tokenName': item.tokenName,
                  'tokenSymbol': item.tokenSymbol,
                  'tokenDecimal': item.tokenDecimal,
                  'amount': item.amount,
                  'thumbnail': item.thumbnail,
                  'image': item.image,
                  'totalSupply': item.totalSupply
                }),
        _collectionsUpdateAdapter = UpdateAdapter(
            database,
            'Collections',
            ['contractAddress'],
            (Collections item) => <String, Object?>{
                  'contractAddress': item.contractAddress,
                  'hash': item.hash,
                  'timeStamp': item.timeStamp,
                  'blockHash': item.blockHash,
                  'from': item.from,
                  'to': item.to,
                  'tokenID': item.tokenID,
                  'tokenName': item.tokenName,
                  'tokenSymbol': item.tokenSymbol,
                  'tokenDecimal': item.tokenDecimal,
                  'amount': item.amount,
                  'thumbnail': item.thumbnail,
                  'image': item.image,
                  'totalSupply': item.totalSupply
                }),
        _collectionsDeletionAdapter = DeletionAdapter(
            database,
            'Collections',
            ['contractAddress'],
            (Collections item) => <String, Object?>{
                  'contractAddress': item.contractAddress,
                  'hash': item.hash,
                  'timeStamp': item.timeStamp,
                  'blockHash': item.blockHash,
                  'from': item.from,
                  'to': item.to,
                  'tokenID': item.tokenID,
                  'tokenName': item.tokenName,
                  'tokenSymbol': item.tokenSymbol,
                  'tokenDecimal': item.tokenDecimal,
                  'amount': item.amount,
                  'thumbnail': item.thumbnail,
                  'image': item.image,
                  'totalSupply': item.totalSupply
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Collections> _collectionsInsertionAdapter;

  final UpdateAdapter<Collections> _collectionsUpdateAdapter;

  final DeletionAdapter<Collections> _collectionsDeletionAdapter;

  @override
  Future<List<Collections?>> findAll() async {
    return _queryAdapter.queryList('SELECT INTO * FROM Collections',
        mapper: (Map<String, Object?> row) => Collections(
            row['hash'] as String,
            row['timeStamp'] as String,
            row['blockHash'] as String,
            row['from'] as String,
            row['contractAddress'] as String,
            row['to'] as String,
            row['tokenID'] as String,
            row['tokenName'] as String,
            row['tokenSymbol'] as String,
            row['tokenDecimal'] as String,
            row['amount'] as String?,
            row['thumbnail'] as String?,
            row['image'] as String?,
            row['totalSupply'] as int?));//string?
  }

  @override
  Future<List<int>> insertList(List<Collections> listCollections) {
    return _collectionsInsertionAdapter.insertListAndReturnIds(
        listCollections, OnConflictStrategy.rollback);
  }

  @override
  Future<int> create(Collections collections) {
    return _collectionsInsertionAdapter.insertAndReturnId(
        collections, OnConflictStrategy.rollback);
  }

  @override
  Future<void> update(Collections collections) async {
    await _collectionsUpdateAdapter.update(
        collections, OnConflictStrategy.rollback);
  }

  @override
  Future<void> deleteCollections(Collections collections) async {
    await _collectionsDeletionAdapter.delete(collections);
  }
}
