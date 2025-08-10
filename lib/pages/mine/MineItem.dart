import 'package:flutter/material.dart';

class MineItem {
  final String title;
  final IconData icon;
  Function(BuildContext context)? onTap = null;

  MineItem({required this.title, required this.icon, this.onTap});
}
