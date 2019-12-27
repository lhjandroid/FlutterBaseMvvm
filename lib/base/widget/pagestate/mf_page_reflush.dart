import 'package:flutter/material.dart';
import 'package:base_mvvm/base/widget/anim/fram_aniam_layout.dart';

/// 刷新中布局
class MFPageReflush extends StatelessWidget {

  final List<String> _paths;

  MFPageReflush(this._paths);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Container(
        child: Center(
            child: MFFramAnimLayout(
              _paths,
              width: 124,
              height: 80,
              duration: 2000,
            )
        ),
      ),
    );
  }
}
