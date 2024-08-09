import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/presentation/base/base_page_mixin.dart';
import 'package:todos/presentation/widgets/no_data_message_widget.dart';

import '../../base/base_page.dart';
import 'widget/todo_item_widget.dart';

class TodoListPage extends BasePage {
  const TodoListPage({required PageTag pageTag, super.key})
      : super(tag: pageTag);

  @override
  State<StatefulWidget> createState() => TodoListPageState();
}

class TodoListPageState extends BasePageState<TodoListPage> with BasePageMixin {
  final RefreshController _controller =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildLayout(BuildContext context) {
    final todos = [];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SmartRefresher(
        onRefresh: () {
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
                _showUpdateConfirmDialog(todo);
              },
              todo: todos[index],
              onConfirmDismiss: (c, todo) {
                _showDeleteConfirmDialog(todo);
              },
            );
          },
        ),
      ),
    );
  }

  _showUpdateConfirmDialog(TodoModel todo) async {
    final message = todo.isFinished
        ? 'Mark this item is "Doing" ?'
        : 'Mark this item is "Done" ?';
    final isOk = await showAlert(context: context, message: message);
    if (isOk) {
      todo.isFinished = !todo.isFinished;
    }
  }

  _showDeleteConfirmDialog(TodoModel todo) async {
    final isOk = await showAlert(
      context: context,
      message: 'Are you sure to delete this note?',
      okActionTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (isOk) {
      // bloc.dispatchEvent(OnRequestDeleteTodoEvent(todo: todo));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
