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

    _dio = new Dio(HttpConfig.options);

    // 设置代理
    if (Config.DEBUG) {
      setProxy();
    }

    //Cookie管理
    _dio.interceptors.add(CookieManager(CookieJar()));

    // 拦截器通过 getInstance.dio.interceptors.add添加

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
