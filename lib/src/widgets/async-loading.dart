import 'package:flutter/material.dart';

void showLoading(BuildContext context, Future<void> callback) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AsyncLoading(
      callback: callback,
    ),
  );
}

class _AsyncLoading extends StatefulWidget {
  const _AsyncLoading({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final Future<void> callback;

  @override
  __AsyncLoadingState createState() => __AsyncLoadingState();
}

class __AsyncLoadingState extends State<_AsyncLoading> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() async {
      await widget.callback;
      pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        child: Container(
          height: 48,
          width: 48,
          child: Center(
            child: SizedBox(
              height: 32,
              width: 32,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  void pop() {
    Navigator.pop(context);
  }
}
