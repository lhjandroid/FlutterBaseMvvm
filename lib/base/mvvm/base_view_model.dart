import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'base_view.dart';

/// ViewModel基类
class BaseViewModel with ChangeNotifier {

  List<StreamSubscription> subscriptionList = List();

  // 初始化页面状态
  PageState pageState = PageState.loading;

  /// 设置页面状态
  void setViewState(PageState pageState) {
    this.pageState = pageState;
    notifyListeners();
  }

  /// 执行网络请求
  void excute(Observable observable, void onData(dynamic event),
      {Function onError, void onDone(), bool cancelOnError}) {
    subscriptionList.add(observable.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError));
  }

  @override
  void dispose() {
    for (StreamSubscription streamSubscription in subscriptionList) {
      streamSubscription.cancel();
    }
    super.dispose();
  }
}