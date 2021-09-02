import 'package:base_mvvm/base/mvvm/base_page_loading_state.dart';
import 'package:base_mvvm/base/mvvm/base_state_view.dart';
import 'package:example/testpage/viewmodel/test_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPageView extends BaseStateView<TestViewModel> {
  @override
  Widget buildView(BuildContext context) {
    return Stack(
      children: <Widget>[
        Consumer(
          builder: (context, TestViewModel testViewModel, _) => Stack(
            children: <Widget>[
              Text(testViewModel.htmlText ?? '未获取到'),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: Text(
                    '${testViewModel?.num ?? 0}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Container(
                    width: 120,
                    height: 60,
                    alignment: Alignment.center,
                    color: Colors.amberAccent,
                    child: Text(
                      'click to change',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  onTap: () {
                    testViewModel.getNum();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  String getTitle() {
    return '测试页面';
  }

  @override
  TestViewModel createViewModel() {
    return TestViewModel();
  }

  @override
  initPageState(BuildContext context) {
    viewModel.setPageState(PageState.loading);
    Future.delayed(Duration(seconds: 3), () {
      viewModel.setPageState(PageState.content);
    });
    Future.delayed(Duration(seconds: 6), () {
      viewModel.setPageState(PageState.error);
    });
    Future.delayed(Duration(seconds: 9), () {
      viewModel.setPageState(PageState.content);
      viewModel.getBaidu();
    });
  }
}
