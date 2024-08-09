import 'package:objectbox/objectbox.dart';

@Entity()
class TodoModel {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime createdDate;

  String title;

  String description;

  bool isFinished;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.isFinished,
  });
}
