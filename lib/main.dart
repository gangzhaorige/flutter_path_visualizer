import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sizer/sizer.dart';
import 'package:statsfl/statsfl.dart';

import 'path_visualizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Path Visualizer',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: ChangeNotifierProvider(
            create: (BuildContext context) => PathNotifier(),
            child: const PathVisualizer(),
          ),
        );
      }
    );
  }
}

class PathNotifier extends ChangeNotifier {
  Brush _curBrush = Brush.wall;
  Algorithm _curAlgorithm = Algorithm.bfs;
  Speed _curSpeed = Speed.fast;
  bool _isVisualizing = false;
  Maze _curMaze = Maze.random;

  Brush get curBrush => _curBrush;
  Algorithm get curAlgorithm => _curAlgorithm;
  Speed get curSpeed => _curSpeed;
  bool get isVisualizing => _isVisualizing;
  Maze get curMaze => _curMaze;

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
  void setVisualizing(bool type){
    _isVisualizing = type;
    notifyListeners();
  }
  void setMaze(Maze type){
    _curMaze = type;
    notifyListeners();
  }
}

