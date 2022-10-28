import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/Position.dart';
import 'data/StockedTrend.dart';

class LocalStrage {
  static final LocalStrage _instance = LocalStrage._internal();

  factory LocalStrage() {
    return _instance;
  }

  LocalStrage._internal() {
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  SharedPreferences? prefs;

  LinkedHashMap<int, StockedTrend> getStockedTrends() {
    LinkedHashMap<int, StockedTrend> data = LinkedHashMap();

    if (!prefs!.containsKey("trends_stocked")) {
      prefs!.setString("trends_stocked", jsonEncode({}));
    }

    Map<int, dynamic> loadedData = Map<int, dynamic>.from(
        jsonDecode(LocalStrage().prefs!.getString("trends_stocked")!));
    loadedData.forEach((id, pos) {
      data[id] = StockedTrend(id)
        ..position = Position.fromJson(Map<String, dynamic>.from(pos));
    });

    return data;
  }

  void setStockedTrends(LinkedHashMap<int, StockedTrend> data) {
    prefs!.setString("trends_stocked",
        jsonEncode(data.map((key, value) => MapEntry(key, value.position))));
  }

  void toggleStockedTrend(WidgetRef ref, int id) {
    var stockedTrends = getStockedTrends();
    if (stockedTrends.containsKey(id)) {
      stockedTrends.remove(id);
    } else {
      stockedTrends[id] = StockedTrend(id)..position = Position(0, 0);
    }
    setStockedTrends(stockedTrends);

    ref.read(stockedProvider).update(stockedTrends);
  }

  static final stockedProvider =
      ChangeNotifierProvider((ref) => StockedListNotifier());

  String getServerIp() {
    if(!prefs!.containsKey("server_ip")) prefs!.setString("server_ip", "138.2.55.39");
    return prefs!.getString("server_ip")!;
  }
}

class StockedListNotifier extends ChangeNotifier {
  LinkedHashMap<int, StockedTrend> data = LinkedHashMap();

  StockedListNotifier() {
    updateTrends();
  }

  void updateTrends() {
    data = LocalStrage().getStockedTrends();
  }

  void update(LinkedHashMap<int, StockedTrend> newData) {
    data = newData;
    notifyListeners();
  }

  void moveTrend(int id, Offset delta) {
    updateTrends();

    if (!data.containsKey(id)) return;

    var movedTrend = data[id]!;
    movedTrend.position.x += delta.dx;
    movedTrend.position.y += delta.dy;

    LocalStrage().setStockedTrends(data);

    notifyListeners();
  }
}
