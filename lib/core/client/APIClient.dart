

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/eth721.dart';

part 'APIClient.g.dart';

const String API_BASE_URL = "https://api.etherscan.io/";


class APIService {
  static APIClient? _instance;

  APIService._();

  static APIClient get instance {
    if(_instance == null) {
      final dio = Dio();
      dio.interceptors.add(InterceptorsWrapper(
          onRequest:(options, handler){
            // Do something before request is sent
            return handler.next(options); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onResponse:(response,handler) {
            // Do something with response data
            //final map = json.decode(response.extra);
            response.data = response.data['result'];
            return handler.next(response); // continue
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return  handler.next(e);//continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
          }
      ));
      final client = APIClient(dio);
      return client;
    }
    return _instance!;
  }
}

@RestApi(baseUrl: API_BASE_URL)
abstract class APIClient {

  static const String ENDPOINT_API = "/api";

  factory APIClient(Dio dio, {String baseUrl}) = _APIClient;

  @GET(ENDPOINT_API)
  Future<List<Eth721>> getERC721(
      @Query("address") String address,
      {
        @Query("module") String module = "account",
        @Query("action") String action = "tokennfttx",
        @Query("page") String page = "1",
        @Query("offset") String offset = "100",
        @Query("startblock") String startblock = "0",
        @Query("endblock") String endblock = "27025780",
        @Query("sort") String sort = "asc",
        @Query("apikey") String apikey = "NXIMNR3HSJR58AHXU4TE6Y7ZD73BIHE3MR"
      });
}


final List<String> kfilterValues = [
  'Hot',
  'New',
  'Controversial',
  'Top',
  'Rising'
];
