import 'package:flutter/material.dart';

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
              color: Colors.blueAccent,
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