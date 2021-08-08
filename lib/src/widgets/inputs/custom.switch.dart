import 'package:flutter/material.dart';

import '../index.dart';

class ButtonSwith extends StatelessWidget {
  const ButtonSwith({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onChanged(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value ? 'Following' : 'Follow',
            style: TextStyle(
              color: primary,
            ),
          ),
          SizedBox(width: value ? 4 : 0),
          !value
              ? SizedBox()
              : Icon(
                  Icons.check,
                  color: primary,
                  size: 14,
                ),
        ],
      ),
    );
  }
}
