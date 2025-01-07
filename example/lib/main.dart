import 'package:flutter/material.dart';
import 'package:unusual_tabbar/unusual_tabbar.dart';

import 'controller.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: TabDemoPage(),
      ),
    );
  }
}

class TabDemoPage extends StatefulWidget {
  const TabDemoPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return TabDemoPageState();
  }
}

class TabDemoPageState extends State<TabDemoPage>
    with TickerProviderStateMixin {
  UnusualTabController controller = UnusualTabController(items: [
    UnusualTabItem(
        label: "Tab1asdasdasdas", icon: Icons.home, id: "1", toolTip: "Home"),
    UnusualTabItem(
        label: "Tab2asasasdasd", icon: null, id: "2", toolTip: "Search"),
    UnusualTabItem(label: "Tab3aa", icon: Icons.abc, id: "3", toolTip: "ABC"),
    UnusualTabItem(
        label: "Tab4", icon: Icons.dangerous, id: "4", toolTip: "Dangerous"),
    UnusualTabItem(
        label: "Tab5",
        icon: Icons.sensor_door,
        id: "5",
        toolTip: "Sensor Door"),
    UnusualTabItem(
        label: "Tab6", icon: Icons.settings, id: "6", toolTip: "Settings"),
  ], selectedIndex: 0);
  late SidebarController sideController =
      SidebarController(selectedIndex: 0, extended: true, vsync: this);
  final List<SideBarItem> _items = [
    const SideBarItem(title: Text("Tab1"), icon: Icon(Icons.home)),
    const SideBarItem(title: Text("Tab2"), icon: Icon(Icons.search)),
    const SideBarItem(title: Text("Tab3"), icon: Icon(Icons.abc)),
    const SideBarItem(
        title: Text(
          "Tab4asddddddddddddddddddddddddd",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        icon: Icon(Icons.dangerous)),
    const SideBarItem(title: Text("Tab5"), icon: Icon(Icons.sensor_door)),
    const SideBarItem(title: Text("Tab6"), icon: Icon(Icons.settings)),
    const SideBarItem(title: Text("Tab7"), icon: Icon(Icons.settings)),
  ];
  final List<SideBarItem> _footItems = [
    const SideBarItem(title: Text("Tab5"), icon: Icon(Icons.sensor_door)),
    const SideBarItem(title: Text("Tab6"), icon: Icon(Icons.settings)),
    const SideBarItem(title: Text("Tab7"), icon: Icon(Icons.settings)),
    const SideBarItem(title: Text("Tab8"), icon: Icon(Icons.settings)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UnusualTabBar Demo"),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.dashboard), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
              sideController.toggleExtended();
            },
          );
        }),
      ),
      body: Row(
        children: [
          SideMenu(
            controller: sideController,
            items: _items,
            footItems: _footItems,
            showToggleButton: true,
            extendedWidth: 200,
          ),
          Expanded(
              child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    controller.addItem(UnusualTabItem(
                        label: "Tab${controller.items.length + 1}",
                        icon: Icons.add,
                        id: "${controller.items.length + 1}"));
                  },
                  icon: const Icon(Icons.add)),
              UnusualTabBar(
                controller: controller,
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                dropBackground: Colors.amber,
                borderWidth: 1,
                closeable: true,
                draggable: true,
                maxWidth: 150,
                height: 32,
              ),
            ],
          ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            const SizedBox(), //中间位置空出
            IconButton(
              icon: const Icon(Icons.business),
              onPressed: () {},
            ),
          ], //均分底部导航栏横向空间
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 60,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class SideBarItem {
  final Widget title;
  final Widget? icon;
  const SideBarItem({this.icon, required this.title});
}

class SideMenu extends StatefulWidget {
  final List<SideBarItem> items;
  final List<SideBarItem>? footItems;
  final SidebarController controller;
  final double? itemHeight;
  final double? extendedWidth;
  final bool? showToggleButton;
  const SideMenu(
      {super.key,
      required this.items,
      this.footItems,
      required this.controller,
      this.showToggleButton = true,
      this.itemHeight = 40,
      this.extendedWidth = 200});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateUi);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateUi);
    super.dispose();
  }

  void _updateUi() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constraints) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          _buildNavigationBar(context),
          Positioned(
            right: 0,
            bottom: constraints.maxHeight / 2 - 20,
            child: CustomShapeButton(
              onPressed: () {},
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNavigationBar(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller.animation,
        builder: (context, child) {
          final width = Tween<double>(
            begin: widget.extendedWidth,
            end: 60,
          )
          .evaluate(widget.controller.animation);
          return Visibility(
              // visible: width > 60,
              child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: width),
                    child: Column(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount: widget.items.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: widget.itemHeight,
                                  decoration: BoxDecoration(
                                    color:
                                        widget.controller.selectedIndex == index
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () => setState(() {
                                      widget.controller.selectIndex(index);
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            widget.controller.extended
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: widget.items[index].icon!,
                                          ),
                                          if (widget.controller.extended)
                                            Expanded(
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  child: widget
                                                      .items[index].title),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 120,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Theme.of(context).hoverColor)),
                              ),
                              child: ListView.builder(
                                  reverse: true,
                                  itemCount: widget.footItems!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: widget.itemHeight,
                                      decoration: BoxDecoration(
                                        color:
                                            (widget.controller.selectedIndex -
                                                        widget.items.length) ==
                                                    widget.footItems!.length -
                                                        1 -
                                                        index
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(5),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () => setState(() {
                                          widget.controller.selectIndex(
                                              widget.items.length +
                                                  widget.footItems!.length -
                                                  index -
                                                  1);
                                        }),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                widget.controller.extended
                                                    ? MainAxisAlignment.start
                                                    : MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                child: widget
                                                    .footItems![widget
                                                            .footItems!.length -
                                                        1 -
                                                        index]
                                                    .icon!,
                                              ),
                                              if (widget.controller.extended)
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: widget
                                                          .footItems![widget
                                                                  .footItems!
                                                                  .length -
                                                              1 -
                                                              index]
                                                          .title),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )),
                        if (widget.showToggleButton!)
                          IconButton(
                            onPressed: () {
                              widget.controller.toggleExtended();
                            },
                            icon: Icon(
                              widget.controller.extended
                                  ? Icons.close
                                  : Icons.menu,
                            ),
                          ),
                      ],
                    ),
                  )));
        });
  }
}

class CustomShapeButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomShapeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomButtonClipper(),
      child: InkWell(
        hoverColor: Colors.red,
        onTap: onPressed,
        onHover: (value) => {},
        child: Container(
          width: 40, // 设置按钮的宽度
          height: 80, // 设置按钮的高度
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}

class CustomButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0); // 起点
    path.lineTo(size.width, size.height); // 左侧垂直到底部
    path.quadraticBezierTo(
      0,
      size.height / 2,
      size.width,
      0,
    ); // 右侧曲线
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
