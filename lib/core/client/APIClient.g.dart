// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'APIClient.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _APIClient implements APIClient {
  _APIClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.etherscan.io/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Eth721> getERC721(address,
      {module = "account",
      action = "tokennfttx",
      page = "1",
      offset = "100",
      startblock = "0",
      endblock = "27025780",
      sort = "asc",
      apikey = "NXIMNR3HSJR58AHXU4TE6Y7ZD73BIHE3MR"}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'address': address,
      r'module': module,
      r'action': action,
      r'page': page,
      r'offset': offset,
      r'startblock': startblock,
      r'endblock': endblock,
      r'sort': sort,
      r'apikey': apikey
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Eth721>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Eth721.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
