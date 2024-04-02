import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/providers/tab_list_controller.dart';
import 'package:provider/provider.dart';

class TabListviewItem extends StatelessWidget {
  final int index;
  final int selected;
  final String title;
  final VoidCallback onSelected;

  const TabListviewItem({
    super.key,
    required this.index,
    required this.selected,
    required this.title,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TabListController>(builder: (context, controller, _) {
      final body = Card(
        margin: EdgeInsets.zero,
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color:
            selected == index ? Theme.of(context).colorScheme.secondary : null,
        shadowColor: Colors.transparent,
        child: InkWell(
          onTap: () => onSelected(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.circle_outlined,
                  color: selected == index
                      ? Theme.of(context).colorScheme.onSecondary
                      : null,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: selected == index
                          ? Theme.of(context).colorScheme.onSecondary
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final draggablePreview = Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(.15),
            blurRadius: 20,
          ),
        ]),
        width: 200,
        child: body,
      );

      // perform desktop experience of dragging
      if (!(Platform.isAndroid || Platform.isIOS)) {
        return Draggable(
          feedback: draggablePreview,
          child: body,
        );
      }

      // perform touchscreen experience of dragging

      return LongPressDraggable(
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: draggablePreview,
        child: body,
      );
    });
  }
}
