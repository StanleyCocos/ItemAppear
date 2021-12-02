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

  
