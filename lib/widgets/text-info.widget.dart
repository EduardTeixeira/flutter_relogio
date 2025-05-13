import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  final String label;
  final double fontSize;

  const TextInfo({super.key, required this.label, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
    );
  }
}
