import 'package:base_mvvm/base/mvvm/base_view_model.dart';
import 'package:flutter/material.dart';

/// 空态页
class MFPageEmpty<T extends BaseViewModel> extends StatelessWidget {
  final T viewModel;
  final String imagePath;
  final String buttonText;
  final bool hiddenRefresh;
  final Function onBack;

  // 返回按钮距离顶部的距离
  final double backButtonTopOffset;

  const MFPageEmpty({
    Key key,
    this.viewModel,
    this.imagePath,
    this.buttonText = '重新加载',
    this.hiddenRefresh = true,
    this.onBack,
    this.backButtonTopOffset = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  imagePath ?? "images/pic_empty_default.png",
                  width: 345,
                  fit: BoxFit.fitWidth,
                ),
                Offstage(
                  offstage: hiddenRefresh,
                  child: Material(
                    child: Ink(
                      padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                      child: InkWell(
                        child: Text(buttonText ?? '重新加载', style: TextStyle(color: Colors.white, fontSize: 15)),
                        onTap: () {
                          viewModel?.onDataEmptyClick();
                        },
                      ),
                      decoration:
                          BoxDecoration(color: Color(0xFFFF4891), borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                ),
                Container(
                  // 太距中不太好看
                  height: 140,
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
      ),
    );
  }
}
