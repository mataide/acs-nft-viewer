import 'dart:convert';

import 'package:faktura_nft_viewer/core/models/attributes_item.dart';
import 'package:floor/floor.dart';

class AttributesConverter extends TypeConverter<List<Attributes>, String> {
  @override
  List<Attributes> decode(String jsonString) {
    List<dynamic> list = jsonDecode(jsonString);
    return list.map((i) => Attributes.fromJson(i)).toList();
  }

  @override
  String encode(List<Attributes> attr) {
    return jsonEncode(attr.map((e) => e.toJson()).toList());
  }
}