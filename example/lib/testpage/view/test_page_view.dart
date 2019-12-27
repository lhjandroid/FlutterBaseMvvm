import 'package:base_mvvm/base/mvvm/base_view.dart';
import 'package:example/testpage/viewmodel/test_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TestPageView extends BaseView<TestViewModel> {
  @override
  Widget buildView(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Consumer(
            builder: (context, TestViewModel testViewModel, _) => Stack(
                  children: <Widget>[
                    Center(
                      child: Text('${testViewModel.num}',style: TextStyle(fontSize: 16),),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Text('click to change',style: TextStyle(fontSize: 16),),
                        onTap: () {
                          testViewModel.getNum();
                        },
                      ),
                    )
                  ],
                )),
      ],
    ));
  }

  @override
  void viewInit(BuildContext context) {}

  @override
  void viewReady(BuildContext context) {
    viewModel.getNum();
  }

  @override
  TestViewModel createViewModel() {
    return TestViewModel();
  }

}
