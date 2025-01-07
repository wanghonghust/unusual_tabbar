import 'dart:async';

import 'package:flutter/material.dart';

class SidebarController extends ChangeNotifier {
  SidebarController({
    required int selectedIndex,
    required TickerProvider vsync,
    bool? extended,
  })  : _selectedIndex = selectedIndex,
        _animationController = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: vsync,
        ) {
    _setExtended(extended ?? false);
  }

  int _selectedIndex;
  var _extended = false;
  final AnimationController _animationController;

  Animation<double> get animation => _animationController.view;

  final _extendedController = StreamController<bool>.broadcast();
  Stream<bool> get extendStream =>
      _extendedController.stream.asBroadcastStream();

  int get selectedIndex => _selectedIndex;
  void selectIndex(int val) {
    _selectedIndex = val;
    notifyListeners();
  }

  bool get extended => _extended;
  void setExtended(bool extended) {
    _extended = extended;
    _extendedController.add(extended);
    _animationController.forward();
    notifyListeners();
  }

  void toggleExtended() {
    if (_extended) {
      _animationController.forward(); // 展开动画
    } else {
      _animationController.reverse(); // 收起动画
    }
    _extended = !_extended;
    _extendedController.add(_extended);
    notifyListeners();
  }

  void _setExtended(bool val) {
    _extended = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _extendedController.close();
    super.dispose();
  }
}
