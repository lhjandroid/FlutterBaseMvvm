import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

const double _kDefaultIndicatorRadius = 10;
class ActivityIndicator extends StatefulWidget {
  const ActivityIndicator({
    Key key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
  }) : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        super(key: key);

  final bool animating;

  final double radius;

  @override
  _ActivityIndicatorState createState() => _ActivityIndicatorState();
}


class _ActivityIndicatorState extends State<ActivityIndicator> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating)
      _controller.repeat();
  }

  @override
  void didUpdateWidget(ActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _MFActivityIndicatorPainter(
          position: _controller,
          activeColor: Colors.white,
          radius: widget.radius,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;

const List<int> _alphaValues = <int>[255, 239, 222, 206, 189, 172, 155, 155, 155, 155, 155, 155];

class _MFActivityIndicatorPainter extends CustomPainter {
  _MFActivityIndicatorPainter({
    @required this.position,
    @required this.activeColor,
    double radius,
  }) : tickFundamentalRRect = RRect.fromLTRBXY(
    -radius,
    radius / _kDefaultIndicatorRadius,
    -radius / 2.0,
    -radius / _kDefaultIndicatorRadius,
    radius / _kDefaultIndicatorRadius,
    radius / _kDefaultIndicatorRadius,
  ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount; ++ i) {
      final int t = (i + activeTick) % _kTickCount;
      paint.color = activeColor.withAlpha(_alphaValues[t]);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MFActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position || oldPainter.activeColor != activeColor;
  }
}
