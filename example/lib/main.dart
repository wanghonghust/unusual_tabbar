import 'package:flutter/material.dart';
import 'package:unusual_tabbar/unusual_tabbar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
        ),
      ),
    );
  }
}