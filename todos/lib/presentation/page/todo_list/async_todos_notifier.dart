import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/usecase/index.dart';
import 'package:todos/presentation/base/base_page.dart';
import 'package:todos/presentation/page/todo_list/todos_state.dart';

class AsyncTodosAutoDisposeFamilyAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<TodosState, PageTag> {
  @override
  Future<TodosState> build(PageTag arg) async {
    state = AsyncData(TodosState(isLoading: true));
    await fetch(arg);
    return state.value!;
  }

  fetch(PageTag arg) async {
    state = AsyncData((await future).copyWith(isLoading: true));
    final fetchCondition = arg == PageTag.allTodo
        ? null
        : (arg == PageTag.doingTodo ? false : true);
    final getTodosUseCase =
        ref.read(getTodosUseCaseAutoDisposeFamilyProvider(fetchCondition));

   final result = await getTodosUseCase(isFinished: fetchCondition);
    await result.fold((failure) async {
      state = AsyncData(
          (await future).copyWith(failure: failure, isLoading: false));
    }, (value) async {
      state =
          AsyncData((await future).copyWith(todos: value, isLoading: false));
    });
  }

  add({required TodoModel todo}) async {
    state = AsyncData(state.value!.copyWith(isLoading: true));

    final result =
        await ref.read(addNewTodoProviderUseCaseProvider)(todoModel: todo);
    final currentValue = await future;
    state = result.fold((failure) {
      return AsyncData(
          currentValue.copyWith(failure: failure, isLoading: false));
    }, (_) {
      return AsyncData(
        currentValue
            .copyWith(todos: [...currentValue.todos, todo], isLoading: false),
      );
    });
  }

  remove({required TodoModel todo}) async {
    state = AsyncData((await future).copyWith(isLoading: true));

    final result =
        await ref.read(removeTodoUseCaseAutoDisposeProvider)(todoModel: todo);
    final currentValue = await future;
    state = result.fold((failure) {
      return AsyncData(
          currentValue.copyWith(failure: failure, isLoading: false));
    }, (_) {
      List<TodoModel> todos =
          currentValue.todos.where((p) => p.id != todo.id).toList();
      return AsyncData(currentValue.copyWith(todos: todos, isLoading: false));
    });
  }

  updateTodo({required TodoModel todo, required PageTag tag}) async {
    state = AsyncData(state.value!.copyWith(isLoading: true));

    final result =
        await ref.read(updateTodoUseCaseAutoDisposeProvider)(todoModel: todo);
    List<TodoModel> todos = (await future).todos;

    state = result.fold((failure) {
      return AsyncData(
          state.value!.copyWith(failure: failure, isLoading: false));
    }, (_) {
      if (tag == PageTag.allTodo) {
        todos = todos.map((t) => t.id == todo.id ? todo : t).toList();
      } else {
        todos = todos.where((p) => p.id != todo.id).toList();
      }
      return AsyncData(state.value!.copyWith(todos: todos, isLoading: false));
    });
  }
}

/*
* Try with regular AsyncNotifier
*/
// class AsyncTodosNotifier extends AsyncNotifier<List<TodoModel>> {
//   @override
//   Future<List<TodoModel>> build() async {
//     final tag = ref.watch(todoFilterConditionProvider);
//     final todoRepository = ref.read(todoRepositoryProvider);
//     if (tag == PageTag.allTodo) {
//       return todoRepository.getAll();
//     }
//     if (tag == PageTag.doingTodo) {
//       return todoRepository.getTodoListByCondition(isFinished: false);
//     }
//
//     return todoRepository.getTodoListByCondition(isFinished: true);
//   }
//
//   add({required TodoModel todo}) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() async {
//       final todoRepository = ref.read(todoRepositoryProvider);
//       await todoRepository.addNewTodo(todo: todo);
//       var current = state.value ?? [];
//       current.add(todo);
//       return current;
//     });
//   }
//
//   remove({required TodoModel todo}) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() async {
//       final todoRepository = ref.read(todoRepositoryProvider);
//       await todoRepository.remove(id: todo.id);
//       var current = state.value ?? [];
//       current.remove(todo);
//       return current;
//     });
//   }
//
//   updateTodo({required TodoModel todo}) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() async {
//       final todoRepository = ref.read(todoRepositoryProvider);
//       await todoRepository.updateTodo(todo: todo);
//       var current = state.value ?? [];
//       final index = current.indexOf(todo);
//       if (index >= 0) {
//         current[index] = todo;
//       }
//       return current;
//     });
//   }
// }
