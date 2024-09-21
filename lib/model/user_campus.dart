class UserCampus {
  final String selected;
  final List<String> items;

  UserCampus({required this.selected, required this.items});

  factory UserCampus.fromJson(Map<String, dynamic> json) {
    return UserCampus(
      selected: json['selected'],
      items: List<String>.from(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selected': selected,
      'items': items,
    };
  }
}
