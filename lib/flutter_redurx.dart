library flutter_redurx;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redurx/redurx.dart';

export 'package:redurx/redurx.dart';

class Provider<T> extends InheritedWidget {
  Provider({
    Key key,
    Widget child,
    this.store,
  }) : super(key: key, child: child);
  final Store<T> store;

  static Provider<T> of<T>(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_targetType<Provider<T>>());

  static _targetType<T>() => T;

  static Store<T> dispatch<T>(BuildContext context, ActionType action) =>
      Provider.of<T>(context).store.dispatch(action);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class Connect<S, P> extends StatefulWidget {
  Connect({
    Key key,
    this.convert,
    this.where,
    this.builder,
  });

  final P Function(S state) convert;
  final bool Function(P oldState, P newState) where;
  final Widget Function(P state) builder;

  @override
  _ConnectState createState() => _ConnectState<S, P>(where, builder);
}

class _ConnectState<S, P> extends State<Connect<S, P>> {
  _ConnectState(this.where, this.builder);

  final bool Function(P oldState, P newState) where;
  final Widget Function(P state) builder;

  P _prev;
  Store<S> _store;
  Stream<P> _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _store = Provider.of<S>(context).store;
    _stream = _store.stream
        .map<P>(widget.convert)
        .where((next) => widget.where(_prev, next));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<P>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        _prev = snapshot.data;
        return builder(_prev);
      },
    );
  }
}
