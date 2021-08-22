import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
      onPressed: () {},
    );
  }
}
