import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: TrenDiverseApp()));
}

class TrenDiverseApp extends StatelessWidget {
  const TrenDiverseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrenDiverse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TrenDiverseHome(title: 'Flutter Demo Home Page'),
    );
  }
}

class TrenDiverseHome extends StatefulWidget {
  const TrenDiverseHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TrenDiverseHome> createState() => _TrenDiverseHomeState();
}

class _TrenDiverseHomeState extends State<TrenDiverseHome> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
