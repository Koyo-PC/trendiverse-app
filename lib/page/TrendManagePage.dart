import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';

import 'template/SubPageContent.dart';

class TrendManagePage extends SubPageContent {
  late final StateProvider<List<List<int>>> dataProvider;

  TrendManagePage(List<List<int>> list) {
    dataProvider = StateProvider((ref) => list);
  }

  @override
  String getTitle() {
    return "比較トレンドの追加";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final data = ref.watch(dataProvider);
                final dataNotifier = ref.read(dataProvider.notifier);
                return ListView.separated(
                  itemCount: data.length + 1,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 12.0,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.white24,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    return DragTarget<int>(
                      builder: (context, candidateItems, rejectedItems) {
                        if (index >= data.length) {
                          // 追加欄
                          return Container(
                            width: double.infinity,
                            height: 50,
                            color: Colors.yellow,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                        // 普通の欄
                        return SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: data[index].map((e) {
                              final content = Container(
                                // width: 100,
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                color: Colors.blue,
                                child: Center(
                                  child: FutureBuilder(
                                      future: TrenDiverseAPI().getName(e),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data.toString(),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          );
                                        }
                                        return const CircularProgressIndicator();
                                      }),
                                ),
                              );
                              return Draggable<int>(
                                data: e,
                                feedback: content,
                                child: content,
                                childWhenDragging:
                                    Opacity(opacity: 0.5, child: content),
                              );
                            }).toList(),
                          ),
                        );
                      },
                      onAccept: (item) {
                        for (var innerList in data) {
                          innerList.remove(item);
                        }
                        if (index >= data.length) {
                          // 追加欄へのドラッグの時
                          data.add([item]);
                        } else {
                          // 他の欄へのドラッグの時
                          data[index].add(item);
                        }
                        dataNotifier.state = data
                            .where((innerList) => innerList.isNotEmpty)
                            .toList();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
