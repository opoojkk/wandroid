import 'package:flutter/material.dart';

class QuickTopFloatBtn extends StatefulWidget {
  final VoidCallback onPressed;
  final bool defaultVisible;

  const QuickTopFloatBtn({
    super.key,
    required this.onPressed,
    this.defaultVisible = false,
  });

  @override
  State<StatefulWidget> createState() => new QuickTopFloatBtnState();
}

class QuickTopFloatBtnState extends State<QuickTopFloatBtn> {
  bool _visible = false;

  refreshVisible(bool visible) {
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _visible = widget.defaultVisible;
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? Padding(
            padding: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              child: Icon(Icons.arrow_upward),
            ),
          )
        : SizedBox(width: 0.0, height: 0.0);
  }
}
