import 'package:base_mvvm/base/mvvm/mvvm_x.dart';
import 'package:base_mvvm/base/mvvm/router/page_router.dart';
import 'package:example/testpage/view/test_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  MvvmX.finishNativePage = () {
    print('111111');
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPageView().generatePage(),
      navigatorKey: MvvmX.navigatorKey, // 必须设置
      navigatorObservers: [
        pageRouter,
      ],
    );
  }
}
