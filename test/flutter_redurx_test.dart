import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:flutter_test/flutter_test.dart';

class State {
  State(this.count);
  final int count;
}

class Fixture extends StatelessWidget {
  Fixture({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  final state = State(0);
  final store = Store(state);

  testWidgets('Provider should build its child.', (tester) async {
    final fixture = Fixture();
    await tester.pumpWidget(Provider(store: store, child: fixture));
    expect(find.byWidget(fixture), findsOneWidget);
  });
}
