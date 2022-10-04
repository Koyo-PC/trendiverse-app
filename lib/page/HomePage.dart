import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';

import 'SettingPage.dart';
import '../TrendLibrary.dart';
import '../widgets/TrendTile.dart';
import 'template/SubPage.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  final searchQueryProvider = StateProvider((ref) {
    return "";
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQueryController = ref.read(searchQueryProvider.notifier);
    final searchQuery = ref.watch(searchQueryProvider);
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 38,
          child: TextFormField(
            style: const TextStyle(fontSize: 15.0, color: Colors.black),
            cursorHeight: 20,
            maxLines: 1,
            onFieldSubmitted: (s) => {searchQueryController.state = s},
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "search...",
              fillColor: Theme.of(context).unselectedWidgetColor,
              contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            ),
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
      body: FutureBuilder<List<int>>(
        future: TrenDiverseAPI().getList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<int> trends = snapshot.data!;
            return GridView.count(
              padding: const EdgeInsets.all(5.0),
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              children: trends.map((id) {
                return TrendTile(id, TrenDiverseAPI().getData(id));
              }).where((tile) {
                return searchQuery.isEmpty ||
                    (TrenDiverseAPI().getCachedData(tile.getId())?.getName().contains(searchQuery) ?? true);
              }).toList(),
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
