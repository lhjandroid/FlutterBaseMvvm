import 'package:base_mvvm/base/mvvm/base_view_model.dart';
import 'package:example/testpage/model/test_model.dart';

class TestViewModel extends BaseViewModel {

  int _num;
  TestModel _testModel;

  TestViewModel() {
    _testModel = TestModel();
  }

  void getNum() {
    excute(_testModel.getNumber(), (data)=> {
      setNum(data)
    });
  }

  setNum(int data) {
    _num = data;
    notifyListeners();
  }

  int get num => _num;
}