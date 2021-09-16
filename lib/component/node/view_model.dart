import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    this.color = Colors.black,
  });

  int row;
  int col;
  bool start;
  bool end;
  bool visited;
  bool isWall;
  Color color;
  NodeModel previousNode;

  void visit() {
    visited = true;
    if(!start && !end) {
      color = Colors.green;
    }
  }

  updateVisited() {
    notifyListeners();
  }

  updatePath() {
    if (!start && !end) {
      color = Colors.pink;
      notifyListeners();
    }
  }

  void toggleWall() {
    if(!start && !end) {
      color = !isWall ? Colors.yellow : Colors.black;
      isWall = !isWall;
      notifyListeners(); 
    }
  }

  void unVisit() {
    visited = false;
  }

  void resetColor() {
    if(!start && !end && !isWall && color != Colors.black) {
      color = Colors.black;
    }
    notifyListeners();
  }
}
