import 'package:flutter/material.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:trendiverse/page/template/SubPage.dart';

import 'Graph.dart';
import '../data/TrendData.dart';
import '../page/TrendPage.dart';

class TrendTile extends StatelessWidget {
  final int _id;

  const TrendTile(this._id, {Key? key}) : super(key: key);

  int getId() {
    return _id;
  }

  @override
  Widget build(BuildContext context) {
    if (_id == 0) return Container();
    return GestureDetector(
      onTap: () async {
        var data = await TrenDiverseAPI().getData(_id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubPage(TrendPage(data)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            FutureBuilder<TrendData>(
              future: TrenDiverseAPI().getData(_id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Graph(data);
                }
                return CircularProgressIndicator();
              },
            ),
            FutureBuilder<String>(
              future: TrenDiverseAPI().getName(_id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Text(
                    data,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
        // child: FutureBuilder<TrendData>(
        //   future: TrenDiverseAPI().getData(_id),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       final data = snapshot.data!;
        //       return Column(
        //         children: <Widget>[
        //           Graph(data),
        //           Text(
        //             data.getName(),
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 20,
        //               color: Theme.of(context).primaryColor,
        //             ),
        //           ),
        //         ],
        //       );
        //     } else if (snapshot.hasError) {
        //       return Text("${snapshot.error}\n${snapshot.stackTrace}");
        //     }
        //     return CircularProgressIndicator();
        //   },
      ),
    );
  }
}
