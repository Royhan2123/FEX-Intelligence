import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class FexInspector extends Interceptor {
  final String serverUrl = 'http://localhost:8000/network-log';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _sendLog(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) _sendLog(err.response!);
    super.onError(err, handler);
  }

  void _sendLog(Response res) async {
    try {
      final logData = {
        'method': res.requestOptions.method,
        'url': res.requestOptions.uri.toString(),
        'status': res.statusCode,
        'request_body': res.requestOptions.data,
        'response_body': res.data,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final client = HttpClient();
      final request = await client.postUrl(Uri.parse(serverUrl));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(logData)));
      await request.close();
      client.close();
    } catch (e) { }
  }
}
