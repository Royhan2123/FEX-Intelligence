import 'models.dart';
import 'utils.dart';

void generateNetworkInfrastructure(HttpPackage pkg) {
  _generateEndpoints();
  String content = '';
  switch (pkg) {
    case HttpPackage.dio:
      content = '''
import 'package:dio/dio.dart';
import 'endpoints.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Endpoints.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  ApiClient() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.message,
        data: e.response?.data ?? {'error': e.message},
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 500,
        statusMessage: 'An unexpected error occurred: \$e',
        data: {'error': 'An unexpected error occurred: \$e'},
      );
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.message,
        data: e.response?.data ?? {'error': e.message},
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 500,
        statusMessage: 'An unexpected error occurred: \$e',
        data: {'error': 'An unexpected error occurred: \$e'},
      );
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.message,
        data: e.response?.data ?? {'error': e.message},
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 500,
        statusMessage: 'An unexpected error occurred: \$e',
        data: {'error': 'An unexpected error occurred: \$e'},
      );
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await dio.patch(path, data: data);
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.message,
        data: e.response?.data ?? {'error': e.message},
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 500,
        statusMessage: 'An unexpected error occurred: \$e',
        data: {'error': 'An unexpected error occurred: \$e'},
      );
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.message,
        data: e.response?.data ?? {'error': e.message},
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 500,
        statusMessage: 'An unexpected error occurred: \$e',
        data: {'error': 'An unexpected error occurred: \$e'},
      );
    }
  }

  void close() {
    dio.close(); // Close the underlying HttpClient
  }
}
''';
      break;
    case HttpPackage.http:
      content = '''
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'endpoints.dart';

class ApiClient {
  final String baseUrl = Endpoints.baseUrl;
  final http.Client _httpClient = http.Client(); // Instantiate http.Client for better resource management

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final uri = Uri.parse('\$baseUrl\$path').replace(queryParameters: query);
      return await _httpClient.get(uri);
    } catch (e) {
      return http.Response('{"error": "An unexpected error occurred: \$e"}', 500, headers: {'Content-Type': 'application/json'});
    }
  }

  Future<http.Response> post(String path, {dynamic data}) async {
    try {
      return await _httpClient.post(
        Uri.parse('\$baseUrl\$path'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return http.Response('{"error": "An unexpected error occurred: \$e"}', 500, headers: {'Content-Type': 'application/json'});
    }
  }

  Future<http.Response> put(String path, {dynamic data}) async {
    try {
      return await _httpClient.put(
        Uri.parse('\$baseUrl\$path'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return http.Response('{"error": "An unexpected error occurred: \$e"}', 500, headers: {'Content-Type': 'application/json'});
    }
  }

  Future<http.Response> patch(String path, {dynamic data}) async {
    try {
      final request = http.Request('PATCH', Uri.parse('\$baseUrl\$path'));
      if (data != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(data);
      }
      final response = await _httpClient.send(request);
      return http.Response.fromStream(response);
    } catch (e) {
      return http.Response('{"error": "An unexpected error occurred: \$e"}', 500, headers: {'Content-Type': 'application/json'});
    }
  }

  Future<http.Response> delete(String path) async {
    try {
      return await _httpClient.delete(Uri.parse('\$baseUrl\$path'));
    } catch (e) {
      return http.Response('{"error": "An unexpected error occurred: \$e"}', 500, headers: {'Content-Type': 'application/json'});
    }
  }

  void close() {
    _httpClient.close(); // Close the http.Client
  }
}
''';
      break;
    case HttpPackage.getConnect:
      content = '''
import 'package:get/get.dart';
import 'endpoints.dart';

class ApiClient extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = Endpoints.baseUrl;
    // You can add interceptors or custom configurations here
    // For example, to log requests/responses:
    // httpClient.addRequestModifier((request) async {
    //   print('Request: \${request.method} \${request.url}');
    //   return request;
    // });
    // httpClient.addResponseModifier((request, response) async {
    //   print('Response: \${response.statusCode} \${response.request?.url}');
    //   return response;
    // });
    super.onInit();
  }

  @override
  void onClose() {
    // Perform any cleanup here if you had custom resources.
    // GetConnect handles its own client lifecycle.
    super.onClose();
  }
}
''';
      break;
  }
  saveFile('lib/data/network', 'api_client.dart', content);
}

void _generateEndpoints() {
  const content = 'class Endpoints {\n  static const String baseUrl = "https://api.example.com";\n  static const String users = "/users";\n}';
  saveFile('lib/data/network', 'endpoints.dart', content);
}