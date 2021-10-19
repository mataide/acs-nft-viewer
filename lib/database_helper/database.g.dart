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

  Eth721Dao? _eth721DaoInstance;

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

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  Eth721Dao get eth721Dao {
    return _eth721DaoInstance ??= _$Eth721Dao(database, changeListener);
  }
}

class _$Eth721Dao extends Eth721Dao {
  _$Eth721Dao(this.database, this.changeListener)
      : _eth721InsertionAdapter = InsertionAdapter(
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

  final InsertionAdapter<Eth721> _eth721InsertionAdapter;

  final UpdateAdapter<Eth721> _eth721UpdateAdapter;

  final DeletionAdapter<Eth721> _eth721DeletionAdapter;

  @override
  Future<void> createEth721(Eth721 eth721) async {
    await _eth721InsertionAdapter.insert(eth721, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEth721(Eth721 eth721) async {
    await _eth721UpdateAdapter.update(eth721, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEth721(Eth721 eth721) async {
    await _eth721DeletionAdapter.delete(eth721);
  }
}
