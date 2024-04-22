class PageResult<T> {
  final int current;
  final int total;
  final List<T> items;
  final bool hasNext;

  PageResult({
    required this.current,
    required this.total,
    required this.items,
    required this.hasNext,
  });

  factory PageResult.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return PageResult(
      current: json["current"],
      total: json["total"],
      items: (json["items"] as List).map((e) => fromJson(e)).toList(),
      hasNext: json["hasNext"],
    );
  }
}
