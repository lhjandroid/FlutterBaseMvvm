
import 'package:base_mvvm/base/network/mf_dio_api.dart';
import 'package:dio/dio.dart';

/// 网络请求相关
class BaseService {

  /// post请求
  Stream post(String url,{
    dynamic param,
    Options options,
    CancelToken cancelToken,
    bool ignoreTDK: false,
  }) {
    return MFDioApi.getInstance().post(url,data: param,options: options);
  }

  /// get请求
  Stream get(String url,{
    dynamic param,
    Options options,
    CancelToken cancelToken,
    bool ignoreTDK: false,
    bool needJson: true,
  }) {
    return MFDioApi.getInstance().get(url,data: param,options: options,needJson: needJson);
  }
}