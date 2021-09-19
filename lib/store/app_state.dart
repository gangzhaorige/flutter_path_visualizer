import 'package:flutter_path_visualizer/ui/component/node/view_model.dart';

class AppState {
  NodeType brush;
  List<int> start;
  List<int> end;

  AppState({
    this.brush = NodeType.WALL,
    this.start,
    this.end,
  });
}