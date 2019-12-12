import 'package:flutter/material.dart';
import 'package:flutter_mvvm/base/widget/anim/fram_aniam_layout.dart';

/// 加载数据布局
class MFPageLoading extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    List<String> paths = List();
    paths.add('your image');

    return Container(
      color: Colors.white,
      child: Container(
        child: Center(
            child: MFFramAnimLayout(
              paths,
              width: 100,
              height: 100,
              duration: 500,
            )
        ),
      ),
    );
  }

}