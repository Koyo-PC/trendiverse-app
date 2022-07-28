import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final Color color;

  final String content;

  final Color textColor;

  final double height;

  final EdgeInsetsGeometry? margin;

  Tag(this.content, this.color, this.textColor, this.height, {EdgeInsetsGeometry? this.margin ,Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        content,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
