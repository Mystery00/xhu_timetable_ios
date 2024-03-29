class Poems {
  final String content;
  final String title;
  final String dynasty;
  final String author;
  final List<String> fullContent;
  final List<String>? translate;

  Poems(
      {required this.content,
      required this.title,
      required this.dynasty,
      required this.author,
      required this.fullContent,
      required this.translate});

  factory Poems.fromJson(Map<String, dynamic> json) {
    return Poems(
      content: json['data']['content'],
      title: json['data']['origin']['title'],
      dynasty: json['data']['origin']['dynasty'],
      author: json['data']['origin']['author'],
      fullContent: (json['data']['origin']['content'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      translate: (json['data']['origin']['translate'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }
}
