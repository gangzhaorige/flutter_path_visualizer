import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_path_visualizer/styles.dart';
import 'package:flutter_path_visualizer/ui/pathVisualizer/view_model.dart';
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
    this.width = 35,
    this.height = 35,
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

  void toggleWall(NodeType curBrush, PathVisualizerViewModel parent) {
    if(curBrush == NodeType.WALL) {
      if(nodeType == NodeType.EMPTY) {
        nodeType = NodeType.WALL;
        colors = ColorStyle.wall;
      } else if (nodeType == NodeType.WALL){
        nodeType = NodeType.EMPTY;
        colors = ColorStyle.notVisited;
      } 
    } else if (curBrush == NodeType.STARTNODE) {
      nodeType = NodeType.STARTNODE;
      colors = ColorStyle.start;
    } else if (curBrush == NodeType.ENDNODE) {
      nodeType = NodeType.ENDNODE;
      colors = ColorStyle.end;
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

  void updateNode(NodeType curBrush, PathVisualizerViewModel parent)  {
    if(curBrush == NodeType.STARTNODE) {
      parent.removeStart();
      parent.startRow = row;
      parent.startCol = col; 
    } else if (curBrush == NodeType.ENDNODE) {
      parent.removeEnd();
      parent.endRow = row;
      parent.endCol = col;
    }
    toggleWall(curBrush, parent);
  }

}
