import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'todo.dart';

// TODOの状態の種類
enum TodoListFilter {
  all,
  active,
  completed,
}

// TODOリストの状態をStateNotifierProviderで定義
final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList([
    Todo(id: 'todo_0', description: 'hi'),
    Todo(id: 'todo_1', description: 'hello'),
    Todo(id: 'todo_2', description: 'bonjour'),
  ]);
});

// フィルターをかける機能の状態
final todoListFilter = StateProvider((_) => TodoListFilter.all);

// 未完了のTODOの数の状態
final uncompletedProvider = Provider<int>((ref) {
  // completedがfalseのTODOの数を取得
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

// 表示されるTODOリストのプロバイダー
// 表示するのはフィルターをかけたTODOリストであり、todoListProviderで管理しているリストはリポジトリ
// リストの更新、またはフィルターの更新時のみ再実行される
final filteredProvider = Provider<List<Todo>>((ref) {
  // まずは欲しいデータを確認しそれらを取得するプロバイダーを呼び出す
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  // フィルターの種類によってリターンするリストを変える
  switch (filter.state) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});
