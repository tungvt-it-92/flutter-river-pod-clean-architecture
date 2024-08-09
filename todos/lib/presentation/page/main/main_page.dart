import 'package:todos/presentation/base/base_page.dart';
import 'package:todos/presentation/base/base_page_mixin.dart';
import 'package:todos/presentation/page/main/widget/input_toto_widget.dart';
import 'package:todos/presentation/page/todo_list/index.dart';

class MainPage extends BasePage {
  const MainPage({required PageTag pageTag, super.key}) : super(tag: pageTag);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends BasePageState<MainPage> with BasePageMixin {
  int pageIndex = 0;

  @override
  Widget buildLayout(BuildContext context) {
    return Scaffold(
      floatingActionButton: _CreateTodoButton(
        onPressed: () {
          _onAddNewTodoClickedHandler();
        },
      ),
      bottomNavigationBar: _BottomNavigationBar(
          initIndex: pageIndex,
          onItemClicked: (index) {
            setState(() {
              pageIndex = index;
            });
          }),
      body: SafeArea(
        child: IndexedStack(
          index: pageIndex,
          children: const [
            TodoListPage(pageTag: PageTag.allTodo),
            TodoListPage(pageTag: PageTag.doingTodo),
            TodoListPage(pageTag: PageTag.doneTodo),
          ],
        ),
      ),
    );
  }

  _onAddNewTodoClickedHandler() async {
    final result = await showWidgetDialog(
        context: context,
        child: InputTodoWidget(onConfirm: (data) {
          Navigator.of(context).pop(data);
        }));
    if (result != null) {
      // bloc.dispatchEvent(OnAddNewTodoEvent(todo: result));
    }
  }
}

class _BottomNavigationBar extends StatefulWidget {
  final int initIndex;
  final Function(int) onItemClicked;

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarState();

  const _BottomNavigationBar({required this.onItemClicked, required this.initIndex});
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.primaryColor,
      onTap: (index) {
        widget.onItemClicked(index);
        setState(() {
          selectedIndex = index;
        });
      },
      currentIndex: selectedIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.all_out),
          label: AppLocalizations.shared.commonTabAll,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.pending_rounded),
          label: AppLocalizations.shared.commonTabDoing,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.done_all),
          label: AppLocalizations.shared.commonTabDone,
        ),
      ],
    );
  }
}

class _CreateTodoButton extends StatelessWidget {
  final Function() onPressed;

  const _CreateTodoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
