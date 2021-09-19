import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_path_visualizer/store/actions.dart';
import 'package:flutter_path_visualizer/store/app_state.dart';
import 'package:flutter_path_visualizer/ui/pathVisualizer/view_model.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stacked/stacked.dart';

import 'view_model.dart';

class Node extends ViewModelWidget<NodeModel>{
  Node({
    Key key,
    this.parent,
  });

  PathVisualizerViewModel parent;

  @override
  Widget build(BuildContext context, NodeModel viewModel) {
    return StoreConnector<AppState, NodeType>(
      converter: (store) => store.state.brush,
      builder: (context, curBrush) => MouseRegion(
        onEnter: (event) {
          if(event.down) {
            viewModel.updateNode(curBrush, parent);
          }
        },
        child: GestureDetector(
          onTap: () {
            viewModel.updateNode(curBrush, parent);
          },
          child: AnimatedContainer(
            height: viewModel.height,
            width: viewModel.width,
            decoration: BoxDecoration(
              border: Border.all(
                color: viewModel.border,
                width: 0.5,
              ),
              gradient: RadialGradient(
                colors: viewModel.colors,
              ),
            ),
            duration: Duration(milliseconds: 500),
          ),
        ),
      ),
    );
  }
}


