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

  @HiveField(3)
  final bool isColored;

  @HiveField(4)
  final int colorCode;

  @HiveField(5)
  final bool censored;

  Account(this.title, this.name, this.password, this.isColored, this.colorCode, this.censored);
}