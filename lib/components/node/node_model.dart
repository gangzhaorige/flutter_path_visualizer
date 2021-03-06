import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';

class NodeModel extends ChangeNotifier implements Comparable{
  NodeModel({
    Key key,
    this.row,
    this.col,
    this.visited = false,
    this.nodeColor = Colors.white,
    this.isWall = false,
    this.weight = 0,
    this.distance = 0,
    this.heuristic = 0,
    this.fn = 0,
  });

  int row;
  int col;
  int weight;
  int distance;
  int heuristic;
  int fn;
  bool visited;
  bool isWall;
  NodeModel prev;
  Color nodeColor;

  void changeColor(Color color) {
    nodeColor = color;
    notifyListeners();
  }

  @override
  int compareTo(other) {
    if(this.fn > other.fn) {
      return 1;
    } else if(this.fn < other.fn) {
      return -1;
    } else {
      return other.heuristic - this.heuristic;
    }
  }
}
