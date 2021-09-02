import 'package:flutter/material.dart';

/// 通用埋点数据
class StatisticsData {
  
  final String label;
  final String event;
  final Map map;
  GlobalKey globalKey;

  StatisticsData(this.label, this.event, this.map) {
    this.globalKey  = GlobalKey();
  }

}