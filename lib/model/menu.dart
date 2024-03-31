class Menu {
  final String key;
  final String title;
  final int sort;
  final int group;
  final String hint;
  final String link;

  Menu(
      {required this.key,
      required this.title,
      required this.sort,
      required this.group,
      required this.hint,
      required this.link});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      key: json['key'],
      title: json['title'],
      sort: json['sort'],
      group: json['group'],
      hint: json['hint'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'sort': sort,
      'group': group,
      'hint': hint,
      'link': link,
    };
  }
}
