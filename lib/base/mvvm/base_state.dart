import 'package:flutter/material.dart';

/// 状态布局类 支持动画和直接push类名 支持屏幕适配相关
abstract class BaseState<T extends StatefulWidget> extends State<T> {


  ///为state生成widget
  Widget generatePage({Key key}) {
    return _CommonPageWidget(
      state: this,
      key: key,
    );
  }
}

/// 通用页面构造
class _CommonPageWidget extends StatefulWidget {
  final State state;

  const _CommonPageWidget({Key key, this.state}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return state;
  }
}
