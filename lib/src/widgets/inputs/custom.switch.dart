import 'package:flutter/material.dart';

import '../index.dart';

class ButtonSwith extends StatelessWidget {
  const ButtonSwith({
    Key? key,
    required this.value,
    required this.onChanged,
    this.loading = false,
  }) : super(key: key);

  final bool value;
  final Function(bool value) onChanged;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading
          ? null
          : () {
              onChanged(!value);
            },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: loading ? 0 : 1,
                child: Text(
                  value ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: primary,
                  ),
                ),
              ),
              SizedBox(width: value ? 4 : 0),
              !value
                  ? SizedBox()
                  : Opacity(
                      opacity: loading ? 0 : 1,
                      child: Icon(
                        Icons.check,
                        color: primary,
                        size: 14,
                      ),
                    ),
            ],
          ),
          !loading
              ? SizedBox()
              : Center(
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
    );
  }
}
