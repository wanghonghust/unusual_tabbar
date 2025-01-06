import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'controller.dart';
import 'tab_item.dart';
import 'tab_widget.dart';

class UnusualTabBar extends StatefulWidget {
  final double? height;
  final double? maxWidth;
  final UnusualTabController controller;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? selectedColor;
  final Color? hoverColor;
  final Color? dropBackground;
  final bool? closeable;
  final bool? draggable;
  final String? closeHoverText;
  const UnusualTabBar({
    super.key,
    required this.controller,
    this.height = 32,
    this.maxWidth = 200,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.borderWidth = 1,
    this.borderColor,
    this.dropBackground,
    this.selectedColor,
    this.hoverColor,
    this.closeable = true,
    this.draggable = false,
    this.closeHoverText,
  });

  @override
  State<StatefulWidget> createState() {
    return _UnusualTabBarState();
  }
}

class TabStateController extends ChangeNotifier {
  int _hoveredIndex = -1;
  int _draggingIndex = -1;
  UnusualTabItem? _draggingItem;
  String? _selectedId;

  int get hoveredIndex => _hoveredIndex;
  int get draggingIndex => _draggingIndex;
  UnusualTabItem? get draggingItem => _draggingItem;
  String? get selectedId => _selectedId;

  set hoveredIndex(int value) {
    _hoveredIndex = value;
    notifyListeners();
  }

  set draggingIndex(int value) {
    _draggingIndex = value;
    notifyListeners();
  }

  set draggingItem(UnusualTabItem? value) {
    _draggingItem = value;
    notifyListeners();
  }

  set selectedId(String? value) {
    _selectedId = value;
    notifyListeners();
  }
}

class _UnusualTabBarState extends State<UnusualTabBar>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  TabStateController tabStateController = TabStateController();

  @override
  void initState() {
    widget.controller.addListener(_onSelected);
    tabStateController.addListener(_onSelected);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSelected);
    tabStateController.removeListener(_onSelected);
    super.dispose();
  }

  void _onSelected() {
    setState(() {});
  }

  void _onHover(int index, bool hovered) {
    tabStateController.hoveredIndex = hovered ? index : -1;
  }

  void _onDraggableCanceled(int index) {
    if (tabStateController.draggingItem != null) {
      widget.controller.insertItem(tabStateController.draggingItem!, index);
      widget.controller.selectItemById(tabStateController.selectedId!);
    }
    tabStateController.draggingIndex = -1;
    tabStateController.draggingItem = null;
  }

  void _onDragCompleted(int index) {
    tabStateController.draggingIndex = -1;
    if (tabStateController.draggingItem != null) {
      widget.controller.insertItem(
          tabStateController.draggingItem!, tabStateController.hoveredIndex);
    }
    if (tabStateController.selectedId != null) {
      widget.controller.selectItemById(tabStateController.selectedId!);
    }
    tabStateController.draggingItem = null;
    tabStateController.selectedId = null;
  }

  void _onDragStarted(int index) {
    tabStateController.selectedId = widget.controller.getSelectedId();
    tabStateController.draggingIndex = index;
    tabStateController._draggingItem = widget.controller.justRemoveAndSelect(
        index,
        select: index != widget.controller.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    Color borderColor = widget.borderColor ?? Theme.of(context).dividerColor;
    widget.controller.items.asMap().forEach((index, item) {
      BorderRadius? borderRadius;
      Border? border;
      if (widget.borderRadius != null) {
        if (widget.controller.items.length == 1) {
          borderRadius = widget.borderRadius!;
          border = Border.all(color: borderColor, width: widget.borderWidth!);
        } else if (index == 0) {
          borderRadius = BorderRadius.only(
              topLeft: widget.borderRadius!.topLeft,
              bottomLeft: widget.borderRadius!.bottomLeft);
          border = Border(
              left: BorderSide(width: widget.borderWidth!, color: borderColor),
              right: BorderSide(
                  width: widget.borderWidth! / 2, color: borderColor),
              top: BorderSide(width: widget.borderWidth!, color: borderColor),
              bottom:
                  BorderSide(width: widget.borderWidth!, color: borderColor));
        } else if (index == widget.controller.items.length - 1) {
          borderRadius = BorderRadius.only(
              topRight: widget.borderRadius!.topRight,
              bottomRight: widget.borderRadius!.bottomRight);
          border = Border(
              left: BorderSide(
                  width: widget.borderWidth! / 2, color: borderColor),
              right: BorderSide(width: widget.borderWidth!, color: borderColor),
              top: BorderSide(width: widget.borderWidth!, color: borderColor),
              bottom:
                  BorderSide(width: widget.borderWidth!, color: borderColor));
        } else {
          border = Border(
              left: BorderSide(
                  width: widget.borderWidth! / 2, color: borderColor),
              right: BorderSide(
                  width: widget.borderWidth! / 2, color: borderColor),
              top: BorderSide(width: widget.borderWidth!, color: borderColor),
              bottom:
                  BorderSide(width: widget.borderWidth!, color: borderColor));
        }
      }
      double maxWidth = widget.maxWidth!;
      if (widget.closeable!) {
        maxWidth = widget.maxWidth! >= 80 ? widget.maxWidth! : 80;
      } else {
        maxWidth = widget.maxWidth! >= 60 ? widget.maxWidth! : 60;
      }

      children.add(TabWidget(
        item: item,
        closeable: widget.closeable!,
        draggable: widget.draggable!,
        onClose: () {
          widget.controller.removeItem(index);
        },
        onClick: () {
          widget.controller.setSelectedIndex(index);
        },
        height: widget.height! >= 32 ? widget.height! : 32,
        maxWidth: maxWidth,
        borderRadius: borderRadius,
        border: border,
        selected: index == widget.controller.selectedIndex,
        selectedColor: widget.selectedColor ?? Theme.of(context).primaryColor,
        hoverColor: widget.hoverColor ?? Theme.of(context).hoverColor,
        dropBackground: widget.dropBackground ?? Theme.of(context).primaryColor,
        closeHoverText: widget.closeHoverText ?? 'Close Tab',
        onDragCompleted: () => _onDragCompleted(index),
        onDragStarted: () => _onDragStarted(index),
        onHover: (hovered) => _onHover(index, hovered),
        onDraggableCanceled: () => _onDraggableCanceled(index),
        dragging: tabStateController._draggingIndex != -1,
        hovered: tabStateController.hoveredIndex == index,
      ));
    });
    return Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: DragTarget<UnusualTabItem>(
              builder: (context, accepted, rejected) {
            return _TabRenderWidget(
              borderRadius: widget.borderRadius,
              height: widget.height!,
              maxWidth: widget.maxWidth!,
              borderColor: borderColor,
              borderWidth: widget.borderWidth!,
              children: children,
            );
          }),
        ));
  }
}

