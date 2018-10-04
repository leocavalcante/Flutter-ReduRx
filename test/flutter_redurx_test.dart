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
            builder: (counter) => Text(counter.toString()),
          ),
          RaisedButton(
            onPressed: () => Provider.dispatch<State>(context, Increment()),
          ),
        ],
      ),
    );
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
      builder: (count) => Text(count.toString()),
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));

    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Connect should build with props.', (tester) async {
    final store = Store(State(0));

    final fixture = Connect<State, int>(
      convert: (state) => state.count,
      where: (prev, next) => next != prev,
      builder: (count) =>
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
      builder: (count) =>
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
      builder: (count) => Text(count == null ? 'null' : count.toString(),
          textDirection: TextDirection.ltr),
      nullable: true,
    );

    await tester.pumpWidget(Provider(store: store, child: fixture));

    expect(find.text('null'), findsOneWidget);
  });
}
