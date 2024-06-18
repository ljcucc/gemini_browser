import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TabView extends StatelessWidget {
  final bool isSelected;
  final String title;
  final VoidCallback onSelected;

  const TabView({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: isSelected ? Theme.of(context).colorScheme.secondary : null,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.circle_outlined,
                color: isSelected
                    ? Theme.of(context).colorScheme.onSecondary
                    : null,
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected
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
  }
}
