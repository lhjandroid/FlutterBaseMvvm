import 'dart:io';

import 'package:dio/dio.dart';

class Config {
  static const DEBUG = false;
  static const HTTP_PROXY = "PROXY 172.16.172.155:6789";

  static const TOKEN_KEY = 'token';
}

///存放各个网络请求的地址
class HttpApi {
  static const String BASE_URL = 'https://mine.lhj.cn';
}

class HttpConfig {
  /// 默认网络设置
  /// BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
  static BaseOptions options = BaseOptions(
    //请求基地址,可以包含子路径
    baseUrl: HttpApi.BASE_URL,
    //连接服务器超时时间，单位是毫秒.
    connectTimeout: 10000,
    //响应流上前后两次接受到数据的间隔，单位为毫秒。
    receiveTimeout: 5000,
    //Http请求头.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json;charset=UTF-8",
      HttpHeaders.acceptEncodingHeader: "gzip",
      "x-version": "v4",
      "version": "1.0.0",
    },
    //请求的Content-Type
    contentType: Headers.jsonContentType,
    //表示期望以那种格式(方式)接受响应数据。接受三种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
    responseType: ResponseType.plain,
  );

  static Future<dynamic> _addCommon(Map<String, dynamic> data) async {
    return data;
  }
}