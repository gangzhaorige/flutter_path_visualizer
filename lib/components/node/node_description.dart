import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';

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
          height: 30,
          width: 30,
        ),
        Text(
          description,
        ),
      ],
    );
  }
}