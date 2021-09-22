import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        child: ChangeNotifierProvider(
          create: (BuildContext context) => PathNotifier(),
          child: const PathVisualizer()
        ),
      ),
    );
  }
}

class PathNotifier extends ChangeNotifier {
  Brush _curBrush = Brush.wall;
  Algorithm _curAlgorithm = Algorithm.bfs;
  Speed _curSpeed = Speed.fast;

  Brush get curBrush => _curBrush;
  Algorithm get curAlgorithm => _curAlgorithm;
  Speed get curSpeed => _curSpeed;

  void changeBrush(Brush type){
    _curBrush = type;
    notifyListeners();
  }
  void changeAlgorithm(Algorithm type){
    _curAlgorithm = type;
    notifyListeners();
  }
  void changeSpeed(Speed type){
    _curSpeed = type;
    notifyListeners();
  }
}

