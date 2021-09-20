import 'package:flutter/material.dart';
import '../../path_visualizer.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    this.curAlgorithm,
    this.curBrush,
    this.onBrushChange,
    this.onAlgorithmChange,
    this.resetGrid,
    this.resetAll,
    this.executeAlgorithm,
  }) : super(key: key);

 
  final Brush curBrush;
  final Function onBrushChange;
  final Algorithm curAlgorithm;
  final Function onAlgorithmChange;
  final Function executeAlgorithm;
  final Function resetGrid;
  final Function resetAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 55,
      color: Colors.blueAccent,
      child: Row(
        children: [
          const Text(
            'Path Visualizer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
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
                      const Text(
                        'Algorithms',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      DropdownButton<Algorithm>(
                        dropdownColor: Colors.blueAccent,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        value: curAlgorithm,
                        items: <Algorithm>[Algorithm.bfs, Algorithm.dfs].map((Algorithm value) {
                          return DropdownMenuItem<Algorithm>(
                            value: value,
                            child: Text(
                              algorithmMap[value],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {
                          onAlgorithmChange(_);
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                        color: Colors.blueAccent
                        // color: viewModel.isUpdating ? Colors.redAccent : null,
                      ),
                      child: const Text(
                        'Visualize!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    onTap: () {
                      executeAlgorithm();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Clear Board',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    onTap: () {
                      resetAll();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Clear Path',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    onTap: () {
                      resetGrid();
                    },
                  ),
                  const Text(
                    'Speed: fast',
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 18,
                    ),
                  ),
                   Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      const Text(
                        'NodeType',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      DropdownButton<Brush>(
                        dropdownColor: Colors.blueAccent,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        value: curBrush,
                        items: <Brush>[Brush.start, Brush.end, Brush.wall].map((Brush type) {
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
                        onChanged: (chosenBrush) {
                          onBrushChange(chosenBrush);
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