class _TabRenderWidget extends MultiChildRenderObjectWidget {
  final BorderRadius? borderRadius;
  final double height;
  final double maxWidth;
  final Color borderColor;
  final double borderWidth;
  const _TabRenderWidget({
    super.key,
    required super.children,
    this.borderRadius,
    required this.height,
    required this.maxWidth,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  TabRenderBox createRenderObject(BuildContext context) {
    return TabRenderBox(
      borderRadius: borderRadius,
      height: height,
      maxWidth: maxWidth,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TabRenderBox renderObject) {
    renderObject
      ..borderRadius = borderRadius
      ..height = height
      ..maxWidth = maxWidth;
  }

  @override
  MultiChildRenderObjectElement createElement() {
    return _TabViewElement(this);
  }
}

class _TabViewElement extends MultiChildRenderObjectElement {
  _TabViewElement(MultiChildRenderObjectWidget widget) : super(widget);

  @override
  void insertRenderObjectChild(RenderObject child, dynamic slot) {
    final parentData =
        child.parentData as BoxParentData? ?? TabLayoutParentData();
    child.parentData = parentData;
    super.insertRenderObjectChild(child, slot);
  }
}

class TabLayoutParentData extends ContainerBoxParentData<RenderBox> {}

class TabRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TabLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TabLayoutParentData> {
  BorderRadius? borderRadius;
  double height;
  double maxWidth;
  Color borderColor;
  double borderWidth;

  TabRenderBox({
    this.borderRadius,
    required this.height,
    required this.maxWidth,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void performLayout() {
    double offsetX = 0;

    // Layout children
    for (RenderBox child in getChildrenAsList()) {
      child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
          parentUsesSize: true);
      final TabLayoutParentData childParentData =
          child.parentData! as TabLayoutParentData;
      childParentData.offset = Offset(offsetX, 0);
      offsetX += child.size.width;
    }

    // Set the size of the TabRenderBox
    size = Size(offsetX, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var children = getChildrenAsList();
    if (children.isEmpty) return;
    for (RenderBox child in children) {
      final TabLayoutParentData childParentData =
          child.parentData! as TabLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
    }
  }
}
