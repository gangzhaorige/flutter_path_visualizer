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
      child: AnimatedContainer(
        alignment: Alignment.center,
        margin: EdgeInsets.all(1),
        height: 30,
        width: 30,
        color: viewModel.color,
        duration: Duration(milliseconds: 200),
      ),
      onTap: () {
        viewModel.toggleWall();
      },
    );
  }
}
