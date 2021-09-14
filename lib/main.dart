import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/component/node/view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';
import 'component/node/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}

// View
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using the reactive constructor gives you the traditional ViewModel
    // binding which will execute the builder again when notifyListeners is called.
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.generateGrid(),
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text('AppBar Demo'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'This is a snackbar'
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Next page'),
                        ),
                        body: const Center(
                          child: Text(
                            'This is the next page',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            runSpacing: 50,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int row = 0; row < viewModel.grid.length; row++) ...[
                    Column(
                      children: [
                        for (int col = 0;
                            col < viewModel.grid[0].length;
                            col++) ...[
                          ChangeNotifierProvider.value(
                            value: viewModel.grid[row][col],
                            child: Node(),
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
                    onPressed: () {
                      viewModel.updateUI(viewModel.bfs());
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
                    onPressed: () {
                      List<NodeModel> nodes = viewModel.dfs();
                      viewModel.updateUI(nodes);
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
                  MaterialButton(
                    onPressed: () {
                      viewModel.resetGrid();
                    },
                    color: Colors.blueAccent,
                    disabledColor: Colors.red,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Text('RESET'),
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ViewModel
class HomeViewModel extends BaseViewModel {
  int maxRow = 50;
  int maxCol = 30;
  int startRow = 20;
  int startCol = 15;
  int endRow = 6;
  int endCol = 6;

  List<List<NodeModel>> grid;
  List<List<int>> directions = [
    [1, 0],
    [0, -1],
    [-1, 0],
    [0, 1],
  ];

  void generateGrid() {
    grid = [];
    for (int i = 0; i < maxRow; i++) {
      List<NodeModel> row = [];
      for (int j = 0; j < maxCol; j++) {
        bool isStart = i == startRow && j == startCol;
        bool isEnd = i == endRow && j == endCol;
        row.add(
          NodeModel(
            row: i,
            col: j,
            start: isStart,
            end: isEnd,
            visited: false,
            isWall: false,
          ),
        );
      }
      grid.add(row);
    }
  }

  List<NodeModel> bfs() {
    List<NodeModel> list = [];
    Queue<NodeModel> queue = Queue();
    queue.add(grid[startRow][startCol]);
    while (queue.isNotEmpty) {
      int size = queue.length;
      for (int i = 0; i < size; i++) {
        NodeModel node = queue.removeFirst();
        if (node.visited) {
          continue;
        }
        node.visit();
        list.add(node);
        if (node.row == endRow && node.col == endCol) {
          return list;
        }
        List<NodeModel> neighbors = getNeighbors(node.row, node.col);
        for (NodeModel model in neighbors) {
          if (!model.visited && !model.isWall) {
            queue.add(model);
          }
        }
      }
    }
    return list;
  }

  List<NodeModel> dfs() {
    List<NodeModel> list = [];
    dfsHelper(list, grid[startRow][startCol]);
    return list;
  }

  void dfsHelper(List<NodeModel> list, NodeModel node) {
    if (grid[endRow][endCol].visited || node.visited) {
      return;
    }
    node.visit();
    list.add(node);
    if (node.row == endRow && node.col == endCol) {
      return;
    }
    for (List<int> direction in directions) {
      int curRow = node.row + direction[0];
      int curCol = node.col + direction[1];
      if (!isOutOfBoard(curRow, curCol) && !grid[curRow][curCol].visited && !grid[curRow][curCol].isWall) {
        dfsHelper(list, grid[curRow][curCol]);
      }
    }
    return;
  }

  List<NodeModel> getNeighbors(int row, int col) {
    List<NodeModel> list = [];
    for (List<int> direction in directions) {
      int curRow = row + direction[0];
      int curCol = col + direction[1];
      if (!isOutOfBoard(curRow, curCol)) {
        list.add(grid[curRow][curCol]);
      }
    }
    return list;
  }

  bool isOutOfBoard(int row, int col) {
    if (row >= grid.length || col >= grid[0].length || row < 0 || col < 0) {
      return true;
    }
    return false;
  }

  void updateUI(List<NodeModel> list) async {
    for (int i = 0; i < list.length; i++) {
      list[i].updatePath(i);
    }
  }

  void resetGrid() {
    for (List<NodeModel> row in grid) {
      for (NodeModel node in row) {
        node.unVisit();
      }
    }
    notifyListeners();
  }
}
