import 'package:base_mvvm/base/mvvm/base_model.dart';
import 'package:rxdart/rxdart.dart';

class TestModel extends BaseModel {

  int num = 0;

  Observable<int> getNumber() {
    num += 1;
    return Observable.just(num).delay(Duration(seconds: 1));
  }
}