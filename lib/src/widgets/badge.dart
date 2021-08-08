import 'package:flutter/material.dart';

import 'index.dart';

class TextBadge extends StatelessWidget {
  const TextBadge(
    this.text, {
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  final String text;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? primary,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: size ?? 9,
          color: Colors.white,
        ),
      ),
    );
  }
}
