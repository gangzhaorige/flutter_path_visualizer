import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:flutter_path_visualizer/components/node/node_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';

class Node extends StatelessWidget {

  Widget build(BuildContext buildContext) {
    return SizedBox(
      width: 1.3.w,
      height: 1.3.w,
      child: Selector<NodeModel, Tuple2<Color, int>>(
        selector: (_, states) => Tuple2(states.nodeColor, states.weight),
         builder: (_, data, __) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: data.item1,
              border: Border.all(
                width: 1,
                color: ColorStyle.nodeBorder,
              ),
            ), 
            child: data.item2 != 0 ? Icon(
              Ionicons.md_lock,
              size: 1.2.w,
            ) : null,
          );
        },
      ),
    ); 
  }
}
