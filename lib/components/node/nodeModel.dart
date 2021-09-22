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
  });

  int row;
  int col;
  bool visited;
  bool isWall;
  NodeModel prev;
  Color nodeColor;

  void changeColor(Color color) {
    nodeColor = color;
    notifyListeners();
  }
}
