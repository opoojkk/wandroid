import 'package:flutter/material.dart';

class BottomLoadingIndicator extends StatelessWidget {
  const BottomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text("正在加载更多...", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
