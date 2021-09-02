import 'dart:async';

import 'package:base_mvvm/base/config/config.dart';
import 'package:base_mvvm/base/mvvm/base_page_loading_state.dart';
import 'package:base_mvvm/base/mvvm/base_state.dart';
import 'package:base_mvvm/base/mvvm/eventbus/base_event_bus.dart';
import 'package:base_mvvm/base/mvvm/statepage/indicator.dart';
import 'package:base_mvvm/base/mvvm/statepage/mf_page_empty.dart';
import 'package:base_mvvm/base/mvvm/statepage/page_loading.dart';
import 'package:base_mvvm/base/mvvm/statistics/statistics_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'base_view_model.dart';
import 'page_state_view_model.dart';
import 'router/page_router.dart';
import 'statepage/mf_page_error.dart';

///切换状态栏 模式：light or dark
abstract class BasePageState<T extends BaseViewModel> extends BaseState
    with RouteAware, _RouteHandler, WidgetsBindingObserver, AutomaticKeepAliveClientMixin
    implements IView {
  // 是否是暗状态栏
  bool isDark = false;

  //是否是首次展示
  bool isFirstShow = true;

  T viewModel;

  /// 其它provider
  List<ChangeNotifierProvider> _providers;

  /// 设置标题
  String getTitle() => "";

  /// 设置标题widget, 优先级高于[getTitle]
  Widget getTitleWidget() => null;

  /// 导航栏右边的元素
  List<Widget> getAppBarRightItems() => null;

  EdgeInsetsGeometry appBarRightItemPadding() => EdgeInsets.only(right: 10);

  bool get resizeToAvoidBottomInset => true;

  // event事件
  List<StreamSubscription> eventBusList = List();

  /// 更改标题
  void changeTitle(String title) {
    viewModel?.title = title;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viewModel = createViewModel();
    viewModel?.title = getTitle();
    viewModel?.appBarRightItems = getAppBarRightItems();
    initPageState(context);
  }

  /// 是否保持状态
  @override
  bool get wantKeepAlive => keepAlive();

  @override
  bool keepAlive() {
    return false;
  }

  /// titleView
  @override
  Widget createAppBar(BuildContext ctx) {
    Widget titleWidget = getTitleWidget();
    return AppBar(
      title: titleWidget != null
          ? titleWidget
          : Selector(
              builder: (ctx, String title, _) {
                return Text(
                  title ?? "",
                  style: TextStyle(color: Color(0xFFFF474245),fontSize: 16),
                );
              },
              selector: (ctx, T model) {
                return model.title;
              },
            ),
      actions: <Widget>[
        Selector<T, List<Widget>>(
          selector: (ctx, T viewModel) => viewModel.appBarRightItems,
          builder: (ctx, items, _) {
            if (items == null) return Container();
            return Padding(
              padding: appBarRightItemPadding(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: items,
              ),
            );
          },
        )
      ],
      centerTitle: true,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: getAppBarElevation(),
      leading: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Image.asset(
            Config.backImage,
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          ),
        ),
        onTap: () {
          print('onTap');
          onBack();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 注册eventBus的地方

    return MultiProvider(
        providers: createProviders(context),
        child: AnnotatedRegion(child: createPage(context, buildView(context)), value: SystemUiOverlayStyle.dark));
  }

  /// 获取页面
  Scaffold createPage(BuildContext context, Widget contentView) {
    if ((showTitleBar() ?? true)) {
      return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight((showTitleBar() ?? true) ? 44.0 : 0),
          child: createAppBar(context) ?? null,
        ),
        body: Stack(
          children: createPageView(contentView, context),
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: createPageView(contentView, context),
        ),
      );
    }
  }

  /// 构造页面内容
  List<Widget> createPageView(Widget contentView, BuildContext context) {
    List<Widget> widgets = List();
    widgets.add(contentView);
    // 转圈提示
    widgets.add(createLoadingView());

    bool canLoading = showMultiPageState();
    if (canLoading) {
      // 加载中页面
      Widget loadingView = createStateView(createLoadingPageView(), PageState.loading);
      if (loadingView != null) {
        widgets.add(
          Positioned(
            child: loadingView,
            left: 0,
            top: ((showStatusPageBackButton() ?? true) || statePagePaddingEnable()) ? titleBarStatusPageOffset() : 0,
            right: 0,
            bottom: 0,
          ),
        );
      }
      // 错误页面
      Widget errorView = createStateView(createErrorPageView(), PageState.error);
      if (errorView != null) {
        widgets.add(
          Positioned(
            child: errorView,
            left: 0,
            top: ((showStatusPageBackButton() ?? true) || statePagePaddingEnable()) ? titleBarStatusPageOffset() : 0,
            right: 0,
            bottom: 0,
          ),
        );
      }
      // 空页面
      Widget emptyView = createStateView(createEmptyPageView(), PageState.empty);
      if (emptyView != null) {
        widgets.add(
          Positioned(
            child: emptyView,
            left: 0,
            top: ((showStatusPageBackButton() ?? true) || statePagePaddingEnable()) ? titleBarStatusPageOffset() : 0,
            right: 0,
            bottom: 0,
          ),
        );
      }
    }
    return widgets;
  }

  /// 创建页面多状态
  Widget createStateView(Widget stateView, PageState state) {
    if (stateView == null) {
      return null;
    }
    // 加载布局
    Widget sate = Selector(
      builder: (context, PageState pageState, _) => Visibility(
        child: stateView,
        visible: pageState == state,
      ),
      selector: (context, PageStateViewModel model) => model.pageState,
    );
    return sate;
  }

  /// 菊花转圈布局
  Widget createLoadingView() {
    return Selector<PageStateViewModel, Tuple2<bool, String>>(
        builder: (context, isShow, _) {
          bool hasText = false;
          List<Widget> children = [];
          if (isShow.item1) {
            children.add(ActivityIndicator(
              animating: true,
              radius: 20,
            ));
          }
          if (isShow.item2?.isNotEmpty ?? false) {
            hasText = true;
            children.add(Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: (Text(
                isShow.item2 ?? "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.white),
              )),
            ));
          }

          return Visibility(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints(
                        minWidth: 80, maxWidth: hasText ? 180 : 80, minHeight: 80, maxHeight: hasText ? 120 : 80),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(188),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
            visible: isShow.item1 ?? false,
          );
        },
        selector: (context, PageStateViewModel mode) => mode.isShowLoading());
  }

  /// 创建别的 状态值监听器
  List<ChangeNotifierProvider> createProviders(BuildContext context) {
    List<ChangeNotifierProvider> providers = List();
    var baseProvider = ChangeNotifierProvider.value(value: viewModel);
    providers.add(baseProvider);
    _providers = registerProviders(context);
    if (_providers != null && _providers.isNotEmpty) {
      // 添加别的model
      providers.addAll(_providers);
    }

    bool showPageState = showMultiPageState();
    // 添加页面多状态布局
    if (showPageState && (viewModel?.pageStateModel ?? null) != null) {
      var pageStateProvider = ChangeNotifierProvider(create: (context) => viewModel?.pageStateModel);
      providers.add(pageStateProvider);
    }
    return providers;
  }

  /// 创建ViewModel
  T createViewModel();

  Widget createSkeletonView() {
    return null;
  }

  /// 显示loading页面
  void showLoading() {
    viewModel?.setPageState(PageState.loading);
  }

  /// 显示内容
  void showContent() {
    viewModel?.setPageState(PageState.content);
  }

  /// 显示错误页面
  void showError() {
    viewModel?.setPageState(PageState.error);
  }

  /// 空页面
  void showEmpty() {
    viewModel?.setPageState(PageState.empty);
  }

  @override
  void initEventBus(BuildContext context) {}

  /// 显示转菊花的控件
  showLikeIosLoading() {
    viewModel?.changeLikeIosLoading(true);
  }

  /// 隐藏转菊花控件
  hideLikeIosLoading() {
    viewModel?.changeLikeIosLoading(false);
  }

  /// 是否需要有多状态布局 默认需要
  bool showMultiPageState() {
    return true;
  }

  /// 注册其它的provider 默认没有其它provider
  List<ChangeNotifierProvider> registerProviders(BuildContext context) {
    return null;
  }

  /// 构造加载中页面
  Widget createLoadingPageView() {
    return MFPageLoading(
        onBack: showStatusPageBackButton() ? onBack : null, backButtonTopOffset: topStatusPageBackButtonOffset());
  }

  /// 构造错误提示页面
  Widget createErrorPageView() {
    return MFPageError(
        viewModel: viewModel,
        errorImageName: errorImageName(),
        errorButtonText: errorButtonText(),
        onBack: showStatusPageBackButton() ? onBack : null,
        backButtonTopOffset: topStatusPageBackButtonOffset());
  }

  ///错误页的图片名称
  String errorImageName() {
    return Config.errorImageName;
  }

  ///错误页的按钮文案
  String errorButtonText() {
    return '重新加载';
  }

  /// 构造空页面
  @override
  Widget createEmptyPageView() {
    return MFPageEmpty(
        viewModel: viewModel,
        imagePath: emptyImageName(),
        buttonText: emptyButtonText(),
        hiddenRefresh: emptyHiddenRefresh(),
        onBack: showStatusPageBackButton() ? onBack : null,
        backButtonTopOffset: topStatusPageBackButtonOffset());
  }

  ///空态页的图片名称
  String emptyImageName() {
    return 'images/pic_empty_default.png';
  }

  ///空态页的按钮文案
  String emptyButtonText() {
    return '重新加载';
  }

  ///空态页的按钮是否隐藏，默认不显示
  bool emptyHiddenRefresh() {
    return true;
  }

  /// 购招changeNotifier
  ChangeNotifierProvider createProvider<K extends ChangeNotifier>(K notifier) {
    ChangeNotifierProvider<K> changeNotifierProvider = ChangeNotifierProvider(
      create: (context) => notifier,
    );
    return changeNotifierProvider;
  }

  /// 界面可见 从后台切换到前台
  void resumed() {
    debugPrint('###resumed $currentPage  $prePage');
    // 如果不是当前页面  或者currentPage == prePage时 等于恢复时的页面表明当前已经是栈顶页面
    if (currentPage != this.runtimeType) {
      return;
    }
    if(!isFirstShow) {
      viewDidAppear();
    }
    isFirstShow = false;
  }

  /// 界面不可见 从前台切换到后台
  void paused() {
    isFirstShow = false;
  }

  /// 点击返回按钮
  void onBack() {

  }

  Future onBackAsync() async {}

  /// 通过设置阴影来达到分割线目的
  double getAppBarElevation() {
    return 0.2;
  }

  /// 注册eventBus
  void registerEventBus<T>(void onData(T data)) {
    eventBusList.add(eventBus.on<T>().listen(onData));
  }

  /// 是否显示标题
  @override
  bool showTitleBar() {
    return true;
  }

  /// 是否在多状态布局上显示返回按钮
  bool showStatusPageBackButton() {
    return false;
  }

  /// 多状态页面允许自定义padding
  bool statePagePaddingEnable() => false;

  /// 全屏空态页时的偏移量 如果有的页面延伸到了状态栏时此值需要加上状态栏的高度 防止无法点击到
  double topStatusPageBackButtonOffset() {
    return 44.0;
  }

  /// 当有titleBar时 多状态布局的偏移量
  double titleBarStatusPageOffset() {
    return 44.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageRouter.subscribe(this, ModalRoute.of(context));
  }

  //////////////////////////////////////////////////////
  ///页面出/入 监测
  //////////////////////////////////////////////////////

  /// 从前一个页面跳转到当前页面时
  @override
  void didPush() {
    // 更新页面栈 只记录前一个和当前的
    prePage = currentPage;
    currentPage = this.runtimeType;
    handleDidPush();
    initEventBus(context);
    onPageShow(true);
    super.didPush();
  }

  @override
  void didPop() async{
    handleDidPop();
    for (StreamSubscription subscription in eventBusList) {
      subscription?.cancel();
    }
    super.didPop();
  }

  /// didPopNext：在后一个页面关闭后，当前页面调起该方法；
  @override
  void didPopNext() {
    // 如果current和当前type相等此情况表明是对话框关闭触发的
    if (currentPage != this.runtimeType) {
      onPageShow(false);
    }
    currentPage = this.runtimeType;
    prePage = null;
    handleDidPopNext();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    prePage = this.runtimeType;
    handleDidPushNext();
    super.didPushNext();
  }

  /// 页面可见，从前一个页面跳转过来，或者从后一个页面返回到当前页面
  void onPageShow(bool isFromPush) {
    // isFromPush 是否是前一个页面push过来的
    debugPrint('### onPageShow $isFromPush');
    viewDidAppear();
  }

  @mustCallSuper
  void viewDidAppear() {
    if (getPageLabel()?.isNotEmpty ?? false) {

    }
  }

  /// 添加曝光数据
  void addExposureStatisticsData(String name,StatisticsData data) {
    viewModel?.addExposureStatisticsData(name,data);
  }

  /// 曝光在屏幕中的数据
  void exposureWidget() {
    viewModel?.exposureWidget();
  }

  /// 页面label
  String getPageLabel() {
    return '';
  }

  /// 生命周期
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      resumed();
    } else if (state == AppLifecycleState.paused) {
      paused();
    } else if (state == AppLifecycleState.detached) {
      detachedPage();
    }
  }

  @override
  void dispose() {
    pageRouter.unsubscribe(this);
    pageDispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 页面销毁
  @override
  void pageDispose() {}

  void detachedPage() {}
}

