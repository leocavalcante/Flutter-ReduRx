import 'package:flutter/widgets.dart';
import 'package:flutter_redurx/flutter_redurx.dart';

abstract class ConnectWidget<S, P> extends StatefulWidget {
  P convert(S state);
  bool where(P oldProps, P newProps) => newProps != oldProps;
  Widget build(BuildContext context, P props);

  void dispatch(BuildContext context, ActionType action) => Provider.dispatch<S>(context, action);

  @override
  State<StatefulWidget> createState() => _ConnectWidgetState<S, P>();
}

class _ConnectWidgetState<S, P> extends State<ConnectWidget<S, P>> {
  @override
  Widget build(BuildContext context) {
    return Connect<S, P>(
      convert: widget.convert,
      where: widget.where,
      builder: (P props) => widget.build(context, props),
    );
  }
}
