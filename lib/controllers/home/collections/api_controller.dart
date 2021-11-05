import 'dart:convert';
import 'package:NFT_View/core/models/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiState {
  final String? image;
  final List<String>? data;
  final List<DataModel> listDataModel;

  ApiState({this.image, this.data = const [], this.listDataModel = const []});
}

class GetDataFromApi extends StateNotifier<ApiState> {
  GetDataFromApi([GetDataFromApi? state]) : super(ApiState());

  String? get image => state.image;

  List<String>? get data => state.data;

  List<DataModel> get listDataModel => state.listDataModel;

  get index => null;

  Future<List<DataModel>?> getData() async {
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    final data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      // listDataModel.add(DataModel.fromJson(data[i]));
      return data.map<DataModel>(DataModel.fromJson).toList();
    }
    state = ApiState(data: data);
  }

//Future<String?> getImage() async {
//  final image = await listDataModel[index].url.toString();
//  state = ApiState(image: image);
//  }

}
