import 'package:flutter/material.dart';


abstract class ColorStyle {

  static const List<Color> wall = [Colors.black, Colors.black];

  static const List<Color> start = [Colors.blue, Colors.blue];

  static const List<Color> end = [Colors.deepOrange, Colors.deepOrange];

  static const List<Color> visited = [Color.fromARGB(200, 0, 190, 218), Color.fromARGB(200, 0, 190, 218)];

  static const List<Color> notVisited = [Colors.white, Colors.white];

  static const List<Color> path = [Colors.yellow, Colors.yellow];
}