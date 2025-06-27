import 'package:flutter/material.dart';

class ScrollColumnExpandable extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final VerticalDirection? verticalDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry? padding;

  const ScrollColumnExpandable({
    super.key,
    this.children = const [],
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.verticalDirection = VerticalDirection.down,
    this.padding = EdgeInsets.zero,
    this.textBaseline = TextBaseline.alphabetic,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: Padding(
            padding: padding!,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight - padding!.vertical,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: crossAxisAlignment!,
                  mainAxisAlignment: mainAxisAlignment!,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: verticalDirection!,
                  textBaseline: textBaseline,
                  textDirection: Directionality.of(context),
                  children: children,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
