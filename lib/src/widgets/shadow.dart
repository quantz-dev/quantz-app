import 'package:flutter/material.dart';

BoxShadow getShadow(double offsetY) {
  return BoxShadow(
    color: Colors.black.withOpacity(0.05),
    spreadRadius: 2,
    blurRadius: 2,
    offset: Offset(0, offsetY),
  );
}
