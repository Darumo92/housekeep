import 'package:flutter/material.dart';

class ResponsiveCardList extends StatelessWidget {
  const ResponsiveCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 96),
    this.spacing = 12,
    this.wideBreakpoint = 600,
    this.gridChildAspectRatio = 2.1,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double wideBreakpoint;
  final double gridChildAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= wideBreakpoint;
        if (!useGrid) {
          return ListView.separated(
            padding: padding,
            itemCount: itemCount,
            separatorBuilder: (_, __) => SizedBox(height: spacing),
            itemBuilder: itemBuilder,
          );
        }
        return GridView.builder(
          padding: padding,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: gridChildAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
