import 'package:floor/floor.dart';

@Entity(tableName: 'tb_custom_thing')
class CustomThingEntity {
  @primaryKey
  int? id;
  final int thingId;
  final String title;
  final String location;
  final bool allDay;
  final int startTime;
  final int endTime;
  final String remark;
  final String color;
  final String metadata;
  final int createTime;
  final String studentId;

  CustomThingEntity({
    this.id,
    required this.thingId,
    required this.title,
    required this.location,
    required this.allDay,
    required this.startTime,
    required this.endTime,
    required this.remark,
    required this.color,
    required this.metadata,
    required this.createTime,
    required this.studentId,
  });
}
