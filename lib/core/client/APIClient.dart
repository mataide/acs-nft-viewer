
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
  Future<Eth721> getERC721(
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
