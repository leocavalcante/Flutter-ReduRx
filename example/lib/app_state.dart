import 'package:flutter_redurx/flutter_redurx.dart';

class AppState {
  AppState({this.title, this.count});
  final String title;
  final int count;
}

class Increment extends Action<AppState> {
  @override
  AppState reduce(AppState state) =>
      AppState(title: state.title, count: state.count + 1);
}
