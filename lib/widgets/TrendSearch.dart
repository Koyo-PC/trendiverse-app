import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../TrenDiverseAPI.dart';

class TrendSearch extends StatelessWidget {
  // {id: int, name: String}
  final void Function(Map<String, dynamic>) onclick;

  late final StateProvider<String> searchQueryProvider;

  TrendSearch(this.onclick, {Key? key}) : super(key: key) {
    searchQueryProvider = StateProvider((ref) => "");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      child: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            final queryNotifier = ref.read(searchQueryProvider.notifier);
            return TextField(
              onChanged: (clicked) {
                queryNotifier.state = clicked;
              },
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            );
          }),
          Consumer(
            builder: (context, ref, child) {
              final query = ref.watch(searchQueryProvider).toLowerCase();
              return FutureBuilder(
                future: TrenDiverseAPI().getAllData(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final matched = snapshot.data!
                        .where((element) =>
                            query.isEmpty ||
                            (element["name"] as String)
                                .toLowerCase()
                                .contains(query))
                        .toList();
                    return SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: ListView.builder(
                        itemCount: matched.length,
                        itemBuilder: (context, index) => GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white12,
                            child: Text(matched.elementAt(index)["name"]),
                          ),
                          onTap: () => onclick(matched.elementAt(index)),
                        ),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
