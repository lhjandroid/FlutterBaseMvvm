import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'base_page_loading_state.dart';

/// 页面多状态管理
class PageStateViewModel with ChangeNotifier{

  // 初始化页面状态
  PageState _pageState = PageState.loading;

  // 显示菊花转圈 ios风格
  Tuple2<bool, String> _isShowLoading = Tuple2(false, "");

  PageState get pageState => _pageState;

  set pageState(PageState value) {
    _pageState = value;
    notifyListeners();
  }

  Tuple2<bool, String> isShowLoading() {
    return _isShowLoading;
  }

  /// 设置loading状态 ios转菊花的控件
  changeShowLoading(bool showLoading, {String loadingMessage = ""}) {
    this._isShowLoading = Tuple2(showLoading, loadingMessage);
    notifyListeners();
  }
}