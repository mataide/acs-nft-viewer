const String API_BASE_URL = "https://api.etherscan.io/";
const String API_KEY = "NXIMNR3HSJR58AHXU4TE6Y7ZD73BIHE3MR";

class EndPoints {
  static String getPosts(String? subreddit, String filter) {
    return '${API_BASE_URL}r/$subreddit/$filter.json';
  }

  static String getSearch(String searchTerm) {
    searchTerm = searchTerm.replaceAll(' ', '%20');
    return '${API_BASE_URL}api?q=$searchTerm&type=link';
  }

  static String getERC721(String address, {String page = "1", String offset = "100"}) {
    return '${API_BASE_URL}api?module=account&action=tokennfttx&address=$address&page=$page&offset=$offset&startblock=0&endblock=27025780&sort=asc&apikey=$API_KEY';
  }
}

final List<String> kfilterValues = [
  'Hot',
  'New',
  'Controversial',
  'Top',
  'Rising'
];
