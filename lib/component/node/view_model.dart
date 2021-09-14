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
  });

  int row;
  int col;
  bool start;
  bool end;
  bool visited;
  bool isWall;

  void visit() {
    visited = true;
  }

  void updatePath(int index) {
    Future.delayed(Duration(milliseconds: index * 10)).then((_) {
      notifyListeners();
    });
  }

  void toggleWall() {
    isWall = !isWall;
    notifyListeners();
  }

  void unVisit() {
    visited = false;
    notifyListeners();
  }
}
