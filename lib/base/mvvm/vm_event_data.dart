/// VM数据
class VMEventData<T> {

  bool init = false;

  T value;

  /// 设置数据
  setValue(T value) {
    init = true;
    this.value = value;
  }
}