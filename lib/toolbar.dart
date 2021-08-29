import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_practice_todolist/provider.dart';

// リストのすぐ上にあるツールバー
// 機能：未完了の件数表示、フィルター機能

class Toolbar extends HookConsumerWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // フィルターの状態を管理するプロバイダー
    final filter = ref.watch(todoListFilter);

    // フィルターの色。状態によって変化する。
    Color? textColorFor(TodoListFilter value) {
      return filter.state == value ? Colors.blue : Colors.grey;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              // 未完了のTODOの個数
              '${ref.watch(uncompletedProvider).toString()} items left',
              // 件数が多くなり隣のWidgetsにオーバーした時のためにellipsisで省略するように設定
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // カテゴリー指定ボタン
          // 押した時に実行されるWidgetsを並べて置きたい時はTooltipが便利
          // MaterialDesignに則ったWidgetなのでデザインが楽
          Tooltip(
            message: 'All todos',
            child: TextButton(
              // フィルターの状態を更新
              onPressed: () => filter.state = TodoListFilter.all,
              child: Text(
                'All',
                style: TextStyle(
                  // filter.stateと値が同じになるので色が変わる
                  // filter.stateの値が変わると色が戻る
                  color: textColorFor(TodoListFilter.all),
                ),
              ),
            ),
          ),
          Tooltip(
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed: () => filter.state = TodoListFilter.active,
              child: Text(
                'Active',
                style: TextStyle(
                  color: textColorFor(TodoListFilter.active),
                ),
              ),
            ),
          ),
          Tooltip(
            message: 'Only completed todos',
            child: TextButton(
              onPressed: () => filter.state = TodoListFilter.completed,
              child: Text(
                'Completed',
                style: TextStyle(
                  color: textColorFor(TodoListFilter.completed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
