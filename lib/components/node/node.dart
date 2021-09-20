import 'package:flutter/material.dart';

class Node extends StatefulWidget {
  Node({
    Key key,
    @required this.row,
    @required this.col,
    this.visited = false,
    this.nodeColor = Colors.white,
    this.isWall = false,
  }) : super(key: key);

  int row;
  int col;
  bool visited;
  bool isWall;
  Color nodeColor;
  Node prev;

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
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: nodeColor,
        border: Border.all(
          width: 1,
          color: Colors.lightBlue,
        ),
      ),
    );
  }
}