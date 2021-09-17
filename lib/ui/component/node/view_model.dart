import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_path_visualizer/styles.dart';
import 'package:stacked/stacked.dart';

enum NodeType {
  WALL,
  STARTNODE,
  ENDNODE,
  EMPTY,
}

class NodeModel extends BaseViewModel {
  NodeModel({
    Key key,
    this.row,
    this.col,
    this.visited = false,
    this.nodeType = NodeType.EMPTY,
    this.previousNode = null,
    this.width = 20,
    this.height = 20,
    this.colors = ColorStyle.notVisited,
    this.border = Colors.blueAccent,
  });

  int row;
  int col;
  bool visited;
  NodeType nodeType;
  List<Color> colors;
  Color border;
  double width;
  double height;
  NodeModel previousNode;

  void visit() {
    visited = true;
    if(nodeType != NodeType.STARTNODE && nodeType != NodeType.ENDNODE) {
      colors = ColorStyle.visited;
    }
  }

  updateVisited() {
    notifyListeners();
  }

  updatePath() {
    if (nodeType != NodeType.STARTNODE && nodeType != NodeType.ENDNODE) {
      colors = ColorStyle.path;
      border = Colors.yellow;
      notifyListeners();
    }
  }

  void toggleWall() {
    print(nodeType);
    if(nodeType == NodeType.EMPTY) {
      nodeType = NodeType.WALL;
      colors = ColorStyle.wall;
    } else if (nodeType == NodeType.WALL){
      nodeType = NodeType.EMPTY;
      colors = ColorStyle.notVisited;
    }
    notifyListeners();
  }

  void unVisit() {
    visited = false;
  }

  void resetColor() {
    if(nodeType != NodeType.STARTNODE && nodeType != NodeType.ENDNODE && nodeType != NodeType.WALL && colors[0] != Colors.white) {
      colors = ColorStyle.notVisited;
      border = Colors.blueAccent;
    }
    notifyListeners();
  }
}
