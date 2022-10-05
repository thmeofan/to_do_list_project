import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class ToDoModel extends HiveObject {
  @HiveField(0)
  String text;
  @HiveField(1)
  String id;
  @HiveField(2)
  bool isChecked;

  ToDoModel(this.text, this.id, this.isChecked);

  factory ToDoModel.fromJson(Map<String, dynamic> json) =>
      _$ToDoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoModelToJson(this);
}
