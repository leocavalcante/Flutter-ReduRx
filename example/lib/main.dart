import 'package:flutter/material.dart' hide State;
import 'package:flutter_redurx/flutter_redurx.dart';

import 'app_state.dart';
import 'example1.dart';
import 'example2.dart';

void main() {
  final store =
      Store<AppState>(AppState(title: 'Flutter-ReduRx Demo Title', count: 0));
  runApp(Provider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-ReduRx Demo',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Example2();
  }
}
