import 'package:flutter/material.dart' hide State;
import 'package:flutter_redurx/flutter_redurx.dart';

class State {
  State({this.title, this.count});
  final String title;
  final int count;
}

class Increment extends Action<State> {
  @override
  State reduce(State state) =>
      State(title: state.title, count: state.count + 1);
}

void main() {
  final store =
      Store<State>(State(title: 'Flutter-ReduRx Demo Title', count: 0));
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
    return Scaffold(
        appBar: AppBar(
          title: Connect<State, String>(
            convert: (state) => state.title,
            where: (prev, next) => next != prev,
            builder: (title) {
              print('Building title: $title');
              return Text(title);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button this many times:'),
              Connect<State, String>(
                convert: (state) => state.count.toString(),
                where: (prev, next) => next != prev,
                builder: (count) {
                  print('Building counter: $count');
                  return Text(count,
                      style: Theme.of(context).textTheme.display1);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.dispatch<State>(context, Increment()),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
