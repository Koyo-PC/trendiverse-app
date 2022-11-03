import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../AppColor.dart';
import '../TrenDiverseAPI.dart';

class TrendSearch extends StatelessWidget {
  // {id: int, name: String}
  final void Function(Map<String, dynamic>) onclick;

  const TrendSearch(this.onclick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
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
          tileColor: AppColor.black,
          leading: const Icon(Icons.auto_graph),
          title: Text((suggestion as Map)['name']),
        );
      },
      onSuggestionSelected: onclick
    );
  }

}