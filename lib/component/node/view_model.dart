import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_path_visualizer/styles.dart';
import 'package:stacked/stacked.dart';

class NodeModel extends BaseViewModel {
  NodeModel({
    Key key,
    this.row,
    this.col,
    this.start,
    this.end,
    this.visited = false,
    this.isWall = false,
    this.previousNode = null,
    this.width = 20,
    this.height = 20,
    this.colors = ColorStyle.notVisited,
    this.border = Colors.blueAccent,
  });

  int row;
  int col;
  bool start;
  bool end;
  bool visited;
  bool isWall;
  List<Color> colors;
  Color border;
  double width;
  double height;
  NodeModel previousNode;

  void visit() {
    visited = true;
    if(!start && !end) {
      colors = ColorStyle.visited;
    }
  }

  updateVisited() {
    notifyListeners();
  }

  updatePath() {
    if (!start && !end) {
      colors = ColorStyle.path;
      border = Colors.yellow;
      notifyListeners();
    }
  }

  void toggleWall() {
    if(!start && !end) {
      colors = !isWall ? ColorStyle.wall : ColorStyle.notVisited;
      isWall = !isWall;
      notifyListeners(); 
    }
  }

  void unVisit() {
    visited = false;
  }

  void resetColor() {
    if(!start && !end && !isWall && colors[0] != Colors.white) {
      colors = ColorStyle.notVisited;
      border = Colors.blueAccent;
    }
    notifyListeners();
  }
}
