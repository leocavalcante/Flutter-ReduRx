import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_redurx/src/provider.dart';
import 'package:redurx/redurx.dart';

/// The Widget that connects the State to a [builder] function.
class Connect<S, P> extends StatefulWidget {
  /// [convert] is how you map the State to [builder] props.
  /// With [where] you can filter when the Widget should re-render, this is very important!
  /// If you want to handle [null] values on the [builder] by yourself, set [nullable] to [true].
  Connect({
    Key key,
    @required this.convert,
    @required this.where,
    @required this.builder,
    this.nullable = false,
  }) : super(key: key);

  final P Function(S state) convert;
  final bool Function(P oldState, P newState) where;
  final Widget Function(P state) builder;
  final bool nullable;

  @override
  _ConnectState createState() => _ConnectState<S, P>(where, builder, nullable);
}

class _ConnectState<S, P> extends State<Connect<S, P>> {
  _ConnectState(this.where, this.builder, this.nullable);

  final bool Function(P oldState, P newState) where;
  final Widget Function(P state) builder;
  final bool nullable;

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
        if (snapshot.data == null && !nullable) {
          return Container();
        }

        _prev = snapshot.data;
        return builder(_prev);
      },
    );
  }
}
