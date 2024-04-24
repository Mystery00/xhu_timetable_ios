class FPUser {
  FPUser() {
    key = DateTime.now().millisecondsSinceEpoch.toString();
  }

  late String key;
  Map<String, String> attrs = {};

  String getKey() {
    return key;
  }

  void stableRolloutKey(String key) {
    this.key = key;
  }

  void set(String attrName, String attrValue) {
    attrs[attrName] = attrValue;
  }

  void addAll(Map<String, String> other) {
    attrs.addAll(other);
  }

  Map toJson() => {
        'key': key,
        'attrs': attrs,
      };
}
