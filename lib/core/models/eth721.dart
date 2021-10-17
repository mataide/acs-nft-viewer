import 'package:realm_dart/realm.dart';

class _Eth721 {
  @RealmProperty(primaryKey: true)
  late String hash;

  @RealmProperty()
  late String blockNumber;

  @RealmProperty()
  late String timeStamp;

  @RealmProperty()
  late String nonce;

  @RealmProperty()
  late String blockHash;

  @RealmProperty()
  late String from;

  @RealmProperty()
  late String contractAddress;

  @RealmProperty()
  late String to;

  @RealmProperty()
  late String tokenID;

  @RealmProperty()
  late String tokenName;

  @RealmProperty()
  late String tokenSymbol;

  @RealmProperty()
  late String tokenDecimal;

  @RealmProperty()
  late String transactionIndex;

  @RealmProperty()
  late String gas;

  @RealmProperty()
  late String gasPrice;

  @RealmProperty()
  late String gasUsed;

  @RealmProperty()
  late String cumulativeGasUsed;

  @RealmProperty()
  late String input;

  @RealmProperty()
  late String confirmations;
}