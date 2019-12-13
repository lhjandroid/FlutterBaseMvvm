import 'package:flutter/material.dart';
import 'package:base_mvvm/base/utils/common_util.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

/// view基础类
abstract class BaseView<T extends BaseViewModel> extends StatefulWidget
    implements IView {
  /// viewModel
  T viewModel;

  @override
  State<StatefulWidget> createState() {
    viewModel = createViewModel();
    return BaseViewState(this, viewModel, registProviders());
  }

  /// 创建ViewModel
  T createViewModel();

  /// 显示loading页面
  void showLoading() {
    viewModel?.setViewState(PageState.loading);
  }

  /// 显示内容
  void showContent() {
    viewModel?.setViewState(PageState.content);
  }

  /// 显示错误页面
  void showError() {
    viewModel?.setViewState(PageState.error);
  }

  /// 是否需要有多状态布局 默认需要
  bool canLoading() {
    return true;
  }

  /// 注册其它的provider 默认没有其它provider
  List registProviders() {
    return null;
  }

  /// 构造加载中页面
  Widget createLoadingView() {
    return null;
  }

  /// 构造错误提示页面
  Widget createErrorPageView() {
    return null;
  }
}

class BaseViewState<T extends BaseViewModel> extends State<BaseView> {
  /// 布局构造状态
  IView _iView;

  /// 对应viewModel
  T _viewModel;

  /// 其它provider
  var _providers;

  BaseViewState(this._iView, this._viewModel, this._providers);

  @override
  void initState() {
    super.initState();
    _iView?.viewInit(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget contentView = _iView?.buildView(context);
    _iView?.viewReady(context);
    return MultiProvider(
      providers: createProviders(),
      child: Stack(
        children: createPageView(contentView),
      ),
    );
  }

  /// 构造页面内容
  List<Widget> createPageView(Widget contentView) {
    List<Widget> widgets = List();
    widgets.add(contentView);
    if (_iView?.canLoading()) {
      // 加载中页面
      Widget loadingView = createStateView(_iView?.createLoadingPageView(), PageState.loading);
      if (loadingView != null) {
        widgets.add(loadingView);
      }
      // 错误页面
      Widget errorView = createStateView(_iView?.createErrorPageView(), PageState.error);
      if (errorView != null) {
        widgets.add(errorView);
      }
    }
    return widgets;
  }

  Widget createStateView(Widget stateView,PageState state) {
    if (stateView == null) {
      return null;
    }
    // 加载布局
    Widget sate = Consumer(
        builder: (context, T viewModel, _) => Visibility(
          child: stateView,
          visible: viewModel.pageState == state,
        )
    );
    return sate;
  }

  /// 创建别的 状态值监听器
  List<ChangeNotifierProvider> createProviders() {
    List<ChangeNotifierProvider> providers = List();
    var baseProvider = ChangeNotifierProvider(
      builder: (context) => _viewModel,
    );
    providers.add(baseProvider);
    if (!CommonUtil.isEmpt(_providers)) {
      providers.addAll(_providers);
    }
    return providers;
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }
}

abstract class IView {
  /// 布局初始化之前调用
  @protected
  void viewInit(BuildContext context);

  /// 创建布局
  @protected
  Widget buildView(BuildContext context);

  /// 布局创建完成后调用
  @protected
  void viewReady(BuildContext context);

  /// 是否需要多状态布局
  bool canLoading();

  /// 构造loadingView
  Widget createLoadingPageView();

  /// 构造错误提示页面
  Widget createErrorPageView();
}

/// 页面状态
enum PageState {
  // 加载中
  loading,
  // 显示内容
  content,
  // 错误页
  error
}
