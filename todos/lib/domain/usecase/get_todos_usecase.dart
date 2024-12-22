import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/core/error/failures.dart';
import 'package:todos/data/repository/index.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import 'package:todos/domain/usecase/base_usecase.dart';

abstract class GetTodosUseCase {
  Future<Either<Failure, List<TodoModel>>> call({ bool? isFinished });
}

final class GetTodosUseCaseImpl extends BaseUseCase<List<TodoModel>, bool> implements GetTodosUseCase {
  final TodoRepository todoRepository;

  GetTodosUseCaseImpl(this.todoRepository);

  @override
  Future<Either<Failure, List<TodoModel>>> call({ bool? isFinished}) async {
    return execute(isFinished);
  }

  @override
  Future<List<TodoModel>> main(bool? arg) async {
    if (arg != null) {
      return todoRepository.getTodoListByCondition(isFinished: arg);
    }

    return todoRepository.getAll();
  }
}

/*
* Normal provider
* */

// var getTodosUseCaseProvider = Provider((ref) {
//   final repository = ref.read(todoRepositoryProvider);
//
//   return GetTodosUseCaseImpl(repository);
// });

/*
* Use Provider.family to generate new instance when providing difference param
*/

final getTodosUseCaseFamilyProvider = Provider.family<GetTodosUseCase, bool?>((ref, isFinished) {
  final repository = ref.read(todoRepositoryProvider);
  return GetTodosUseCaseImpl(repository);
});

final getTodosUseCaseAutoDisposeFamilyProvider = AutoDisposeProvider.family<GetTodosUseCase, bool?>((ref, isFinished) {
  final repository = ref.read(todoRepositoryProvider);
  return GetTodosUseCaseImpl(repository);
});

