import 'package:flutter/material.dart';

class MFPageLoading extends StatelessWidget {
  // 返回时间
  final Function onBack;
  
  // 返回按钮距离顶部的距离
  final double backButtonTopOffset;

  MFPageLoading({this.onBack,this.backButtonTopOffset = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                  child: Text('加载中'),
                ),
              ),
            ),
          ),
          Visibility(
            visible: onBack != null,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: backButtonTopOffset,left: 16),
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
