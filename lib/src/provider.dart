import 'package:flutter/widgets.dart';
import 'package:redurx/redurx.dart';

/// Provider Widget to be on top of the App ([child]) providing the State from a given [store].
class Provider<T> extends InheritedWidget {
  Provider({
    Key key,
    @required Widget child,
    @required this.store,
  }) : super(key: key, child: child);

  /// The ReduRx Store.
  final Store<T> store;

  /// Gets the Provider from a given [BuildContext].
  static Provider<T> of<T>(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_targetType<Provider<T>>());

  static _targetType<T>() => T;

  /// Sugar to dispatch Actions on the Store in the Provider of the given [context].
  static Store<T> dispatch<T>(BuildContext context, ActionType action) =>
      Provider.of<T>(context).store.dispatch(action);

  /// Sugar to access the state from Provider.
  static T state<T>(BuildContext context) =>
      Provider.of<T>(context).store.state;

  /// We never trigger update, this is all up to ReduRx.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
