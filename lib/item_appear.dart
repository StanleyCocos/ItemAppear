import 'package:flutter/cupertino.dart';


/*
*  item 出现回调
*  @items: 出现的item 数据源
* */
typedef ItemAppearCallback = void Function(List<ItemAppearModel> items);


/*
*  计算子视图(列表) 完全展示屏幕
* */
class ItemAppear extends StatefulWidget {

  /*
  * 子视图(必须是 list grid 或流式布局)
  * */
  final Widget child;

  /*
  *  数据源 继承至ItemAppearModel
  * */
  final List<ItemAppearModel> items;


  /*
  *  是否重复 默认不重复(重复刷到数据不统计)
  * */
  final bool repeat;

  /*
  *  出现回调
  * */
  final ItemAppearCallback? callback;


  const ItemAppear({Key? key, required this.child, required this.items, this.repeat = false, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemAppearState();
}

class _ItemAppearState extends State<ItemAppear> {

  final GlobalKey _selfKey = GlobalKey();
  double _dy = 0.0;
  double _dx = 0.0;
  double _width = 0.0;
  double _height = 0.0;
  double _min = 0.0;
  double _max = 0.0;
  List<ItemAppearModel> appear = [];


  @override
  void initState() {
    WidgetsBinding.instance!
        .addPostFrameCallback((_){
      _initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      key: _selfKey,
      onNotification: (ScrollNotification notification) {
        //开始滚动
        if (notification is ScrollStartNotification) {
          // print("开始滚动");
        } else if (notification is ScrollUpdateNotification) {
          // print("正在滚动---总滚动的距离${notification.metrics.maxScrollExtent}");
          // print("正在滚动---已经滚动的距离${notification.metrics.pixels}");
        } else if (notification is ScrollEndNotification) {
          // print("结束滚动");
          _calculate();
        }
        return true;
      },
      child: widget.child,
    );
  }

  void _initData(){
    var renderBoxRed = _selfKey.currentContext?.findRenderObject();
    if (renderBoxRed != null && renderBoxRed is RenderBox) {
      var size = renderBoxRed.size;
      var offset = renderBoxRed.localToGlobal(Offset.zero);
      // print("父视图: x: ${offset.dx} y: ${offset.dy}  width: ${size.width} height: ${size.height}");
      _dy = offset.dy;
      _dx = offset.dx;
      _width = size.width;
      _height = size.height;
      _min = _dy;
      _max = _dy + size.height;

      _calculate();
    }
  }


  void _calculate(){
    appear.clear();
    for(int index = 0; index < widget.items.length; index ++){
      ItemAppearModel item = widget.items[index];
      var renderBoxRed = item.key.currentContext?.findRenderObject();
      if (renderBoxRed != null && renderBoxRed is RenderBox) {
        var size = renderBoxRed.size;
        var offset = renderBoxRed.localToGlobal(Offset.zero);
        if (offset.dy < _min || offset.dy + size.height > _max) {
          if(widget.repeat) item.isAppear = false;
          continue;
        }
        if(item.isAppear) continue;

        item.isAppear = true;
        appear.add(widget.items[index]);

      } else {
        if(widget.repeat) item.isAppear = false;
      }
    }
    widget.callback?.call(appear);
  }
}


abstract class ItemAppearModel {
  GlobalKey key = GlobalKey();
  bool isAppear = false;
}