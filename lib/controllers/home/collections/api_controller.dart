import 'dart:convert';
import 'dart:io';
import 'package:NFT_View/core/models/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiState{

  final DataModel? image;
  final List<String>? data;
  final List<DataModel> listDataModel;

  ApiState({this.image, this.data = const [], this.listDataModel = const []});

}

class GetDataFromApi extends StateNotifier<ApiState> {
  GetDataFromApi([GetDataFromApi? state]) : super(ApiState());


  DataModel? get image => state.image;

  List<String>? get data => state.data;

  List<DataModel> get listDataModel => state.listDataModel;


  get index => null;

  Future<List<String>?> getData() async {
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    final data = jsonDecode(response.body);
    for (int i = 0; i < 1; i++) {
      listDataModel.add(DataModel.fromMap(data[i]));
    }
    state = ApiState(data: data, listDataModel: listDataModel);
  }

  Future<List<DataModel>?> getImage() async {
    getData();
    final image = await DataModel(url: data![index]);
    state = ApiState(image: image);
  }

  }









