import 'package:flutter/material.dart';

import 'config/anim_config.dart';

/// 动画封装布局
class MFAnimLayout<T> extends StatefulWidget {
  // 动画属性
  final AnimConfig config;

  // 动画布局
  final Widget Function(T valu)builder;

  // 动画
  final Animatable animatable;

  MFAnimLayout({this.config, this.animatable, this.builder});

  @override
  State<StatefulWidget> createState() {
    return MFAnimLayoutState<T>(config, builder, this.animatable);
  }
}

class MFAnimLayoutState<T> extends State<MFAnimLayout>
    with SingleTickerProviderStateMixin {
  // 动画属性
  AnimConfig _animConfig;
  Widget Function(T value) builderAnim;

  // 动画
  Animation<T> _animation;
  // 动画
  Animatable _animatable;

  // 动画控制器
  AnimationController _controller;

  MFAnimLayoutState(this._animConfig, this.builderAnim, this._animatable);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animConfig.duration),
    );
    _animation = _animatable.animate(_controller);
    play(_controller, _animConfig);
  }

  /// 播放动画
  void play(AnimationController controller, AnimConfig animConfig) {
    switch (animConfig.playMode) {
      case PlayMode.repeat:
        controller.repeat();
        break;
      case PlayMode.forward:
        controller.forward();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: _animation,
        builder: (context,child)=> builderAnim(_animation.value)
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
