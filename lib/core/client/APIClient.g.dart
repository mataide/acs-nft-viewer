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
  Future<Eth721> getERC721(module, action, address, page, offset, startblock,
      endblock, sort, apikey) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'module': module,
      r'action': action,
      r'address': address,
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
                .compose(_dio.options, '/api?module=account&action=tokennfttx',
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
