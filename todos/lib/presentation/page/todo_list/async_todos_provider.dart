import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/presentation/page/todo_list/async_todos_notifier.dart';

import '../../utils/page_tag.dart';


final asyncTodosAutoDisposeProvider =
AutoDisposeAsyncNotifierProviderFamily<AsyncTodosAutoDisposeFamilyAsyncNotifier, List<TodoModel>, PageTag>(
    AsyncTodosAutoDisposeFamilyAsyncNotifier.new);

// TODO: use regular AsyncNotifierProvider
final asyncTodosProvider = AsyncNotifierProvider<AsyncTodosNotifier, List<TodoModel>>(() {
  return AsyncTodosNotifier();
});

final todoFilterConditionProvider = StateProvider<PageTag>((ref) {
  return PageTag.allTodo;
});
