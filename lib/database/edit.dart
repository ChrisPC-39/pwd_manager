import 'package:hive/hive.dart';

part 'edit.g.dart';

@HiveType(typeId: 1)
class Edit {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final bool isEditing;

  @HiveField(4)
  final int index;

  Edit(this.title, this.name, this.password, this.isEditing, this.index);
}