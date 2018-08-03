import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:flutter_test/flutter_test.dart';

class State {
  State([this.count = 0]);
  final int count;
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
}
