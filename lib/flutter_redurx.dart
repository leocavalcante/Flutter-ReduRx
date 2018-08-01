library flutter_redurx;

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
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<S>(context).store;
    return StreamBuilder<P>(
      stream: store.map<P>(widget.convert).where((next) {
        if (widget.where(_prev, next)) {
          _prev = next;
          return true;
        }

        return false;
      }),
      builder: (context, snapshot) => snapshot.data != null ? builder(snapshot.data) : Container(),
    );
  }
}
