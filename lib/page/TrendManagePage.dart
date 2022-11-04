import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:trendiverse/page/TrendPage.dart';
import 'package:trendiverse/page/template/SubPage.dart';
import 'package:trendiverse/widgets/TrendSearch.dart';

import '../AppColor.dart';
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
      color: AppColor.black,
      child: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final data = ref.watch(dataProvider);
                final dataNotifier = ref.read(dataProvider.notifier);
                return ListView.separated(
                  itemCount: data.length + 2,
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
                        if (index == data.length) {
                          // 削除欄
                          return Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(64),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withAlpha(64),
                                  spreadRadius: 1.0,
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white54,
                                size: 50,
                              ),
                            ),
                          );
                        }
                        if (index == data.length + 1) {
                          // 追加欄
                          return MaterialButton(
                            onPressed: () {
                              // 検索
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: TrendSearch(
                                      (suggestion) {
                                        data.add([suggestion["id"]]);
                                        Navigator.pop(context);
                                        dataNotifier.state = data.toList();
                                      },
                                      excludeId: data.expand((x) => x).toList(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.circular(100), // infinity
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        // 普通の欄
                        return SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: data[index].map(
                                (e) {
                                  final content = Container(
                                    // width: 100,
                                    height: 40,
                                    padding: const EdgeInsets.all(10),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      color: AppColor.shadow,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: FutureBuilder(
                                        future: TrenDiverseAPI().getName(e),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data.toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                              ),
                                            );
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                  );
                                  return Draggable<int>(
                                    data: e,
                                    feedback: content,
                                    child: content,
                                    childWhenDragging:
                                        Opacity(opacity: 0.5, child: content),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        );
                      },
                      onAccept: (item) {
                        for (var innerList in data) {
                          innerList.remove(item);
                        }
                        if (index == data.length) {
                          // 削除欄へのドラッグの時
                          for (var element in data) {
                            element.remove(item);
                          }
                        } else if (index == data.length + 1) {
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
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                    ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/trendCompare"),
                        builder: (context) => SubPage(
                          TrendPage(ref.read(dataProvider), compare: true),
                        ),
                      ),
                    )
                  },
                  child: const SizedBox(
                    width: 200,
                    child: Center(
                      child: Text('比較する'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
