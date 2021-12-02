### flutter为item 添加完全展示在屏幕统计

#### 引入
```
appear:
    git:
      url: https://github.com/StanleyCocos/ItemAppear.git

``` 

#### 使用
1. 创建数据源
```
class Model extends ItemAppearModel {

  int index = 0;
  String name = "";
  double height = 100;
  Model({
    required this.index,
    required this.name,
    this.height = 100,
  });
}
```
2. 添加key
```
return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, position) {
        var model = list[position];
        return GestureDetector(
          child: Container(
            key: model.key,
            width: double.infinity,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text("$position"),
            ),
          ),
        );
      },
      itemCount: list.length,
    );
  }
```


3. 接收回调
```
ItemAppear(
  callback: (list){
  // 回调相应完整出现在屏幕的item
  list.forEach((element) {
    if (element is Model) {
      print("${element.index} 出现");
      }
     });
  },
  // 数据源
  items: list,
  // 需要统计的列表
  child: flow,
),

```


4. 完整例子
```
import 'dart:math';

import 'package:appear/appear.dart';
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Model extends ItemAppearModel {

  int index = 0;
  String name = "";
  double height = 100;
  Model({
    required this.index,
    required this.name,
    this.height = 100,
  });
}

class _MyHomePageState extends State<MyHomePage> {

  List<Model> list = [];

  @override
  void initState() {
    for (int index = 0; index <= 30; index++) {
      var model = Model(index: index, name: "${index}", height:  Random().nextInt(200).toDouble() + 100);
      list.add(model);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 100,
          bottom: 200,
        ),
        child: ItemAppear(
          // 是否可以重复统计
          repeat: false,
          // 回调相应完整出现在屏幕的item
          callback: (list){
            list.forEach((element) {
              if (element is Model) {
                print("${element.index} 出现");
              }
            });
          },
          // 数据源
          items: list,
          // 需要统计的列表
          child: flow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget get grid {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, position) {
        var model = list[position];
        return GestureDetector(
          child: Container(
            key: model.key,
            width: double.infinity,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text("$position"),
            ),
          ),
        );
      },
      itemCount: list.length,
    );
  }


  Widget get flow {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            // height: 200,
            color: Colors.lightGreen,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.green,
                      ),
                      Center(
                        child: const Text("入口1"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.orangeAccent,
                      ),
                      Center(
                        child: const Text("入口1"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.redAccent,
                      ),
                      Center(
                        child: const Text("入口1"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.indigo,
                      ),
                      Center(
                        child: const Text("入口1"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          sliver: SliverWaterfallFlow.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: listItem,
            // viewportBuilder: viewportBuilder,
          ),
        )
      ],
    );
  }

  List<Widget> get listItem {
    List<Widget> array = [];
    list.forEach((element) {
      array.add(FlowItemWidget(element));
    });
    return array;
  }
}


class FlowItemWidget extends StatelessWidget {

  Model model;
  FlowItemWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: model.key,
      width: double.infinity,
      height: model.height,
      color: rdColor,
      child: Center(
        child: Text("${model.index}"),
      ),
    );
  }

}

Color get rdColor => Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);



```

  
