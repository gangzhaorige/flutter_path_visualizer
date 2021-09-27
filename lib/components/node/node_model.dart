import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';

class NodeModel extends ChangeNotifier {
  NodeModel({
    Key key,
    this.row,
    this.col,
    this.visited = false,
    this.nodeColor = Colors.white,
    this.isWall = false,
    this.weight = 0,
    this.distance = 10000,
  });

  int row;
  int col;
  int weight;
  int distance;
  bool visited;
  bool isWall;
  NodeModel prev;
  Color nodeColor;

  void changeColor(Color color) {
    nodeColor = color;
    notifyListeners();
  }
}
