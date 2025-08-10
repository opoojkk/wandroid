import 'package:flutter/material.dart';

extension UiExtension on String {
  void showSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(this)));
  }
}
