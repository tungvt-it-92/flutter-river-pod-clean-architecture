import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import '../../data/repository/index.dart';
import 'base_usecase.dart';

abstract class UpdateTodoUseCase {
  Future<Either<Failure, bool>> call({required TodoModel todoModel});
}

class UpdateTodoUseCaseImpl extends BaseUseCase<bool, TodoModel>
    implements UpdateTodoUseCase {
  TodoRepository todoRepository;

  UpdateTodoUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, bool>> call(
      {required TodoModel todoModel}) async {
    return execute(todoModel);
  }

  @override
  Future<bool> main(TodoModel? arg) async {
    await todoRepository.updateTodo(todo: arg!);
    return true;
  }
}

final updateTodoUseCaseAutoDisposeProvider = AutoDisposeProvider((ref) {
  final todoRepository = ref.read(todoRepositoryProvider);

  return UpdateTodoUseCaseImpl(todoRepository);
});