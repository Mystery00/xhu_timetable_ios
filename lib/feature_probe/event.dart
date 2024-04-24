import 'dart:async';
import 'dart:convert';
import 'dart:io';

class EventRecorder {
  String eventsUrl;
  String sdkKey;
  String userAgent;
  int flushInterval;
  late Timer flushTimer;
  late List<Event> events;
  late HttpClient httpClient;

  EventRecorder(
      this.eventsUrl, this.sdkKey, this.flushInterval, this.userAgent) {
    events = [];
    httpClient = HttpClient();
  }

  void recordEvent(Event event) {
    events.add(event);
  }

  Future<void> start() async {
    final d = Duration(milliseconds: flushInterval);
    flushTimer = Timer.periodic(d, (timer) async {
      await flush();
    });
  }

  Future<void> stop() async {
    await flush();
    flushTimer.cancel();
  }

  Future<void> flush() async {
    final body = buildBody();
    if (body == null) {
      return;
    }
    final bodyJson = jsonEncode(body);
    final client = HttpClient();

    try {
      final req = await client.postUrl(Uri.parse(eventsUrl));
      req.headers.set(HttpHeaders.authorizationHeader, sdkKey);
      req.headers.set(HttpHeaders.userAgentHeader, userAgent);
      req.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      req.write(bodyJson);

      await req.close();
    } finally {
      client.close();
    }
  }

  PostBody? buildBody() {
    int? startTime;
    int? endTime;
    Map<String, List<Counter>> counters = {};

    List<Event> filteredEvents = [];

    if (events.isEmpty) {
      return null;
    }

    for (var event in events) {
      if (event.kind != "access") {
        filteredEvents.add(event);
      } else {
        if (startTime == null || startTime > event.time) {
          startTime = event.time;
        }
        if (endTime == null || endTime < event.time) {
          endTime = event.time;
        }

        var e = event as AccessEvent;
        if (e.trackAccessEvents != null && e.trackAccessEvents! == true) {
          filteredEvents.add(e);
        }
        var counter = counters[e.key];
        if (counter == null) {
          counters[e.key] = [Counter(e.value, e.version, e.variationIndex, 1)];
        } else {
          var added = false;
          for (var c in counter) {
            if (c.index == e.variationIndex &&
                c.version == e.version &&
                c.value == e.value) {
              c.count++;
              added = true;
            }
          }

          if (!added) {
            counter.add(Counter(e.value, e.version, e.variationIndex, 1));
          }
        }
      }
    }

    // clear existing events
    events = [];

    final pack =
        PostPack(Access(startTime!, endTime!, counters), filteredEvents);
    return PostBody(pack);
  }
}

class PostBody {
  PostPack pack;

  PostBody(this.pack);

  List toJson() => [pack];
}

class PostPack {
  Access access;
  List<Event> events;

  PostPack(this.access, this.events);

  Map toJson() => {
        'access': access,
        'events': events,
      };
}

class Access {
  int startTime;
  int endTime;
  Map<String, List<Counter>> counters;

  Access(this.startTime, this.endTime, this.counters);

  Map toJson() =>
      {'startTime': startTime, 'endTime': endTime, 'counters': counters};
}

class Counter {
  dynamic value;
  int? version;
  late int index;
  late int count;

  Counter(this.value, this.version, this.index, this.count);

  Map toJson() =>
      {'value': value, 'version': version, 'index': index, 'count': count};
}

abstract class Event {
  String kind;
  int time;
  String user;
  dynamic value;

  Event(this.kind, this.time, this.user, this.value);
}

class AccessEvent implements Event {
  @override
  String kind;
  @override
  int time;
  @override
  String user;
  @override
  dynamic value;

  String key;
  int variationIndex;
  int? ruleIndex;
  int version;
  bool? trackAccessEvents;

  AccessEvent(this.kind, this.time, this.user, this.value, this.key,
      this.variationIndex, this.ruleIndex, this.version,
      {this.trackAccessEvents});

  Map toJson() => {
        'kind': kind,
        'time': time,
        'user': user,
        'value': value,
        'key': key,
        'variationIndex': variationIndex,
        'rulendex': ruleIndex,
        'version': version
      };
}

class DebugEvent implements Event {
  @override
  String kind;
  @override
  int time;
  @override
  String user;
  @override
  dynamic value;

  String key;
  dynamic userDetail;
  int? variationIndex;
  int? ruleIndex;
  int version;
  String reason;

  DebugEvent(
      this.kind,
      this.time,
      this.user,
      this.key,
      this.value,
      this.userDetail,
      this.variationIndex,
      this.ruleIndex,
      this.version,
      this.reason);

  Map toJson() => {
        'kind': kind,
        'time': time,
        'user': user,
        'userDetail': userDetail,
        'value': value,
        'key': key,
        'variationIndex': variationIndex,
        'rulendex': ruleIndex,
        'version': version,
        'reason': reason,
      };
}

class CustomEvent implements Event {
  @override
  String kind;
  @override
  int time;
  @override
  String user;
  @override
  dynamic value;

  String name;

  CustomEvent(this.kind, this.time, this.user, this.value, this.name);

  Map toJson() =>
      {'kind': kind, 'time': time, 'user': user, 'name': name, 'value': value};
}
