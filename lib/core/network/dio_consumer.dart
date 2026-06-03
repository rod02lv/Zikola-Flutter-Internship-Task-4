import 'package:dio/dio.dart';

import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio);

  @override
  Future<dynamic> get(String path) async {
    final response = await dio.get(path);

    return response.data;
  }

  @override
  Future<dynamic> post(String path, {dynamic data}) async {
    final response = await dio.post(path, data: data);
    return response.data;
  }

  @override
  Future<dynamic> put(String path, {dynamic data}) async {
    final response = await dio.put(path, data: data);

    return response.data;
  }

  @override
  Future<dynamic> delete(String path) async {
    final response = await dio.delete(path);

    return response.data;
  }
}
