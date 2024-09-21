import 'package:event_bus/event_bus.dart';

EventBus _eventBus = EventBus(sync: true);
EventBus getEventBus() => _eventBus;
