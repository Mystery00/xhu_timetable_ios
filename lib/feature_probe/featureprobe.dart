import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

import 'event.dart';
import 'user.dart';

import 'package:socket_io_client/socket_io_client.dart' as sio;

const userAgent = "flutter/0.1.0";

class FeatureProbe {
  Map<String, Toggle>? toggles;
  late FPUser user;
  late String sdkKey;
  late Timer syncTimer;
  late EventRecorder recorder;
  late bool? realtime;

  String? togglesUrl;
  String? eventsUrl;
  String? realtimeUrl;

  int refreshInterval;
  int waitTimeout;
  sio.Socket? socket;

  FeatureProbe(
    String remoteUrl,
    this.sdkKey,
    this.user,
    this.refreshInterval,
    this.waitTimeout, {
    this.togglesUrl,
    this.eventsUrl,
    this.realtimeUrl,
    this.realtime,
  }) {
    togglesUrl ??= "$remoteUrl/api/client-sdk/toggles";
    eventsUrl ??= "$remoteUrl/api/events";
    realtimeUrl ??= "$remoteUrl/realtime";

    recorder = EventRecorder(eventsUrl!, sdkKey, refreshInterval, userAgent);
  }

  Future<void> start() async {
    recorder.start();
    if (waitTimeout != 0) {
      await _syncOnce().timeout(Duration(milliseconds: waitTimeout));
    }
    connectSocket();

    final d = Duration(milliseconds: refreshInterval);
    syncTimer = Timer.periodic(d, (timer) async {
      await _syncOnce();
    });
  }

  Future<void> stop() async {
    syncTimer.cancel();
    await recorder.stop();
    socket?.close();
  }

  void connectSocket() {
    if (realtime == null || !realtime!) {
      log('socketio skip', name: 'featureprobe.socketio');
      return;
    }

    final path = Uri.parse(realtimeUrl!).path;
    socket = sio.io(
        realtimeUrl,
        sio.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setPath(path)
            .build());
    socket?.onConnect((_) {
      log('socketio connected', name: 'featureprobe.socketio');
      socket?.emit('register', {"key": sdkKey});
    });
    socket?.on('update', (_) async {
      log('socketio update', name: 'featureprobe.socketio');
      await _syncOnce();
    });
    socket
        ?.onError((_) => log('socketio error', name: 'featureprobe.socketio'));
    socket?.onDisconnect(
        (_) => log('socketio disconnect', name: 'featureprobe.socketio'));
  }

  void track(String event, dynamic value) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    recorder.recordEvent(CustomEvent("custom", now, user.key, value, event));
  }

  bool boolValue(String key, bool defaultValue) {
    return _value<bool>(key, defaultValue);
  }

  int numberValue(String key, int defaultValue) {
    return _value<int>(key, defaultValue);
  }

  String stringValue(String key, String defaultValue) {
    return _value<String>(key, defaultValue);
  }

  dynamic jsonValue(String key, dynamic defaultValue) {
    return _value<dynamic>(key, defaultValue);
  }

  T _value<T>(String key, dynamic defaultValue) {
    var toggle = toggles?[key];
    if (toggle != null) {
      _trackAccess(key, toggle);

      return tryCast<T>(toggle.value) ?? defaultValue;
    } else {
      return defaultValue;
    }
  }

  FPDetail<bool> boolDetail(String key, bool defaultValue) {
    return _detail<bool>(key, defaultValue);
  }

  FPDetail<int> numberDetail(String key, int defaultValue) {
    return _detail<int>(key, defaultValue);
  }

  FPDetail<String> stringDetail(String key, String defaultValue) {
    return _detail<String>(key, defaultValue);
  }

  FPDetail<dynamic> jsonDetail(String key, dynamic defaultValue) {
    return _detail<dynamic>(key, defaultValue);
  }

  FPDetail<T> _detail<T>(String key, T defaultValue) {
    var toggle = toggles?[key];
    T v = defaultValue;
    String? r;
    if (toggle != null) {
      _trackAccess(key, toggle);

      var value = tryCast<T>(toggle.value);
      if (value == null) {
        r = "Value type mismatch";
      } else {
        v = value;
        r = toggle.reason;
      }
    } else {
      r = "Toggle $key not found";
    }

    return FPDetail<T>(
        value: v,
        reason: r,
        ruleIndex: toggle?.ruleIndex,
        variationIndex: toggle?.variationIndex,
        version: toggle?.version);
  }

  void _trackAccess(String key, Toggle toggle) {
    // track access
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;

    recorder.recordEvent(AccessEvent("access", now, user.key, toggle.value, key,
        toggle.variationIndex!, toggle.ruleIndex, toggle.version!,
        trackAccessEvents: toggle.trackAccessEvents));

    if (toggle.debugUntilTime != null && toggle.debugUntilTime! > now) {
      recorder.recordEvent(DebugEvent(
          "debug",
          now,
          user.key,
          key,
          toggle.value,
          user,
          toggle.variationIndex,
          toggle.ruleIndex,
          toggle.version!,
          toggle.reason));
    }
  }

  Future<void> _syncOnce() async {
    String credentials = jsonEncode(user);
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(credentials);

    var url = Uri.parse(togglesUrl!).replace(queryParameters: {
      'user': encoded,
    });

    final client = HttpClient();
    try {
      final request = await client.getUrl(url);
      request.headers.add(HttpHeaders.authorizationHeader, sdkKey);
      request.headers.add(HttpHeaders.userAgentHeader, userAgent);
      request.headers.add(HttpHeaders.contentTypeHeader, "application/json");

      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final body = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> json = jsonDecode(body);
        toggles =
            json.map((key, value) => MapEntry(key, Toggle.fromJson(value)));
      } else {
        log("syncOnce Error: $response");
      }
    } finally {
      client.close();
    }
  }
}

class Toggle {
  late dynamic value;
  int? ruleIndex;
  int? variationIndex;
  int? version;
  late String reason;

  int? debugUntilTime;
  bool? trackAccessEvents;

  Toggle(
      {this.value,
      this.ruleIndex,
      this.variationIndex,
      this.version,
      required this.reason,
      this.debugUntilTime,
      this.trackAccessEvents});

  factory Toggle.fromJson(Map<String, dynamic> parsedJson) {
    return Toggle(
        value: parsedJson['value'],
        ruleIndex: parsedJson['ruleIndex'],
        variationIndex: parsedJson['variationIndex'],
        version: parsedJson['version'],
        reason: parsedJson['reason'],
        debugUntilTime: parsedJson['debugUntileTime'],
        trackAccessEvents: parsedJson['trackAccessEvents']);
  }
}

class FPDetail<T> {
  late T value;
  int? ruleIndex;
  int? variationIndex;
  int? version;
  late String reason;

  FPDetail(
      {required this.value,
      this.ruleIndex,
      this.variationIndex,
      this.version,
      required this.reason});

  factory FPDetail.fromToggle(Toggle toggle) {
    return FPDetail(
        value: toggle.value,
        ruleIndex: toggle.ruleIndex,
        variationIndex: toggle.variationIndex,
        version: toggle.version,
        reason: toggle.reason);
  }

  Map toJson() => {
        'value': value,
        'ruleIndex': ruleIndex,
        'variationIndex': variationIndex,
        'version': version,
        'reason': reason
      };
}

T? tryCast<T>(dynamic value) {
  try {
    return (value as T);
  } on TypeError catch (_) {
    return null;
  }
}
