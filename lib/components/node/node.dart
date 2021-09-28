import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:flutter_path_visualizer/components/node/node_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';

class Node extends StatelessWidget {

  Widget build(BuildContext buildContext) {
    return Selector<NodeModel, Tuple2<Color, int>>(
      selector: (_, states) => Tuple2(states.nodeColor, states.weight),
       builder: (_, data, __) {
        return Container(
          height: 2.1.h,
          width: 2.1.h,
          decoration: BoxDecoration(
            color: data.item1,
            border: Border.all(
              width: 1,
              color: ColorStyle.nodeBorder,
            ),
          ), 
          child: data.item2 != 0 ? Icon(
            FontAwesome5Solid.weight_hanging,
            size: 1.5.h,
          ) : null,
        );
      },
    ); 
  }
}
