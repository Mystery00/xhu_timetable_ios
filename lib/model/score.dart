class ScoreResponse {
  final String teachingClassName;
  final String courseNo;
  final String courseName;
  final String courseType;
  final double credit;
  final double score;
  final String scoreDescription;
  final double gpa;
  final String scoreType;
  final double creditGpa;

  ScoreResponse({
    required this.teachingClassName,
    required this.courseNo,
    required this.courseName,
    required this.courseType,
    required this.credit,
    required this.score,
    required this.scoreDescription,
    required this.gpa,
    required this.scoreType,
    required this.creditGpa,
  });

  factory ScoreResponse.fromJson(Map<String, dynamic> json) {
    return ScoreResponse(
      teachingClassName: json['teachingClassName'],
      courseNo: json['courseNo'],
      courseName: json['courseName'],
      courseType: json['courseType'],
      credit: json['credit'],
      score: json['score'],
      scoreDescription: json['scoreDescription'],
      gpa: json['gpa'],
      scoreType: json['scoreType'],
      creditGpa: json['creditGpa'],
    );
  }
}

class ScoreGpaResponse {
  final double totalScore;
  final double averageScore;
  final double totalCredit;
  final double gpa;

  ScoreGpaResponse({
    required this.totalScore,
    required this.averageScore,
    required this.totalCredit,
    required this.gpa,
  });

  factory ScoreGpaResponse.fromJson(Map<String, dynamic> json) {
    return ScoreGpaResponse(
      totalScore: json['totalScore'],
      averageScore: json['averageScore'],
      totalCredit: json['totalCredit'],
      gpa: json['gpa'],
    );
  }
}

class ExperimentScoreResponse {
  final String teachingClassName;
  final String courseName;
  final double totalScore;
  final List<ExperimentScoreItemResponse> itemList;

  ExperimentScoreResponse({
    required this.teachingClassName,
    required this.courseName,
    required this.totalScore,
    required this.itemList,
  });

  factory ExperimentScoreResponse.fromJson(Map<String, dynamic> json) {
    var list = json['itemList'] as List;
    List<ExperimentScoreItemResponse> itemList =
        list.map((i) => ExperimentScoreItemResponse.fromJson(i)).toList();

    return ExperimentScoreResponse(
      teachingClassName: json['teachingClassName'],
      courseName: json['courseName'],
      totalScore: json['totalScore'],
      itemList: itemList,
    );
  }
}

class ExperimentScoreItemResponse {
  final String experimentProjectName;
  final double credit;
  final double score;
  final String scoreDescription;
  final String mustTest;

  ExperimentScoreItemResponse({
    required this.experimentProjectName,
    required this.credit,
    required this.score,
    required this.scoreDescription,
    required this.mustTest,
  });

  factory ExperimentScoreItemResponse.fromJson(Map<String, dynamic> json) {
    return ExperimentScoreItemResponse(
      experimentProjectName: json['experimentProjectName'],
      credit: json['credit'],
      score: json['score'],
      scoreDescription: json['scoreDescription'],
      mustTest: json['mustTest'],
    );
  }
}
