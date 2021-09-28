import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NodeDescription extends StatelessWidget {
  NodeDescription({
    Key key,
    this.description,
    this.color,
  });

  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorStyle.primary,
              width: 1,
            ),
            color: color,
          ),
          height: 2.1.h,
          width: 2.1.h,
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}