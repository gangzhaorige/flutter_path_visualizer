import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:flutter_path_visualizer/components/node/node_model.dart';
import 'package:provider/provider.dart';

class Node extends StatelessWidget {

  Widget build(BuildContext buildContext) {
    return Selector<NodeModel, Color>(
      selector: (_, states) => states.nodeColor,
      builder: (_,nodeColor,__) {
        return Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: nodeColor,
            border: Border.all(
              width: 1,
              color: ColorStyle.nodeBorder,
            ),
          ), 
        );
      },
    ); 
  }
}
