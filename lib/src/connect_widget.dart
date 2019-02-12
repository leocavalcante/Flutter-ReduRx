import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_redurx/src/provider.dart';
import 'package:redurx/redurx.dart';

@immutable
abstract class ConnectWidget<S, P> extends StatefulWidget {
  const ConnectWidget({Key key, this.nullable = false}) : super(key: key);

  final bool nullable;

  P convert(S state);

  bool where(P oldState, P newState) =>
      oldState != null && newState != null && newState != oldState;
}

abstract class ConnectState<S, P, W extends ConnectWidget<S, P>>
    extends State<W> {
  P _props;
  StreamSubscription<P> _subscription;

  P get props => _props;

  Store<S> dispatch(ActionType action) => Provider.dispatch<S>(context, action);

  @override
  void didChangeDependencies() {
    final store = Provider.of<S>(context).store;

    _subscription = store.stream
        .map<P>(widget.convert)
        .where((next) => widget.where(_props, next))
        .listen((props) {
      setState(() => _props = props);
    });

    _props = widget.convert(store.state);

    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    _subscription.cancel();

    super.deactivate();
  }
}
