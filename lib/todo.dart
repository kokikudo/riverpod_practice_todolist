import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// TODOのデータモデルとTODOリスト
// モデルはいつも通り。
// リストは状態が更新された時にプロバイダーに通知するStateNotifierに拡張したクラス

const _uuid = Uuid();

// TODOリストのコンテンツのモデル
class Todo {
  Todo({required this.id, required this.description, this.completed = false});

  // idとTODOの内容と完了/未完了を定義
  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

// TODOリスト
// state(リストの中身)が変更されたらtodoListProviderに通知を送信しそこのstateが更新される。
// リストへの追加、編集、削除メソッドはこのクラスに書いている
class TodoList extends StateNotifier<List<Todo>> {
  // 初期化時にStateにTodoリストをセットする
  TodoList(List<Todo>? initialTodos) : super(initialTodos ?? []);

  // 追加処理: stateのリストの末尾に引数の内容を追加
  void add(String description) {
    state = [...state, Todo(id: _uuid.v4(), description: description)];
  }

  // 完了機能
  // チェックボックスにチェックが入ってないTODOのリストに更新→完了したTODOがリストから消える
  void toggle(String id) {
    state = [
      for (var todo in state)
        if (todo.id == id)
          Todo(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed)
        else
          todo,
    ];
    // 以下のコードでも同様に動く
    // state = state.map((todo) {
    //   if (todo.id == id) {
    //     return Todo(
    //         id: todo.id,
    //         description: todo.description,
    //         completed: !todo.completed);
    //   } else {
    //     return todo;
    //   }
    // }).toList();
  }

  // 編集機能：該当するTODOに内容を上書きする
  void edit(String id, String description) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: description,
            completed: todo.completed,
          )
        else
          todo,
    ];
  }

  // 削除機能 対象のTODO以外のリストを返す
  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
