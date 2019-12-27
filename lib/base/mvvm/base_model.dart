import 'package:base_mvvm/base/network/mf_dio_api.dart';
import 'package:rxdart/rxdart.dart';

class BaseModel {

  /// post请求
  Observable post(String url,{Map<String, dynamic> param}) {
    return MFDioApi.getInstance().post(url,data: param);
  }

  /// get请求
  Observable get(String url,{Map<String, dynamic> param}) {
    return MFDioApi.getInstance().get(url,data: param);
  }
}