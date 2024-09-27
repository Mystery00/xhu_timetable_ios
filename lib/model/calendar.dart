class SchoolCalendarResponse {
  final String area;
  final String imageUrl;

  SchoolCalendarResponse({required this.area, required this.imageUrl});

  factory SchoolCalendarResponse.fromJson(Map<String, dynamic> json) {
    return SchoolCalendarResponse(
      area: json['area'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'imageUrl': imageUrl,
    };
  }
}
