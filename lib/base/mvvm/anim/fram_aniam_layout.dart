import 'package:flutter/material.dart';

/// 帧动画工具类
class MFFramAnimLayout extends StatefulWidget {

  final double width;
  final double height;
  final int duration;
  final List<String> paths;

  MFFramAnimLayout(this.paths,
      {this.width: 100, this.height: 100, this.duration: 1000});

  @override
  State<StatefulWidget> createState() {
    return _MFFramAnimLayoutState();
  }
}

class _MFFramAnimLayoutState extends State<MFFramAnimLayout>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget?.duration));
    _animation = IntTween(begin: 0, end: widget.paths.length - 1 ?? 0)
        .animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Image.asset(
          widget.paths[_animation?.value],
          gaplessPlayback: true,
          width: widget?.width,
          height: widget?.height,
        )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
