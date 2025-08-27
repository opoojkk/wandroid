import 'package:event_bus/event_bus.dart';

class EventDriver {
  static EventDriver? _instance;

  EventDriver._internal();

  static EventDriver get instance => _instance ??= EventDriver._internal();

  final _eventBus = EventBus();

  EventBus get eventBus => _eventBus;
}
