import 'package:flutter/material.dart';

class StrokeWidget extends StatefulWidget {
  final Color color;
  final Widget childWidget;
  EdgeInsets? edgeInsets;
  final double strokeWidth;
  final double strokeRadius;

  StrokeWidget({
    super.key,
    required this.childWidget,
    this.color = Colors.black,
    this.edgeInsets,
    this.strokeWidth = 1.0,
    this.strokeRadius = 5.0,
  }) {
    edgeInsets ??= EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0);
  }

  @override
  State<StrokeWidget> createState() => _StrokeWidgetState();
}

class _StrokeWidgetState extends State<StrokeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.edgeInsets,
      decoration: BoxDecoration(
        border: Border.all(color: widget.color, width: widget.strokeWidth),
        borderRadius: BorderRadius.circular(widget.strokeRadius),
      ),
      child: widget.childWidget,
    );
  }
}
