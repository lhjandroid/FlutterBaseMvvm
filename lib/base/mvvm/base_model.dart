import 'package:flutter/material.dart';
import 'package:base_mvvm/base/network/mf_dio_api.dart';
import 'package:rxdart/rxdart.dart';

class BaseModel {

  /// post请求
  Observable post(@required String url,{Map<String, dynamic> param}) {
    return MFDioApi.getInstance().post(url,data: param);
  }

  /// get请求
  Observable get(@required String url,{Map<String, dynamic> param}) {
    return MFDioApi.getInstance().get(url,data: param);
  }
}