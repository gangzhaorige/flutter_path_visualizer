import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart'; 

import '../component/node/view_model.dart';
import '../component/node/view.dart';
import '../../styles.dart';
import 'view_model.dart';

class PathVisualizerView extends StatelessWidget {
  Widget build(BuildContext context) {
    // Using the reactive constructor gives you the traditional ViewModel
    // binding which will execute the builder again when notifyListeners is called.
    return ViewModelBuilder<PathVisualizerViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.generateGrid(),
      viewModelBuilder: () => PathVisualizerViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                 height: 55,
                color: Colors.blueAccent,
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        'Path Visualizer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 30,
                          children: [
                            Container(
                              child: Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    'Algorithms',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    dropdownColor: Colors.blueAccent,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    value: viewModel.algorithm,
                                    items: <String>['Depth First Search', 'Breath First Search'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      viewModel.changeAlgorithm(_);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                  color: viewModel.isUpdating ? Colors.redAccent : null,
                                ),
                                child: Text(
                                  'Visualize!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onTap: viewModel.isUpdating ? null : () async {
                                viewModel.change();
                                List<NodeModel> nodes = viewModel.bfs();
                                int timer = await viewModel.updateUI(nodes);
                                Future.delayed(Duration(milliseconds: timer)).then(
                                  (value) {
                                    viewModel.change();
                                  }
                                );
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Clear Board',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onTap: viewModel.isUpdating ? null : () async {
                                viewModel.resetAll();
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Clear Path',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onTap: viewModel.isUpdating ? null : () async {
                                viewModel.resetGrid();
                              },
                            ),
                            Text(
                              'Speed: fast',
                              style: TextStyle(
                                color: Colors.white,
                                 fontSize: 18,
                              ),
                            ),
                            Container(
                              child: Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    'NodeType:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  DropdownButton<NodeType>(
                                    dropdownColor: Colors.blueAccent,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    value: viewModel.curType,
                                    items: <NodeType>[NodeType.STARTNODE, NodeType.ENDNODE, NodeType.WALL].map((NodeType node) {
                                      return DropdownMenuItem<NodeType>(
                                        value: node,
                                        child: Text(viewModel.map[node]),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      viewModel.changeType(_);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Wrap(
                    runSpacing: 75,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 30,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                    color: ColorStyle.wall[0],
                                  ),
                                  height: 30,
                                  width: 30,
                                ),
                                Text('Wall'),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                    color: ColorStyle.visited[0],
                                  ),
                                  height: 30,
                                  width: 30,
                                ),
                                Text('Visited'),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                    color: ColorStyle.notVisited[0],
                                  ),
                                  height: 30,
                                  width: 30,
                                ),
                                Text('Non Visited'),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                    color: ColorStyle.path[0],
                                  ),
                                  height: 30,
                                  width: 30,
                                ),
                                Text('Shortest Path'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int row = 0; row < viewModel.grid.length; row++) ...[
                            Column(
                              children: [
                                for (int col = 0; col < viewModel.grid[0].length; col++) ...[
                                  ChangeNotifierProvider.value(
                                    value: viewModel.grid[row][col],
                                    child: Node(
              
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: viewModel.isUpdating ? null : () async {
                              viewModel.change();
                              List<NodeModel> nodes = viewModel.bfs();
                              int timer = await viewModel.updateUI(nodes);
                              print(timer);
                              Future.delayed(Duration(milliseconds: timer)).then((value) {
                                viewModel.change();
                              });
                            },
                            color: Colors.blueAccent,
                            disabledColor: Colors.red,
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Text('BFS'),
                              alignment: Alignment.center,
                            ),
                          ),
                          MaterialButton(
                            onPressed: viewModel.isUpdating ? null :() async {
                              viewModel.change();
                              List<NodeModel> nodes = viewModel.dfs();
                              int timer = await viewModel.updateUI(nodes);
                              Future.delayed(Duration(milliseconds: timer)).then((value) {
                                viewModel.change();
                              });
                            },
                            color: Colors.blueAccent,
                            disabledColor: Colors.red,
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Text('DFS'),
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

