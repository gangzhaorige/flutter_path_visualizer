
import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/store/app_state.dart';
import 'package:flutter_path_visualizer/store/reducer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'ui/component/node/view_model.dart';
import 'ui/pathVisualizer/view.dart';
void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
      brush: NodeType.WALL,
    ),
  );
  runApp(StoreProvider(store: store,child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PathVisualizerView(),
    );
  }
}
