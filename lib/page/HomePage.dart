import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/AppColor.dart';

import '../widgets/TrendSearch.dart';
import 'StockPage.dart';
import 'TrendPage.dart';
import '../TrenDiverseAPI.dart';
import '../widgets/TrendTile.dart';
import 'template/SubPage.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  final trendListProvider = StateProvider((ref) {
    return TrenDiverseAPI().getList();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var trendListController = ref.read(trendListProvider.notifier);
    var trendList = ref.watch(trendListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 38,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TrendSearch(
            (suggestion) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/trend"),
                  builder: (context) => SubPage(TrendPage([[suggestion['id']]])),
                ),
              );
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.main,
      ),
      backgroundColor: AppColor.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: "/stock"),
              builder: (context) => SubPage(StockPage()),
              // builder: (context) => SubPage(TrendManagePage()),
            ),
          )
        },
        child: const Icon(Icons.bookmark),
        backgroundColor: AppColor.main,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<int>>(
        future: trendList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<int> trends = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () =>
                  trendListController.state = TrenDiverseAPI().getList(),
              child: GridView.count(
                padding: const EdgeInsets.all(5.0),
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                children: trends.map((id) {
                  return TrendTile(id);
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("ERROR: ${snapshot.error}");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
