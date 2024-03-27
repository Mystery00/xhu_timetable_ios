class AccountShowEntity {
  final String name;
  final String studentNo;
  final String className;
  final String gender;
  final String xhuGrade;
  final String? majorName;
  final String? college;
  final String? majorDirection;

  AccountShowEntity(
      {required this.name,
      required this.studentNo,
      required this.className,
      required this.gender,
      required this.xhuGrade,
      this.majorName,
      this.college,
      this.majorDirection});
}
