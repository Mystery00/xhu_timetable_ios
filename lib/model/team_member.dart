class TeamMember {
  final String title;
  final String subtitle;
  final String icon;

  TeamMember({required this.title, required this.subtitle, required this.icon});

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      title: json['title'],
      subtitle: json['subtitle'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
    };
  }
}
