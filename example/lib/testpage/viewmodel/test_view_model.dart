import 'package:base_mvvm/base/mvvm/base_view_model.dart';
import 'package:example/testpage/model/test_model.dart';

class TestViewModel extends BaseViewModel {

  int _num;
  TestModel _testModel;
  String htmlText;

  TestViewModel() {
    _testModel = TestModel();
  }

  void getNum() {
    execute(_testModel.getNumber(), (data) {
      setNum(data);
    });
  }

  void getBaidu() {
    execute(_testModel.getHtmlText(), (event) {
      this.htmlText = event;
      notifyListeners();
    },onError: (e) {
      print(e);
    });
  }

  void setNum(int data) {
    _num = data;
    notifyListeners();
  }

  int get num => _num;
}