/// route aware's util
/// you can do something in this
/// e.g. create recordList at [_RouteHandler] and record something

mixin _RouteHandler on BaseState implements HandleRouteNavigate {
  @override
  void handleDidPop() {
    debugPrint("已经pop的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPush() {
    debugPrint("push后,显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPopNext() {
    debugPrint("pop后，将要显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPushNext() {
    debugPrint("push后，被遮挡的页面 ${this.runtimeType}");
  }
}

/// 路由相关 动作分发
abstract class HandleRouteNavigate {
  void handleDidPush();

  void handleDidPop();

  void handleDidPopNext();

  void handleDidPushNext();
}

abstract class IView {
  /// 初始化页面数据
  initPageState(BuildContext context);

  /// 创建布局
  @protected
  Widget buildView(BuildContext context);

  /// 是否显示标题
  bool showTitleBar();

  /// 是否需要多状态布局
  bool showMultiPageState();

  /// 构造loadingView
  Widget createLoadingPageView();

  /// 构造错误提示页面
  Widget createErrorPageView();

  /// 空页面
  Widget createEmptyPageView();

  /// 设置标题栏
  Widget createAppBar(BuildContext context);

  /// 显示转菊花的控件
  showLikeIosLoading();

  /// 隐藏转菊花控件
  hideLikeIosLoading();

  /// 注册eventBus的地方
  void initEventBus(BuildContext context);

  /// 是否保持状态
  bool keepAlive();

  /// 界面可见 从后台切换到前台
  void resumed();

  /// 界面不可见 从前台切换到后台
  void paused();

  /// 返回
  // void onBack();

  /// 页面销毁时
  void pageDispose();
}