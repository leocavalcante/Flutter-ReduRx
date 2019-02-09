import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';

import 'app_state.dart';

class Example1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Connect<AppState, String>(
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
              Connect<AppState, String>(
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
          onPressed: () => Provider.dispatch<AppState>(context, Increment()),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
