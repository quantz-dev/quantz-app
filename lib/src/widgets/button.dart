import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onPressed,
    required this.color,
    required this.text,
    required this.textColor,
    this.textSize,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color color;
  final String text;
  final Color textColor;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: MaterialStateProperty.all(color),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize ?? 16,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
