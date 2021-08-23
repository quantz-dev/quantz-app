import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    this.onPressed,
    required this.color,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color color;
  final IconData icon;
  final Color iconColor;

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
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
