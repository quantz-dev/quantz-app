import 'package:flutter/material.dart';

import '../index.dart';

class CheckboxWidget extends StatelessWidget {
  const CheckboxWidget({
    Key? key,
    required this.value,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final String label;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: primary,
          onChanged: (value) {
            onChanged(value ?? false);
          },
        ),
        SizedBox(width: 6),
        Text(
          label,
        ),
      ],
    );
  }
}
