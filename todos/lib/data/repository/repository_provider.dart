import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/data/local/index.dart';
import 'package:todos/data/repository/index.dart';
import 'package:todos/domain/repository/todo_repository.dart';

final totoRepositoryProvider = Provider<TodoRepository>((ref) {
  final todoDao = ref.read(todoDaoProvider);

  return TodoRepositoryImpl(todoDao);
});