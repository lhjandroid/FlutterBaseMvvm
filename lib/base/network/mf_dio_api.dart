import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:base_mvvm/base/config/config.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'mf_api_service.dart';

class MFDioApi {

  static MFDioApi instance;
  static MFApiService mfApiService;
  Dio _dio;

  CancelToken cancelToken = new CancelToken();

  MFDioApi() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    var options = new BaseOptions(
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

    _dio = new Dio(options);

    // 设置代理
    if (Config.DEBUG) {
      setProxy();
    }

    //Cookie管理
    _dio.interceptors.add(CookieManager(CookieJar()));

    // 添加拦截器
//    _dio.interceptors.add(new HeaderInterceptors(_dio));
//    _dio.interceptors.add(new LogsInterceptors());
//    _dio.interceptors.add(new ResponseInterceptors());

    mfApiService = MFApiService(_dio);
  }

  // 设置代理，mock数据使用charles抓包传统设置抓不到
  void setProxy() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return Config.HTTP_PROXY;
      };

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; //忽略证书
    };
  }

  static MFApiService getInstance() {
    if (mfApiService == null) {
      instance = MFDioApi();
    }
    return _getApiService();
  }

  static MFApiService _getApiService() {
    return mfApiService;
  }
}
