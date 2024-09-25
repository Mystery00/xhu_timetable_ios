class BackgroundResponse {
  final int backgroundId;
  final int resourceId;
  final String thumbnailUrl;
  final String imageUrl;

  BackgroundResponse(
      {required this.backgroundId,
      required this.resourceId,
      required this.thumbnailUrl,
      required this.imageUrl});

  factory BackgroundResponse.fromJson(Map<String, dynamic> json) {
    return BackgroundResponse(
      backgroundId: json['backgroundId'],
      resourceId: json['resourceId'],
      thumbnailUrl: json['thumbnailUrl'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundId': backgroundId,
      'resourceId': resourceId,
      'thumbnailUrl': thumbnailUrl,
      'imageUrl': imageUrl,
    };
  }
}
