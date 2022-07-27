import 'package:flutter/material.dart';
import '../data/TrendData.dart';
import '../data/TrendSnapshot.dart';
import '../data/source/TwitterSource.dart';
import '../widgets/TrendTile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
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
                    onPressed: () =>
                        {FocusScope.of(context).requestFocus(FocusNode())},
                    // 仮、TextFieldのフォーカスを外す
                    icon: const Icon(Icons.settings))),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: GridView.count(
            padding: const EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            children: [
              TrendTile(
                TrendData("VRChat")
                    .addHistoryData(TrendSnapshot(TwitterSource(),
                        DateTime.now().subtract(const Duration(hours: 2)), 0.3))
                    .addHistoryData(TrendSnapshot(TwitterSource(),
                        DateTime.now().subtract(const Duration(hours: 1)), 0.5))
                    .addHistoryData(
                        TrendSnapshot(TwitterSource(), DateTime.now(), 0.2))
                    .addHistoryData(TrendSnapshot(TwitterSource(),
                        DateTime.now().add(const Duration(hours: 1)), 0.5))
                    .addHistoryData(TrendSnapshot(TwitterSource(),
                        DateTime.now().add(const Duration(hours: 2)), 0.5)),
              ),
              TrendTile(TrendData("あおぎり高校")),
              TrendTile(TrendData("改造クライアント")),
              TrendTile(TrendData("大阪王将")),
              TrendTile(TrendData("東方LostWord")),
              TrendTile(TrendData("マイナビオールスターゲーム2022")),
              TrendTile(TrendData("さんま御殿")),
              TrendTile(TrendData("あなたの霊感レべル")),
              TrendTile(TrendData("うたコン")),
              TrendTile(TrendData("a")),
              TrendTile(TrendData("a")),
              TrendTile(TrendData("a"))
            ],
          ),
        ));
  }
}
