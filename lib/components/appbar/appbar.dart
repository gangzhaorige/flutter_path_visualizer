import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/main.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../path_visualizer.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    this.resetGrid,
    this.resetAll,
    this.executeAlgorithm,
    this.executeMaze,
  }) : super(key: key);

  final Function resetGrid;
  final Function resetAll;
  final Function executeAlgorithm;
  final Function executeMaze;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 55,
      color: Colors.blueAccent,
      child: Row(
        children: [
          Text(
            'Path Visualizer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 30,
                children: [
                  Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Algorithms',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                      Selector<PathNotifier, Algorithm>(
                        selector: (_, state) => state.curAlgorithm,
                        builder: (_, curAlgorithm, __) {
                          return DropdownButton<Algorithm>(
                            dropdownColor: Colors.blueAccent,
                            style: TextStyle(
                              fontSize: 10.sp,
                            ),
                            value: curAlgorithm,
                            items: <Algorithm>[Algorithm.bfs, Algorithm.dfs, Algorithm.dijkstra, Algorithm.aStar].map((Algorithm value) {
                              return DropdownMenuItem<Algorithm>(
                                value: value,
                                child: Text(
                                  algorithmMap[value][0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {
                              Provider.of<PathNotifier>(context, listen: false).changeAlgorithm(_);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Selector<PathNotifier, Maze>(
                    selector: (_, state) => state.curMaze,
                    builder: (_, curMaze, __) {
                      return DropdownButton<Maze>(
                        dropdownColor: Colors.blueAccent,
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                        value: curMaze,
                        items: [Maze.random, Maze.prim].map((Maze type) {
                          return DropdownMenuItem<Maze>(
                            value: type,
                            child: Text(
                              mazeMap[type],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              print('maze');                              
                            },
                          );
                        }).toList(),
                        onChanged: (_) {
                          Provider.of<PathNotifier>(context, listen: false).setMaze(_);
                        },
                      );
                    },
                  ),
                  Selector<PathNotifier, bool>(
                    selector: (_, state) => state.isVisualizing,
                    builder: (_, isVisualizing, __) {
                      return TextButton(
                        child: Text(
                          'Generate Maze!',
                          style: TextStyle(
                            color: isVisualizing ? Colors.redAccent : Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        onPressed: isVisualizing ? null : () async {
                          executeMaze(
                            Provider.of<PathNotifier>(context, listen: false).curMaze,
                            Provider.of<PathNotifier>(context, listen: false).curSpeed,
                            Provider.of<PathNotifier>(context, listen: false).setVisualizing,
                          );
                        },
                      );
                    }
                  ),
                  Selector<PathNotifier, bool>(
                    selector: (_, state) => state.isVisualizing,
                    builder: (_, isVisualizing, __) {
                      return TextButton(
                        child: Text(
                          'Visualize!',
                          style: TextStyle(
                            color: isVisualizing ? Colors.redAccent : Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        onPressed: isVisualizing ? null : () async {
                          executeAlgorithm(
                            Provider.of<PathNotifier>(context, listen: false).curAlgorithm,
                            Provider.of<PathNotifier>(context, listen: false).curSpeed,
                            Provider.of<PathNotifier>(context, listen: false).setVisualizing,
                          );
                        },
                      );
                    }
                  ),
                  Selector<PathNotifier, bool>(
                    selector: (_, state) => state.isVisualizing,
                    builder: (_, isVisualizing, __) {
                      return TextButton(
                        child: Text(
                          'Clear Board',
                          style: TextStyle(
                            color: isVisualizing ? Colors.redAccent : Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        onPressed: isVisualizing ? null : () {
                          resetAll();
                        },
                      );
                    }
                  ),
                  Selector<PathNotifier, bool>(
                    selector: (_, state) => state.isVisualizing,
                    builder: (_, isVisualizing, __) {
                      return TextButton(
                        child: Text(
                          'Clear Path',
                          style: TextStyle(
                            color: isVisualizing ? Colors.redAccent : Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        onPressed: isVisualizing ? null : () {
                          resetGrid();
                        },
                      );
                    }
                  ),
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Speed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                      Selector<PathNotifier, Speed>(
                        selector: (_, state) => state.curSpeed,
                        builder: (_, curSpeed, __) {
                          return DropdownButton<Speed>(
                            dropdownColor: Colors.blueAccent,
                            style: TextStyle(
                              fontSize: 10.sp,
                            ),
                            value: curSpeed,
                            items: <Speed>[Speed.fast, Speed.average, Speed.slow].map((Speed type) {
                              return DropdownMenuItem<Speed>(
                                value: type,
                                child: Text(
                                  speedMap[type],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {
                              Provider.of<PathNotifier>(context, listen: false).changeSpeed(_);
                            },
                          );
                        }
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Paint Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                      Selector<PathNotifier, Brush>(
                        selector: (_, state) => state.curBrush,
                        builder: (_, curBrush, __) {
                          return DropdownButton<Brush>(
                            dropdownColor: Colors.blueAccent,
                            style: TextStyle(
                              fontSize: 10.sp,
                            ),
                            value: curBrush,
                            items: <Brush>[Brush.start, Brush.end, Brush.wall, Brush.weight].map((Brush type) {
                              return DropdownMenuItem<Brush>(
                                value: type,
                                child: Text(
                                  brushMap[type],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {
                              Provider.of<PathNotifier>(context, listen: false).changeBrush(_);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
