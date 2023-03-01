import 'package:flutter/widgets.dart';

/// Item被展示后的回调
typedef ItemAppearCallback = void Function(List<ItemAppearModel> items);

/// 视图Item完全暴露在屏幕上计入曝光
/// 可用于统计 瀑布流WaterFlow、ListView、GridView 的 Item的曝光事件
class ItemAppear extends StatefulWidget {
  /// 是否重复 默认不重复(Item重新曝光不统计数据)
  final bool repeat;

  /// 子视图的滚动方向，默认为垂直方向
  final Axis scrollDirection;

  /// 数据源 需要继承至 ItemAppearModel
  final List<ItemAppearModel> items;

  /// Item被展示后的回调
  final ItemAppearCallback callback;

  /// 子视图，必须为可滚动组件，如 瀑布流WaterFlow、ListView、GridView等
  final Widget child;

  const ItemAppear({
    Key? key,
    this.repeat = false,
    this.scrollDirection = Axis.vertical,
    required this.items,
    required this.callback,
    required this.child,
  }) : super(key: key);

  @override
  State<ItemAppear> createState() => _ItemAppearState();
}

class _ItemAppearState extends State<ItemAppear> {
  /// 当前整体视图的 GlobalKey
  final GlobalKey selfKey = GlobalKey();

  /// 当前整体视图的偏移位置（左上角）
  double dx = 0.0;
  double dy = 0.0;

  /// 当前整体视图的宽高
  double width = 0.0;
  double height = 0.0;

  /// 当前整体视图的 最小宽(高)度 和 最大宽(高)度
  double min = 0.0;
  double max = 0.0;

  /// 已出现的Item，返回回调时的结果
  List<ItemAppearModel> appearBucket = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initConfig());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initConfig();
  }

  /// 初始化整体视图的相关参数
  void initConfig() {
    RenderObject? renderObject = selfKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;
    Offset offset = renderObject.localToGlobal(Offset.zero);
    Size size = renderObject.size;
    dx = offset.dx;
    dy = offset.dy;
    width = size.width;
    height = size.height;
    if (widget.scrollDirection == Axis.vertical) {
      min = dy;
      max = dy + height;
    } else {
      min = dx;
      max = dx + width;
    }
    calculate();
  }

  void calculate() {
    appearBucket.clear();
    for (var item in widget.items) {
      RenderObject? renderObject = item.key.currentContext?.findRenderObject();
      if (renderObject == null || renderObject is! RenderBox) continue;
      Offset offset = renderObject.localToGlobal(Offset.zero);
      Size size = renderObject.size;
      // 如果需要重复统计
      if (widget.scrollDirection == Axis.vertical) {
        if (offset.dy < min || offset.dy + size.height > max) {
          if (widget.repeat) item.isAppear = false;
          continue;
        }
      } else {
        if (offset.dx < min || offset.dx + size.width > max) {
          if (widget.repeat) item.isAppear = false;
          continue;
        }
      }
      // 已经曝光的Item直接跳过
      if (item.isAppear) continue;
      // 将曝光的Item加入bucket
      item.isAppear = true;
      appearBucket.add(item);
    }
    widget.callback.call(appearBucket);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      key: selfKey,
      onNotification: (notification) {
        // 滚动结束回调
        if (notification is ScrollEndNotification) {
          calculate();
        }
        return true;
      },
      child: widget.child,
    );
  }
}

abstract class ItemAppearModel {
  /// 用于获取和定位当前Item
  final GlobalKey key = GlobalKey();

  /// 当前Item是否已经展示过
  bool isAppear = false;
}
