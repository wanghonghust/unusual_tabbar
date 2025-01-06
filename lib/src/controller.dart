import 'package:flutter/widgets.dart';

import 'tab_item.dart';

class UnusualTabController extends ChangeNotifier {
  int selectedIndex;
  List<UnusualTabItem> items;

  UnusualTabController({required this.selectedIndex, required this.items}) {
    if (hasDuplicateIds()) {
      throw Exception("Id is not unique");
    }
  }

  // 检查是否有重复的ID
  bool hasDuplicateIds() {
    Set<String> ids = {};
    for (var item in items) {
      if (!ids.add(item.id)) {
        return true;
      }
    }
    return false;
  }

  // 检查ID是否唯一
  bool _isIdUnique(String id) {
    return !items.any((item) => item.id == id);
  }

  // 根据ID获取TabItem
  UnusualTabItem? getItemById(String id) {
    for (var item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  UnusualTabItem? getItemByIndex(int index) {
    if (index >= 0 && index < items.length) {
      return items[index];
    }
    return null;
  }

  String? getSelectedId() {
    if (selectedIndex >= 0 && selectedIndex < items.length) {
      return items[selectedIndex].id;
    }
    return null;
  }

  // 根据ID选择TabItem
  void selectItemById(String id) {
    int index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      setSelectedIndex(index);
    }
  }

  // 设置选中的索引
  void setSelectedIndex(int index) {
    if (index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  // 添加TabItem
  void addItem(UnusualTabItem item, {bool selectLast = false}) {
    if (!_isIdUnique(item.id)) {
      throw Exception("Id is not unique");
    }
    items.add(item);
    if (selectLast) {
      selectedIndex = items.length - 1;
    }
    notifyListeners();
  }

  void insertItem(UnusualTabItem item, int index) {
    if (!_isIdUnique(item.id)) {
      throw Exception("Id is not unique");
    }
    items.insert(index, item);
    notifyListeners();
  }

  // 移除指定索引的TabItem
  UnusualTabItem? removeItem(int index) {
    if (index >= 0 && index < items.length) {
      var item = items.removeAt(index);
      if (items.isEmpty) {
        selectedIndex = -1;
        notifyListeners();
        return item;
      }
      if (selectedIndex == index) {
        selectedIndex = items.length - 1;
        notifyListeners();
      } else if (selectedIndex > index) {
        selectedIndex -= 1;
        notifyListeners();
      }
      notifyListeners();
      return item;
    }
    notifyListeners();
    return null;
  }

  // 根据ID移除TabItem
  UnusualTabItem? removeItemById(String id) {
    int index = -1;
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      return removeItem(index);
    }

    return null;
  }

  UnusualTabItem? justRemoveAndSelect(int index, {bool select = false}) {
    if (index >= 0 && index < items.length) {
      var item = items.removeAt(index);
      if (select) {
        if (selectedIndex > index) {
          selectedIndex -= 1;
        } else if (selectedIndex == index) {
          selectedIndex = -1;
        }
      } else {
        selectedIndex = -1;
      }
      notifyListeners();
      return item;
    }
    return null;
  }

  String getTooltipText(int index) {
    if (index >= 0 && index < items.length) {
      return items[index].toolTip ?? "";
    }
    return "";
  }
}
