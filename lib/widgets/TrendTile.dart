import 'package:flutter/material.dart';
import 'package:trendiverse/TrenDiverseAPI.dart';
import 'package:trendiverse/page/template/SubPage.dart';

import '../AppColor.dart';
import 'Graph.dart';
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
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/trend"),
            builder: (context) => SubPage(TrendPage([
              [_id]
            ])),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 200,
          child: Column(
            children: <Widget>[
              Graph(
                [
                  [_id]
                ],
                textColor: Colors.black,
              ),
              Container(
                color: AppColor.black,
                height: 1,
                margin: const EdgeInsets.only(bottom: 5),
              ),
              Expanded(
                child: Center(
                  child: FutureBuilder<String>(
                    future: TrenDiverseAPI().getName(_id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Text(
                          data,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColor.main,
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
