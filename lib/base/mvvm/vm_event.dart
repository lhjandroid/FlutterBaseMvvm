import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';
import 'vm_event_data.dart';

Container container = Container(width: 0, height: 0, color: Colors.white);

/// VM监听事件
class VMEvent<T extends BaseViewModel, V> extends StatelessWidget {
  Function valueChange; // 什么值的变化
  Function data; // 改变的数据

  VMEvent(
      {@required VMEventData<V> Function(T model) valueChange,
      @required Function(V value, BuildContext context) data}) {
    this.valueChange = valueChange;
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<T, VMEventData<V>>(builder: (context, VMEventData<V> value, _) {
      return LayoutBuilder(builder: (ctx, con) {
        if (value != null) {
          // 执行完主线任务后才会回调执行
          Future.delayed(Duration.zero, () {
            data?.call(value?.value, ctx);
            value.init = false;
          });
        }
        return container;
      });
    }, selector: (context, T model) {
      return valueChange.call(model);
    });
  }
}
