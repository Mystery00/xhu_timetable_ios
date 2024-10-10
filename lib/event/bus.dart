import 'package:event_bus/event_bus.dart';

EventBus _eventBus = EventBus(sync: false);
EventBus getEventBus() => _eventBus;
