import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:trendiverse/page/StockPage.dart';
import 'package:trendiverse/page/TrendPage.dart';

import 'SettingPage.dart';
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
        title: SizedBox(
          height: 38,
          child: TypeAheadField(
            textFieldConfiguration: const TextFieldConfiguration(
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            suggestionsCallback: (pattern) async {
              var data = await TrenDiverseAPI().getAllData();
              final result = <Map<String, dynamic>>[];
              await Future.forEach(data, (Map<String, dynamic> item) async {
                if ((item["name"] as String)
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  result.add(item);
                }
              });
              return result;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                tileColor: Theme.of(context).backgroundColor,
                leading: const Icon(Icons.auto_graph),
                title: Text((suggestion as Map)['name']),
              );
            },
            onSuggestionSelected: (suggestion) {
              TrenDiverseAPI().getData((suggestion as Map)['id']).then(
                    (data) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubPage(TrendPage(data)),
                      ),
                    ),
                  );
            },
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () => {
                        FocusScope.of(context).requestFocus(FocusNode()),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubPage(SettingPage()),
                          ),
                        )
                      },
                  // 仮、TextFieldのフォーカスを外す
                  icon: const Icon(Icons.settings))),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubPage(StockPage()),
            ),
          )
        },
        child: const Icon(Icons.bookmark),
        backgroundColor: Theme.of(context).primaryColor,
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
                  return TrendTile(id, TrenDiverseAPI().getData(id));
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
