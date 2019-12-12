import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class MFApiService<T> {

  Dio dio;
  MFApiService(this.dio);

  //get请求结构
  Future _get(String url, {data, options, cancelToken}) async {
    Response response;
    Map<String, dynamic> map;

    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      formatError(e);
    }
    try {
      map = json.decode(response.data);
    } catch (e) {

    }
    return map;
  }
  //post
  Future _post(String url, {data, options, cancelToken,datakey: true}) async {
    var response;
    Map<String, dynamic> map;
    Map<String, T> param;

    param = Map.castFrom(await _getParamUrl());

    dio.lock();
    _addCommon(data).then((value) {
      data = value;
    }).whenComplete(() => dio.unlock());

    try {
      response = await dio.post(url,
          data: data,
          queryParameters: param,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e) {
      formatError(e);
    }
    try {
      map = json.decode(response.data);
    } catch (e) {

    }
    return map;
  }

  Observable post(url, {data, options, cancelToken, ignoreTDK: false}) =>
      Observable.fromFuture(_post(url,cancelToken: cancelToken,options: options)).asBroadcastStream();


  Observable get(String url, {data, options, cancelToken}) =>
      Observable.fromFuture(_get(url, options: options,cancelToken: cancelToken)).asBroadcastStream();


  // POST请求追加公共参数
  Future<dynamic> _addCommon(Map<String, dynamic> data) async {
    return data;
  }

  // 请求追加URL参数
  Future<dynamic> _getParamUrl() async {
    Map<String, Object> map = {};
    return map;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }


  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
            //进度
            print("$count $total");
          });
    } on DioError catch (e) {
      formatError(e);
    }
    return response.data;
  }

}