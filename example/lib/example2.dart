import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:flutter_redurx/src/connect_widget.dart';
import 'package:meta/meta.dart';

import 'app_state.dart';

class _Props {
  _Props({
    @required this.title,
    @required this.count,
  });

  final String title;
  final String count;
}

class Example2 extends ConnectWidget<AppState, _Props> {
  @override
  _Props convert(AppState state) {
    return _Props(title: state.title, count: state.count.toString());
  }

  @override
  Widget build(BuildContext context, _Props props) {
    return Scaffold(
      appBar: AppBar(title: Text(props.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(props.count, style: Theme.of(context).textTheme.display1),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dispatch(context, Increment()),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
