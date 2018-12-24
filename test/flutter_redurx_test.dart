import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:flutter_test/flutter_test.dart';

class State {
  State([this.count = 0]);
  final int count;
}

class Increment extends Action<State> {
  @override
  State reduce(State state) => State(state.count + 1);
}

class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        children: <Widget>[
          Connect<State, int>(
            convert: (state) => state.count,
            where: (prev, next) => next != prev,
            builder: (counter, child) => Text(counter.toString()),
          ),
          RaisedButton(
            onPressed: () => Provider.dispatch<State>(context, Increment()),
          ),
        ],
      ),
    );
  }
}

class CallbackWidget extends StatelessWidget {
  final void Function(BuildContext) callback;
  final Widget child;

  const CallbackWidget(this.callback, {this.child});

  @override
  Widget build(BuildContext context) {
    callback(context);
    return child ?? Container();
  }
}

void main() async {
  testWidgets('Provider should build its child.', (tester) async {
    final store = Store(State());
    final fixture = Container();

    await tester.pumpWidget(Provider(store: store, child: fixture));

    expect(find.byWidget(fixture), findsOneWidget);
  });

  testWidgets('Connect\'s null value Widget is a Container.', (tester) async {
    final store = Store(State(0));

    final fixture = Connect<State, int>(
      convert: (state) => state.count,
      where: (prev, next) => next != prev,
      builder: (count, child) => Text(count.toString()),
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));

    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Connect should build with props.', (tester) async {
    final store = Store(State(0));

    final fixture = Connect<State, int>(
      convert: (state) => state.count,
      where: (prev, next) => next != prev,
      builder: (count, child) =>
          Text(count.toString(), textDirection: TextDirection.ltr),
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));
    await tester.pump(Duration.zero);

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Connect should rebuild if props has changed.', (tester) async {
    final store = Store(State(0));

    final fixture = Connect<State, int>(
      convert: (state) => state.count,
      where: (prev, next) => next != prev,
      builder: (count, child) =>
          Text(count.toString(), textDirection: TextDirection.ltr),
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));
    await tester.pump(Duration.zero);

    expect(find.text('0'), findsOneWidget);

    store.dispatch(Increment());
    await tester.pump(Duration.zero);

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Provider should dispatch actions.', (tester) async {
    final store = Store(State(0));
    final fixture = Counter();

    await tester.pumpWidget(Provider(store: store, child: fixture));
    await tester.pump(Duration.zero);

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byType(RaisedButton));
    await tester.pump(Duration.zero);

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Nullable Connect should build even for null values.',
      (tester) async {
    final store = Store(State(0));

    final fixture = Connect<State, int>(
      convert: (state) => state.count,
      where: (prev, next) => next != prev,
      builder: (count, child) => Text(count == null ? 'null' : count.toString(),
          textDirection: TextDirection.ltr),
      nullable: true,
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));

    expect(find.text('null'), findsOneWidget);
  });

  testWidgets('does not rebuild child', (tester) async {
    int childBuilds = 0;
    int builderBuilds = 0;

    final callbackChild = CallbackWidget((_) {
      childBuilds++;
    });

    final store = Store(State(0));

    final fixture = Connect<State, int>(
      convert: (state) => state.count,
      where: (prev, next) => next != prev,
      builder: (count, child) {
        return CallbackWidget(
          (_) {
            builderBuilds++;
          },
          child: child,
        );
      },
      child: callbackChild,
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));
    expect(childBuilds, 0);
    expect(builderBuilds, 0);

    // first build, both child and builder should run
    store.dispatch(Increment());
    await tester.pumpAndSettle();
    expect(childBuilds, 1);
    expect(builderBuilds, 1);

    // second build, child should not be rebuilt
    store.dispatch(Increment());
    await tester.pumpAndSettle();
    expect(childBuilds, 1);
    expect(builderBuilds, 2);
  });
}
