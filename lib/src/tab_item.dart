import 'package:flutter/widgets.dart';

class UnusualTabItem {
  String id;
  String label;
  String? toolTip;
  IconData? icon;
  dynamic data;
  UnusualTabItem(
      {required this.id,
      required this.label,
      this.toolTip,
      this.data,
      this.icon});
  @override
  String toString() {
    return "TabItem{id: $id, label: $label,toolTip: $toolTip icon: $icon, data: $data}";
  }
}
