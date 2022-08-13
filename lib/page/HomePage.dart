import 'package:flutter/material.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';

import 'SettingPage.dart';
import '../TrendLibrary.dart';
import '../widgets/TrendTile.dart';
import 'template/SubPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 38,
          child: TextField(
            style: const TextStyle(fontSize: 15.0, color: Colors.black),
            cursorHeight: 20,
            maxLines: 1,
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
              fillColor: Theme
                  .of(context)
                  .unselectedWidgetColor,
              contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () =>
                  {
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: FutureBuilder<TrendList>(
        future: TrenDiverseAPI().getList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<String> trends = [];
            trends.addAll(snapshot.data!.twitter);
            trends.addAll(snapshot.data!.google.where((element) => !trends.contains(element)));
            return GridView.count(
                padding: const EdgeInsets.all(5.0),
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                children: trends.map((trend) {
                  return TrendTile(TrendLibrary().getTrendData(trend));
                }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
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
