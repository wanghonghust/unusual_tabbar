import 'package:flutter/material.dart';

import 'tab_item.dart';

class TabWidget extends StatelessWidget {
  final UnusualTabItem? item;
  final bool? closeable;
  final bool? draggable;
  final bool? hovered;
  final bool? dragging;
  final double? height;
  final double? maxWidth;
  final Function? onClick;
  final Function? onClose;
  final Function? onDragStarted;
  final Function? onDragCompleted;
  final Function? onDraggableCanceled;
  final Function(bool value)? onHover;
  final BorderRadius? borderRadius;
  final Border? border;
  final bool? selected;
  final Color? selectedColor;
  final Color? dropBackground;
  final Color? hoverColor;
  final String? closeHoverText;

  TabWidget({
    super.key,
    required this.item,
    this.closeable = true,
    this.draggable = false,
    this.dragging = false,
    this.hovered = false,
    this.height = 32,
    this.maxWidth = 200,
    this.onClick,
    this.onClose,
    this.onHover,
    this.onDragStarted,
    this.onDragCompleted,
    this.onDraggableCanceled,
    this.borderRadius,
    this.border,
    this.selected = false,
    this.selectedColor = Colors.transparent,
    this.hoverColor = Colors.transparent,
    this.dropBackground = Colors.transparent,
    this.closeHoverText,
  }) {
    if (closeable! && onClose == null) {
      throw Exception("Closeable is true but onClose is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leadWidgets = [];
    double textMaxWidth = 0;
    if (item?.icon != null) {
      leadWidgets.add(const SizedBox(
        width: 4,
      ));
      leadWidgets.add(Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(4),
          child: Icon(item?.icon!)));
      textMaxWidth = maxWidth! - 4 - 32;
    } else {
      textMaxWidth = maxWidth!;
    }
    if (closeable!) {
      textMaxWidth = textMaxWidth - 32;
    }
    textMaxWidth = textMaxWidth -
        8 -
        (border != null ? (border!.left.width + border!.right.width) : 0);
    return Draggable(
      maxSimultaneousDrags: draggable! ? 1 : 0,
      onDragCompleted: () {
        if (onDragCompleted != null) {
          onDragCompleted!();
        }
      },
      onDragStarted: () {
        if (onDragStarted != null) {
          onDragStarted!();
        }
      },
      onDraggableCanceled: (velocity, offset) {
        if (onDraggableCanceled != null) {
          onDraggableCanceled!();
        }
      },
      data: item,
      feedback: Material(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: border,
              color: selected! ? selectedColor : Colors.transparent,
            ),
            constraints: BoxConstraints(maxWidth: maxWidth!),
            height: height! + border!.bottom.width + border!.top.width,
            child: InkWell(
              borderRadius: borderRadius,
              hoverColor: hoverColor,
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...leadWidgets,
                      Container(
                          constraints: BoxConstraints(maxWidth: textMaxWidth),
                          margin: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            item!.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ))
                    ],
                  ),
                  if (closeable!)
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: 24,
                      height: 24,
                      child: IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(4),
                        icon: const Icon(Icons.close),
                        iconSize: 16,
                      ),
                    )
                ],
              ),
            ),
          )),
      child: Container(
        foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: dragging! && hovered!
                ? Border(left: BorderSide(width: 4, color: dropBackground!))
                : null),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
          color: selected! ? selectedColor : Colors.transparent,
        ),
        constraints: BoxConstraints(maxWidth: maxWidth!),
        height: height! + border!.bottom.width + border!.top.width,
        child: InkWell(
          borderRadius: borderRadius,
          hoverColor: hoverColor,
          onTap: () {
            if (onClick != null) {
              onClick!();
            }
          },
          onHover: (value) {
            if (onHover != null) {
              onHover!(value);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: item!.toolTip ?? "",
                waitDuration: const Duration(seconds: 1),
                verticalOffset: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...leadWidgets,
                    Container(
                        constraints: BoxConstraints(maxWidth: textMaxWidth),
                        margin: const EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          item!.label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ))
                  ],
                ),
              ),
              if (closeable!)
                Tooltip(
                    verticalOffset: 14,
                    message: closeHoverText,
                    waitDuration: const Duration(seconds: 1),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 24,
                      height: 24,
                      child: IconButton(
                        hoverColor: Theme.of(context).hoverColor.withAlpha(50),
                        onPressed: () {
                          if (onClose != null) {
                            onClose!();
                          }
                        },
                        padding: const EdgeInsets.all(4),
                        icon: const Icon(Icons.close),
                        iconSize: 16,
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
