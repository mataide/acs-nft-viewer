
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/eth721.dart';

part 'APIClient.g.dart';

const String API_BASE_URL = "https://api.etherscan.io/";

// class APIClient {
//
//   static const String API_KEY = "NXIMNR3HSJR58AHXU4TE6Y7ZD73BIHE3MR";
//
//
//
//   static String getPosts(String? subreddit, String filter) {
//     return '${API_BASE_URL}r/$subreddit/$filter.json';
//   }
//
//   static String getSearch(String searchTerm) {
//     searchTerm = searchTerm.replaceAll(' ', '%20');
//     return '${API_BASE_URL}api?q=$searchTerm&type=link';
//   }
//
//   static String getERC721(String address, {String page = "1", String offset = "100"}) {
//     return '${API_BASE_URL}api?module=account&action=tokennfttx&address=$address&page=$page&offset=$offset&startblock=0&endblock=27025780&sort=asc&apikey=$API_KEY';
//   }
// }

@RestApi(baseUrl: API_BASE_URL)
abstract class APIClient {

  static const String ENDPOINT_API = "/api?module=account&action=tokennfttx";

  factory APIClient(Dio dio, {String baseUrl}) = _APIClient;


  @GET(ENDPOINT_API)
  Future<Eth721> getERC721(
      @Query("module") String module,
      @Query("action") String action,
      @Query("address") String address,
      @Query("page") String page,
      @Query("offset") String offset,
      @Query("startblock") String startblock,
      @Query("endblock") String endblock,
      @Query("sort") String sort,
      @Query("apikey") String apikey,
      );
}


final List<String> kfilterValues = [
  'Hot',
  'New',
  'Controversial',
  'Top',
  'Rising'
];
