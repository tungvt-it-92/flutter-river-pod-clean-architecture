import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import '../../data/repository/repository_provider.dart';
import 'base_usecase.dart';

abstract class AddNewTotoUseCase {
  Future<Either<Failure, bool>> call({required TodoModel todoModel});
}

class AddNewTotoUseCaseImpl extends BaseUseCase<bool, TodoModel>
    implements AddNewTotoUseCase {
  TodoRepository todoRepository;

  AddNewTotoUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, bool>> call({
    required TodoModel todoModel,
  }) async {
    return execute(todoModel);
  }

  @override
  Future<bool> main(TodoModel? arg) async {
    await todoRepository.addNewTodo(todo: arg!);
    return true;
  }
}

var addNewTodoProviderUseCaseProvider = Provider<AddNewTotoUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);

  return AddNewTotoUseCaseImpl(repository);
});
