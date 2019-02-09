/// Behaves just like Connect but is extendable. Very useful when you see yourself in a Widget with a lot of Connects.
import 'package:flutter/widgets.dart';
import 'package:flutter_redurx/flutter_redurx.dart';

abstract class ConnectWidget<S, P> extends StatefulWidget {
  /// [convert] is how you map the State to [builder] props.
  P convert(S state);

  /// With [where] you can filter when the Widget should re-render, this is very important!
  bool where(P oldProps, P newProps) => newProps != oldProps;

  /// If you want to handle [null] values on the [builder] by yourself, set [nullable] to [true].
  Widget build(BuildContext context, P props);

  /// Sugar to dispatch actions without calling the Provider.
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
