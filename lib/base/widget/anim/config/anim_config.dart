/// 动画配置
class AnimConfig {
  //动画配置
  int duration; //时长
  double offset; //偏移大小
  PlayMode playMode; // 播放模式
  AnimConfig({this.duration, this.offset,this.playMode});
}

/// 动画模式
enum PlayMode {
  repeat, // 循环播放
  forward// 播放一次并回到原处
}