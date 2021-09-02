
import 'package:base_mvvm/base/mvvm/base_view_model.dart';
import 'package:flutter/material.dart';

/// 错误页面布局
class MFPageError<T extends BaseViewModel> extends StatelessWidget {
  final T viewModel;
  final String errorImageName;
  final String errorButtonText;
  final Function onBack;

  // 返回按钮距离顶部的距离
  final double backButtonTopOffset;

  const MFPageError(
      {Key key,
      @required this.viewModel,
      this.errorImageName = 'images/network_error.png',
      this.onBack,
      this.backButtonTopOffset = 0,
      this.errorButtonText = '重新加载'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    errorImageName,
                    width: 345,
                    height: 260,
                  ),
                  GestureDetector(
                    onTap: () => viewModel?.onNetErrorClick(),
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration:
                          BoxDecoration(color: Color(0xFFFF4891), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        errorButtonText,
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: onBack != null,
              child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: backButtonTopOffset, left: 16),
                  child: Image.asset(
                    'images/icon_back_collapsed.png',
                    width: 34,
                    height: 34,
                  ),
                ),
                onTap: () {
                  onBack?.call();
                },
              ),
            ),
          ],
        ));
  }
}
