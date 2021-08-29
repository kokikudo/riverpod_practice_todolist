import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_practice_todolist/provider.dart';
import 'package:riverpod_practice_todolist/todo.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODOデータをリストで表示するWidget
// TODOデータをコンストラクタではなくプロバイダーで取得することでconstでインスタンス化できる
// これによって、Todoを追加、削除、編集をしたときに影響を受けたWidgetのみ再ビルドされる
// 正直、ようわからん

// Todoデータを取得するProvider。空の状態にしておきたいため未実装のためのスローを投げる
final currentTodo = Provider<Todo>((ref) => throw UnimplementedError());

class TodoItem extends HookConsumerWidget {
  const TodoItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODOの取得。おそらくこれをプロバイダーで取得することで再ビルドの範囲を最小限に止めることができる
    final todo = ref.watch(currentTodo);
    // Focusの定義。これもよくわかってない。
    final itemFocusNode = useFocusNode();
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    // TextFieldに機能を加える
    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        // FocusNodeを指定
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = todo.description;
          } else {
            // フォーカスが外れた時に変更を反映させる
            ref
                .read(todoListProvider.notifier)
                .edit(todo.id, textEditingController.text);
          }
        },

        // TODOを表示するTileList
        // チェックボタンを押すと完了済みになりリストから消える
        // タイトルにフォーカスが当たルト、編集可能になる。
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) =>
                ref.read(todoListProvider.notifier).toggle(todo.id),
          ),
          title: isFocused
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(todo.description),
        ),
      ),
    );
  }
}
