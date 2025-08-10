import 'package:flutter/material.dart';

class EmptyHolder extends StatelessWidget {
  final String? msg;

  const EmptyHolder({super.key, this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(msg ?? "Loading..."));
  }
}
