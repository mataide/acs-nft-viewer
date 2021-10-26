import 'dart:convert';
import 'package:NFT_View/core/models/api_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class GetDataFromApi extends ChangeNotifier {
  List<DataModel> listDataModel = [];

  GetDataFromApi() {
    getData();
  }

  Future getData() async {
    listDataModel = [];
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    var data = jsonDecode(response.body);
    for (int i = 0; i < 1; i++) {
      listDataModel.add(DataModel.fromMap(data[i]));
    }
    print(listDataModel.length);
    notifyListeners();
  }
}
