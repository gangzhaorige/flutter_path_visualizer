import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart';

import 'path_visualizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StatsFl(
        child: const PathVisualizer(),
      ),
    );
  }
}

