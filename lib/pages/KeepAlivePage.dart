import 'package:flutter/cupertino.dart';

abstract class KeepAliveState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}
