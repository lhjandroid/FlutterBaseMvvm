import 'dart:async';

import 'package:base_mvvm/base/mvvm/page_state_view_model.dart';
import 'package:base_mvvm/base/mvvm/statistics/statistics_data.dart';
import 'package:flutter/material.dart';

import 'base_page_loading_state.dart';

/// ViewModel基类
class BaseViewModel with ChangeNotifier {

  List<StreamSubscription> subscriptionList = List();

  PageStateViewModel _pageStateModel;

  String title;

  List<Widget> appBarRightItems;

  // 需要曝光组件集合
  Map<String,StatisticsData> exposureStatistics = {};

  BaseViewModel() {
    _pageStateModel = PageStateViewModel();
  }

  void setPageStateModel(PageStateViewModel value) {
    _pageStateModel = value;
  }

  /// 设置页面状态
  void setPageState(PageState pageState) {
    _pageStateModel?.pageState = pageState;
  }

  /// 动态修改标题
  void changeTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  /// 动态修改导航栏右边的按钮
  void changeAppBarRightItems(List<Widget> appBarRightItems) {
    this.appBarRightItems = appBarRightItems;
    notifyListeners();
  }

  PageStateViewModel get pageStateModel => _pageStateModel;

  /// 执行网络请求
  void execute<T, E>(
      Stream<T> observable,
      void onData(T event), {
        void Function(E e) onTypeError,
        Function onError,
        void onDone(),
        bool cancelOnError,
      }) {
    subscriptionList.add(
      observable.listen(
        onData,
        onError: onTypeError == null
            ? onError
            : (error, stackTrace) {
          if (onTypeError is void Function(E)) {
            onTypeError(error);
          }
          if (onError != null) {
            if (onError is void Function(Object, StackTrace)) {
              onError(error, stackTrace);
            } else if (onError is void Function(Object)) {
              onError(error);
            } else {
              onError();
            }
          }
        },
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );
  }

  /// 空页面的点击事件
  void onDataEmptyClick() {}

  /// 网络错误点击
  void onNetErrorClick() {}

  /// 改变转菊花控件的状态
  void changeLikeIosLoading(bool isShow, {String loadingMessage}) {
    _pageStateModel?.changeShowLoading(isShow, loadingMessage: loadingMessage);
  }

  /// 添加曝光数据
  void addExposureStatisticsData(String name,StatisticsData data) {
    if (name?.isEmpty ?? true) {
      return;
    }
    exposureStatistics[name] = data;
  }

  /// 移除曝光数据
  void removeExposureStatisticsData(String name) {
    exposureStatistics?.remove(name);
  }

  /// 曝光控件
  void exposureWidget() {
    if (exposureStatistics?.isEmpty ?? true) {
      return;
    }
    GlobalKey globalKey;
    exposureStatistics.forEach((key, value) {
      globalKey = value.globalKey;
      if (globalKey != null) {
        // 判断控件是否在屏幕中
        RenderBox renderBox = globalKey?.currentContext?.findRenderObject();
        if (renderBox != null ) {
          var offset =  renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
//          if (offset != null && offset.dy > 0 && offset.dy < MFSizeFit.screenHeight) {
//
//          }
        }
      }
    });
  }

  /// 获取指定globalKey
  GlobalKey getGlobalKey(String name) {
    return exposureStatistics[name]?.globalKey;
  }

  @override
  void dispose() {
    for (StreamSubscription eventBusSb in subscriptionList) {
      eventBusSb?.cancel();
    }
    exposureStatistics.clear();
    super.dispose();
  }
}