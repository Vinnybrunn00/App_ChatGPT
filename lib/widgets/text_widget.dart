import 'package:flutter/material.dart';

class Textwidget extends StatelessWidget {
  const Textwidget(
      {Key? key,
      required this.label,
      this.fontSize = 18,
      this.color,
      this.fontWeight})
      : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'SFUIDisplay',
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
