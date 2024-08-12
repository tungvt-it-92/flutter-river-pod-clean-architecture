import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/data/local/index.dart';


final storeProvider = Provider<StoreProvider>((ref) {
  return StoreProvider();
});

final todoDaoProvider = Provider<TodoDAO>((ref) {
  final provider = ref.read(storeProvider);

  return TodoDAOImpl(storeProvider: provider);
});
