# flutter_mvvm

A new Flutter package.

## Getting Started

dependencies:
  base_mvvm: ^1.0.7
  
view
  ```
  class TestPageView extends BaseView<TestViewModel> {
  @override
  Widget buildView(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Consumer(
            builder: (context, TestViewModel testViewModel, _) => Stack(
                  children: <Widget>[
                    Center(
                      child: Text('${testViewModel.num}',style: TextStyle(fontSize: 16),),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Text('click to change',style: TextStyle(fontSize: 16),),
                        onTap: () {
                          testViewModel.getNum();
                        },
                      ),
                    )
                  ],
                )),
      ],
    ));
  }

  @override
  void viewInit(BuildContext context) {}

  @override
  void viewReady(BuildContext context) {
    viewModel.getNum();
  }

  @override
  TestViewModel createViewModel() {
    return TestViewModel();
  }

  @override
  Widget createLoadingPageView() {

    return null;
  }

  @override
  bool canLoading() {
    return false;
  }
}
  ```
model
```
class TestModel extends BaseModel {

  int num = 0;

  Observable<int> getNumber() {
    num += 1;
    return Observable.just(num).delay(Duration(seconds: 1));
  }
}
```
viewmodel
```
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
```

网络请求采用的rxdart+jsonseraziable
在model里可以直接
```
Observable<int> netWork() {
    return post('path',param);
  }
```
记住请在viewmodel里使用excute方法传入Observable 防止内存泄漏
