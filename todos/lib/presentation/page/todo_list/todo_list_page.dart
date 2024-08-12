import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/presentation/base/base_page_mixin.dart';

import '../../base/base_page.dart';
import '../../widgets/index.dart';
import 'async_todos_provider.dart';
import 'widget/todo_item_widget.dart';

class TodoListPage extends BasePage {
  const TodoListPage({required PageTag pageTag, super.key}) : super(tag: pageTag);

  @override
  State<StatefulWidget> createState() => TodoListPageState();
}

class TodoListPageState extends BasePageState<TodoListPage> {
  final RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    final pageTag = (widget as BasePage).tag;
    final AsyncValue<List<TodoModel>> state = ref.watch(asyncTodosAutoDisposeFamilyProvider(pageTag));
    _controller.refreshCompleted();
    ref.listen(asyncTodosAutoDisposeFamilyProvider(pageTag), listenStateChanged);
    final todos = state.value ?? [];

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SmartRefresher(
        onRefresh: () {
          ref.invalidate(asyncTodosAutoDisposeFamilyProvider(pageTag));
        },
        controller: _controller,
        child: todos.isEmpty
            ? const NoDataMessageWidget()
            : ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 15,
          ),
          itemCount: todos.length,
          itemBuilder: (_, index) {
            return TodoItemWidget(
              onUpdateClicked: (todo) {
                _showUpdateConfirmDialog(todo, ref, pageTag);
              },
              todo: todos[index],
              onConfirmDismiss: (c, todo) {
                _showDeleteConfirmDialog(todo, ref, pageTag);
              },
            );
          },
        ),
      ),
    );
  }

  _showUpdateConfirmDialog(TodoModel todo, WidgetRef ref, PageTag currentTag) async {
    final message = todo.isFinished ? 'Mark this item is "Doing" ?' : 'Mark this item is "Done" ?';
    final isOk = await showAlert(context: context, message: message);
    if (isOk) {
      todo.isFinished = !todo.isFinished;
      ref.read(asyncTodosAutoDisposeFamilyProvider(currentTag).notifier).updateTodo(todo: todo, tag: currentTag);
      for (var tag in [PageTag.allTodo, PageTag.doingTodo, PageTag.doneTodo]) {
        if(tag !=  currentTag) {
          ref.invalidate(asyncTodosAutoDisposeFamilyProvider(tag));
        }
      }
    }
  }

  _showDeleteConfirmDialog(TodoModel todo, WidgetRef ref, PageTag currentTag) async {
    final isOk = await showAlert(
      context: context,
      message: 'Are you sure to delete this note?',
      okActionTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (isOk) {
      ref.read(asyncTodosAutoDisposeFamilyProvider(currentTag).notifier).remove(todo: todo);
      for (var tag in [PageTag.allTodo, PageTag.doingTodo, PageTag.doneTodo]) {
        if(tag !=  currentTag) {
          ref.invalidate(asyncTodosAutoDisposeFamilyProvider(tag));
        }
      }
    }
  }
}
