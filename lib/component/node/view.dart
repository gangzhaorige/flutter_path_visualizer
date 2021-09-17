import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'view_model.dart';

class Node extends ViewModelWidget<NodeModel>{
  Node({
    Key key,
  });

  @override
  Widget build(BuildContext context, NodeModel viewModel) {
    return MouseRegion(
      onEnter: (event) {
        if(event.down) {
          viewModel.toggleWall();
        }
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        height: 30,
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
        duration: Duration(milliseconds: 100),
        curve: Curves.bounceInOut,
      ),
    );
  }
}


