import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String password;

  Account(this.title, this.name, this.password);
}