import 'package:flutter/material.dart';

import 'base_state_view.dart';

/// mvvm管理工具
class MvvmX {
  // 生命周期观察
  static final navigatorKey = new GlobalKey<NavigatorState>();
  // 关闭原生界面的实现
  static Function finishNativePage;

  /// 打开页面
  static pagePop<T extends Object>(T params) async {
    BuildContext context = navigatorKey.currentState.overlay.context;
    // 如果没有拿到context
    if (context == null) {
      context = await Future.delayed(Duration.zero, () {
        return navigatorKey.currentState.overlay.context;
      });
    }
    bool haveState = false;
    if (context is StatefulElement) {
      haveState = context.state != null;
    }
    // 如果能够内部返回 直接调用flutterPop
    if (haveState && context != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(params);
    } else {
      // 混合开发，最后一次退出的时候，不会调用根Flutter页面的dispose方法。
      // 如果需要释放资源，实现onBackAsync()方法进行释放
      if (context != null && context is StatefulElement && context.state is BaseStateView) {
        await (context.state as BaseStateView).onBackAsync();
      }
      // finish native page
      finishNativePage?.call();
    }
  }

  /// 打开新页面
  static pushPage(String pageName, Object arguments) async {
    BuildContext context = navigatorKey.currentState.overlay.context;
    // 如果没有拿到context 通过Future去取
    if (context == null) {
      context = await Future.delayed(Duration.zero, () {
        return navigatorKey.currentState.overlay.context;
      });
    }
    Navigator.of(context).pushNamed(pageName, arguments: arguments);
  }

  /// 获取context
  static Future<BuildContext> getContext() async {
    BuildContext context = navigatorKey.currentState.overlay.context;
    // 如果没有拿到context
    if (context == null) {
      return Future.delayed(Duration.zero, () {
        return navigatorKey.currentState.overlay.context;
      });
    }
    return Future.value(context);
  }
}
