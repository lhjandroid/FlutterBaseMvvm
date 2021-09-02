import 'package:base_mvvm/base/mvvm/base_model.dart';

class TestModel extends BaseService {

  int num = 0;

  Stream<int> getNumber() {
    return Stream.fromFuture(Future.delayed(Duration(seconds: 1),() {
      num += 1;
      return num;
    }));
  }

  Stream getHtmlText() {
    return get('https://www.jb51.net',needJson: false);
  }
}