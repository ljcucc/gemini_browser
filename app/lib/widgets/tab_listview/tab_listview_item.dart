import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/tab_list_controller.dart';
import 'package:gemini_browser/widgets/tab_listview/tab_view.dart';
import 'package:provider/provider.dart';

class TabListViewItem extends StatelessWidget {
  final int index;
  final int indent;
  final String title;

  const TabListViewItem({
    super.key,
    required this.index,
    required this.indent,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TabListController>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(12);

    final tabView = TabView(
      onSelected: () {
        controller.index = index;
        Scaffold.of(context).closeDrawer();
      },
      title: title,
      isSelected: controller.index == index,
    );

    final droppableTabView = DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        final isHover = candidateData.isNotEmpty;
        return AnimatedContainer(
          padding: EdgeInsets.only(
            left: indent * 8,
            top: isHover && candidateData.last! > index ? 40 : 0,
            bottom: isHover && candidateData.last! < index ? 40 : 0,
          ),
          // decoration: BoxDecoration(
          //   borderRadius: borderRadius,
          //   border: Border.all(
          //       width: 2,
          //       color: colorScheme.primary.withOpacity(isHover ? 1 : 0),
          //       strokeAlign: BorderSide.strokeAlignOutside),
          // ),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          child: tabView,
        );
      },
    );

    final draggablePreview = Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(.15),
          blurRadius: 20,
        ),
      ]),
      width: 200,
      child: tabView,
    );

    // perform desktop experience of dragging
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return Draggable<int>(
        onDragStarted: () {
          print("drag start");
        },
        onDragEnd: (e) {
          print("drag end");
        },
        data: index,
        feedback: draggablePreview,
        childWhenDragging: Opacity(opacity: 0.15, child: tabView),
        child: droppableTabView,
      );
    }

    // perform touchscreen experience of dragging

    return LongPressDraggable<int>(
      onDragStarted: () {
        print("drag start");
      },
      onDragEnd: (e) {
        print("drag end");
      },
      data: index,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: draggablePreview,
      childWhenDragging: Opacity(opacity: 0.15, child: tabView),
      child: droppableTabView,
    );
  }
}
