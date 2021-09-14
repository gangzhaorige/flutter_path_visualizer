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
  });

  int row;
  int col;
  bool start;
  bool end;
  bool visited;

  void visit() {
    visited = true;
  }

  void updatePath(int index) {
    Future.delayed(Duration(milliseconds: index * 15)).then((_) {
      notifyListeners();
    });
  }
}
