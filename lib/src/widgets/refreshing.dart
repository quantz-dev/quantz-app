import 'package:flutter/material.dart';

class RefreshingWidget extends StatelessWidget {
  const RefreshingWidget({
    Key? key,
    required this.value,
    this.text,
  }) : super(key: key);

  final bool value;
  final String? text;

  @override
  Widget build(BuildContext context) {
    // if (!value) return SizedBox();

    return AnimatedContainer(
      height: value ? 32 : 0,
      width: double.infinity,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            text ?? 'Refreshing data ...',
            style: TextStyle(
              fontSize: value ? 14 : 0,
            ),
          ),
          SizedBox(width: 12),
          SizedBox(
            height: value ? 16 : 0,
            width: value ? 16 : 0,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
