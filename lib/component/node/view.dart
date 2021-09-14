import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'view_model.dart';

class Node extends ViewModelWidget<NodeModel> {
  const Node({
    Key key,
  });

  @override
  Widget build(BuildContext context, NodeModel viewModel) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(1),
        height: 30,
        width: 30,
        color: (() {
          if (viewModel.visited) {
            return Colors.green;
          } else if (viewModel.end) {
            return Colors.blue;
          } else if (viewModel.start) {
            return Colors.red;
          }
          return Colors.black;
        }()),
      ),
    );
  }
}
