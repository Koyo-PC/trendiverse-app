import 'package:flutter/material.dart';

import 'SettingPage.dart';
import '../TrendLibrary.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/GoogleSource.dart';
import '../data/source/TwitterSource.dart';
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
      body: GridView.count(
        padding: const EdgeInsets.all(5.0),
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: [
          TrendTile(
            TrendLibrary().getTrendData("VRChat")
              ..addHistoryData(TrendSnapshot(TwitterSource(),
                  DateTime.now().subtract(const Duration(minutes: 2)), 0.3))
              ..addHistoryData(TrendSnapshot(TwitterSource(),
                  DateTime.now().subtract(const Duration(minutes: 1)), 0.5))
              ..addHistoryData(
                  TrendSnapshot(TwitterSource(), DateTime.now(), 0.2))
              ..addHistoryData(TrendSnapshot(TwitterSource(),
                  DateTime.now().add(const Duration(minutes: 1)), 0.5))
              ..addHistoryData(TrendSnapshot(TwitterSource(),
                  DateTime.now().add(const Duration(minutes: 2)), 0.5))
              ..addHistoryData(TrendSnapshot(GoogleSource(),
                  DateTime.now().subtract(const Duration(minutes: 2)), 0.2))
              ..addHistoryData(TrendSnapshot(GoogleSource(),
                  DateTime.now().subtract(const Duration(minutes: 1)), 0.8))
              ..addHistoryData(
                  TrendSnapshot(GoogleSource(), DateTime.now(), 0.1))
              ..addHistoryData(TrendSnapshot(GoogleSource(),
                  DateTime.now().add(const Duration(minutes: 1)), 0.4))
              ..addHistoryData(TrendSnapshot(GoogleSource(),
                  DateTime.now().add(const Duration(minutes: 2)), 0.3)),
          ),
          TrendTile(TrendLibrary().getTrendData("あおぎり高校")),
          TrendTile(TrendLibrary().getTrendData("改造クライアント")),
          TrendTile(TrendLibrary().getTrendData("大阪王将")),
          TrendTile(TrendLibrary().getTrendData("東方LostWord")),
          TrendTile(TrendLibrary().getTrendData("マイナビオールスターゲーム2022")),
          TrendTile(TrendLibrary().getTrendData("さんま御殿")),
          TrendTile(TrendLibrary().getTrendData("あなたの霊感レべル")),
          TrendTile(TrendLibrary().getTrendData("うたコン")),
          TrendTile(TrendLibrary().getTrendData("a")),
          TrendTile(TrendLibrary().getTrendData("a")),
          TrendTile(TrendLibrary().getTrendData("a"))
        ],
      ),
    );
  }
}
