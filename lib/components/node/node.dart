import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';

class Node extends StatefulWidget {
  Node({
    Key key,
    @required this.row,
    @required this.col,
    this.visited = false,
    this.nodeColor = Colors.white,
    this.isWall = false,
    this.cardKey,
  }) : super(key: key);

  int row;
  int col;
  bool visited;
  bool isWall;
  Color nodeColor;
  Node prev;
  GlobalKey<FlipCardState> cardKey;

  @override
  NodeState createState() => NodeState();
}

class NodeState extends State<Node> {
  
  int row;
  int col;
  bool visited;
  Color nodeColor;
  @override

  void initState() {
    row = widget.row;
    col = widget.col;
    visited = widget.visited;
    nodeColor = widget.nodeColor;
    super.initState();
  }
  
  void setColor(Color color) {
    setState(() {
      nodeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      speed: 400,
      direction: FlipDirection.HORIZONTAL,
      key: widget.cardKey,
      flipOnTouch: false,
      front: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: nodeColor,
          border: Border.all(
            width: 1,
            color: ColorStyle.nodeBorder,
          ),
        ),
      ),
      back: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: nodeColor,
          border: Border.all(
            width: 1,
            color: ColorStyle.nodeBorder,
          ),
        ),
      ),
    );
  }
}