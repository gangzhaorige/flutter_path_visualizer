import 'package:flutter_path_visualizer/ui/component/node/view_model.dart';

class UpdateBrushAction {
  final NodeType updatedBrush;

  UpdateBrushAction({this.updatedBrush});
}

class UpdateStartAction {
  final List<int> updatePosition;

  UpdateStartAction({this.updatePosition});
}

class UpdateEndAction {
  final List<int> updatePosition;

  UpdateEndAction({this.updatePosition});
}