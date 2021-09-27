import 'dart:collection';
import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:flutter_path_visualizer/main.dart';
import 'package:provider/provider.dart';

import 'components/appbar/appbar.dart';
import 'components/node/node.dart';
import 'components/node/node_description.dart';
import 'components/node/node_model.dart';

Map<Brush, String> brushMap = const {
  Brush.end : 'End',
  Brush.start : 'Start',
  Brush.wall : 'Wall',
  Brush.weight : 'Weight',
};

Map<Algorithm, String> algorithmMap = const {
  Algorithm.bfs : 'Breath First Search',
  Algorithm.dfs : 'Depth First Search',
  Algorithm.dijkstra : 'Dijkstra',
};

Map<Speed, String> speedMap = const {
  Speed.fast : 'Fast',
  Speed.average : 'Average',
  Speed.slow : 'Slow',
};

Map<Speed, int> speedValue = const {
  Speed.fast : 10,
  Speed.average : 15,
  Speed.slow : 25,
};

enum Brush {
  wall,
  start,
  end,
  weight,
}

enum Algorithm {
  dfs,
  bfs,
  dijkstra,
}

enum Speed {
  fast,
  average,
  slow,
}

class PathVisualizer extends StatefulWidget {
  const PathVisualizer({Key key}) : super(key: key);

  @override
  State<PathVisualizer> createState() => _PathVisualizerState();
}

class _PathVisualizerState extends State<PathVisualizer> {

  int startRow = 0;
  int startCol = 0;
  int endRow = 49;
  int endCol = 19;
  int totalRow = 60;
  int totalCol = 30;

  bool isVisualizing = false;

  List<List<NodeModel>> nodesStatus = [];

  List<NodeDescription> nodeDescriptions = [
    NodeDescription(
      description: 'Start Node',
      color: ColorStyle.start
    ),
    NodeDescription(
      description: 'End Node',
      color: ColorStyle.end
    ),
    NodeDescription(
      description: 'Wall',
      color: ColorStyle.wall,
    ),
    NodeDescription(
      description: 'Visited',
      color: ColorStyle.visited,
    ),
    NodeDescription(
      description: 'Not Visited',
      color: ColorStyle.notVisited
    ),
    NodeDescription(
      description: 'Path From Start to End',
      color: ColorStyle.startToEnd,
    )
  ];

  List<List<int>> directions = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
  ];

  @override
  void initState() {
    super.initState();
    for(int row = 0; row < totalRow; row++) {
      List<NodeModel> curRow = [];
      for(int col = 0; col < totalCol; col++) {
        curRow.add(
          NodeModel(
            row: row,
            col: col,
            nodeColor: row == startRow && col == startCol ? ColorStyle.start : row == endRow && col == endCol ? ColorStyle.end : null,
          ),
        );
      }
      nodesStatus.add(curRow);
    }
  }

  List<NodeModel> bfs() {
    List<NodeModel> list = [];
    Queue<NodeModel> queue = Queue();
    queue.add(nodesStatus[startRow][startCol]);
    while (queue.isNotEmpty) {
      int size = queue.length;
      for (int i = 0; i < size; i++) {
        NodeModel curNode = queue.removeFirst();
        if (curNode.isWall || curNode.visited) {
          continue;
        }
        visitNode(curNode.row, curNode.col);
        list.add(curNode);
        if (curNode.row == endRow && curNode.col == endCol) {
          return list;
        }
        List<NodeModel> neighbors = getUnvisitedNeighbors(curNode.row, curNode.col);
        for (NodeModel model in neighbors) {
          model.prev = curNode;
          queue.add(model);
        }
      }
    }
    return list;
  }

  List<NodeModel> dfs() {
    List<NodeModel> list = [];
    dfsHelper(list, nodesStatus[startRow][startCol]);
    return list;
  }

  void dfsHelper(List<NodeModel> list, NodeModel curNode) {
    if (nodesStatus[endRow][endCol].visited || curNode.visited) {
      return;
    }
    if (curNode.isWall || curNode.visited) {
      return;
    }
    visitNode(curNode.row, curNode.col);
    list.add(curNode);
    if (curNode.row == endRow && curNode.col == endCol) {
      return;
    }
    List<NodeModel> neighbors = getUnvisitedNeighbors(curNode.row, curNode.col);
    for (NodeModel model in neighbors) {
      model.prev = curNode;
      dfsHelper(list, model);
    }
    return;
  }

  List<NodeModel> dijkstra() {
    List<NodeModel> list = [];
    nodesStatus[startRow][startCol].distance = 0;
    PriorityQueue<NodeModel> queue = PriorityQueue<NodeModel>((a, b) => a.distance + a.weight - b.distance - b.weight);
    queue.add(nodesStatus[startRow][startCol]);
    while(queue.isNotEmpty) {
      NodeModel curNode = queue.removeFirst();
      if (curNode.isWall || curNode.visited) {
        continue;
      }
      visitNode(curNode.row, curNode.col);
      list.add(curNode);
      if (curNode.row == endRow && curNode.col == endCol) {
        return list;
      }
      List<NodeModel> neighbors = getUnvisitedNeighbors(curNode.row, curNode.col);
      for (NodeModel model in neighbors) {
        model.prev = curNode;
        model.distance = curNode.distance + curNode.weight + 1;
        queue.add(model);
      }  
    }
    return list;
  }

  List<NodeModel> getPathFromStartToEnd(NodeModel endNode) {
    List<NodeModel> list = [];
    NodeModel cur = endNode;
    while(cur != null) {
      list.insert(0, cur);
      cur = cur.prev;
    }
    return list;
  }

  List<NodeModel> getUnvisitedNeighbors(int row, int col) {
    List<NodeModel> list = [];
    for (List<int> direction in directions) {
      int curRow = row + direction[0];
      int curCol = col + direction[1];
      if (!isOutOfBoard(curRow, curCol) && !nodesStatus[curRow][curCol].visited) {
        list.add(nodesStatus[curRow][curCol]);
      }
    }
    return list;
  }

  bool isOutOfBoard(int row, int col) {
    if (row >= nodesStatus.length || col >= nodesStatus[0].length || row < 0 || col < 0) {
      return true;
    }
    return false;
  }

  void visitNode(int row, int col) {
    nodesStatus[row][col].visited = true;
  }

  void unvisitNode(int row, int col) {
    nodesStatus[row][col].visited = false;
  }

  void updateVisit(int row, int col, Color color) {
    nodesStatus[row][col].changeColor(color);
  }

  void paint(int row, int col, Brush curBrush) {
    if(isVisualizing){
      return;
    }
    NodeModel node = nodesStatus[row][col];
    if (!isStartOrEnd(row, col)) {
      if (curBrush == Brush.wall) {
        if (node.isWall) {
          updateVisit(row, col, ColorStyle.notVisited);
          node.isWall = false;
        } else {
          node.weight = 0;
          updateVisit(row, col, ColorStyle.wall);
          node.isWall = true;
        }
      } else if (curBrush == Brush.start && !isEnd(row, col)) {
        node.isWall = false;
        node.weight = 0;
        updateVisit(startRow, startCol, ColorStyle.notVisited);
        startRow = row;
        startCol = col;
        updateVisit(startRow, startCol, ColorStyle.start);
      } else if (curBrush == Brush.end && !isStart(row, col)) {
        node.isWall = false;
        node.weight = 0;
        updateVisit(endRow, endCol, ColorStyle.notVisited);
        endRow = row;
        endCol = col;
        updateVisit(endRow, endCol, ColorStyle.end);
      } else if (curBrush == Brush.weight && !isStartOrEnd(row, col)) {
        node.isWall = false;
        node.nodeColor = ColorStyle.notVisited;
        if (node.weight == 0) {
          node.weight = 10;
        } else {
          node.weight = 0;
        }
        node.notifyListeners();
      }
    }
  }

  void executeAlgorithm(Algorithm curAlgorithm, Speed curSpeed) {
    List<NodeModel> orderOfVisit;
    if (curAlgorithm == Algorithm.bfs) {
      orderOfVisit = bfs();
    } else if (curAlgorithm == Algorithm.dfs){
      orderOfVisit = dfs();
    } else {
      orderOfVisit = dijkstra();
    }
    List<NodeModel> pathingOrder = getPathFromStartToEnd(nodesStatus[endRow][endCol]);
    visualizeAlgorithm(orderOfVisit, pathingOrder, curSpeed);
  }

  Future<int> visualizeAlgorithm(List<NodeModel> orderOfVisit, List<NodeModel> pathingOrder, Speed curSpeed) {
    isVisualizing = true;
    for(int i = 0; i <= orderOfVisit.length; i++) {
      if(i == orderOfVisit.length) {
        Future.delayed(Duration(milliseconds: speedValue[curSpeed] * i)).then((value) {
          visualizeFromStartToEnd(pathingOrder, curSpeed);
        });
        Future.delayed(Duration(milliseconds: orderOfVisit.length * speedValue[curSpeed] + pathingOrder.length * speedValue[curSpeed])).then((value) {
          isVisualizing = false;
        });
        return Future.value(orderOfVisit.length * speedValue[curSpeed] + pathingOrder.length * speedValue[curSpeed]);
      }
      Future.delayed(Duration(milliseconds: speedValue[curSpeed] * i)).then((value) {
        if (!isStartOrEnd(orderOfVisit[i].row, orderOfVisit[i].col)) {
          updateVisit(orderOfVisit[i].row, orderOfVisit[i].col, ColorStyle.visited);
        }
      });
    }
   
    return Future.value(orderOfVisit.length * speedValue[curSpeed]);
  }

  void visualizeFromStartToEnd(List<NodeModel> pathingOrder, Speed curSpeed) {
    int index = 0;
    for(NodeModel cur in pathingOrder) {
      Future.delayed(Duration(milliseconds: index * speedValue[curSpeed])).then((value) {
        if (!isStartOrEnd(cur.row, cur.col)) {
          updateVisit(cur.row, cur.col, ColorStyle.startToEnd);
        }
      });
      index++;
    }
  }

  Future<void> resetGrid() async {
    for (int i = 0; i < nodesStatus.length; i++) {
      for (int j = 0; j < nodesStatus[0].length; j++) {
        NodeModel curNode = nodesStatus[i][j];
        unvisitNode(i, j);
        if(isStartOrEnd(i, j) || curNode.isWall) {
          continue;
        }
        curNode.distance = 10000;
        curNode.nodeColor = ColorStyle.notVisited;
        curNode.notifyListeners();
        curNode.prev = null;
      }
    }
  }

  Future<void> resetAll() async {
    for (int i = 0; i < nodesStatus.length; i++) {
      for (int j = 0; j < nodesStatus[0].length; j++) {
        NodeModel curNode = nodesStatus[i][j];
        unvisitNode(i, j);
        if(isStartOrEnd(i, j)) {
          continue;
        }
        curNode.isWall = false;
        nodesStatus[i][j].nodeColor = ColorStyle.notVisited;
        curNode.prev = null;
        curNode.weight = 0;
        curNode.distance = 10000;
        curNode.notifyListeners();
      }
    }
  }

  bool isStartOrEnd(int i, int j) {
    if(isStart(i, j) || isEnd(i, j)) {
      return true;
    }
    return false;
  }

  bool isStart(int i, int j) {
    return i == startRow && j == startCol;
  }

  bool isEnd(int i, int j) {
    return i == endRow && j == endCol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAppBar(
            resetAll: resetAll,
            resetGrid: resetGrid,
            executeAlgorithm: executeAlgorithm,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 30,
                    children: [
                      for (NodeDescription node in nodeDescriptions) ...[
                        node,
                      ]
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (List<NodeModel> row in nodesStatus) ...[
                      Column(
                        children: [
                          for (NodeModel curNode in row) ... [
                            Builder(
                              builder: (context) {
                                return MouseRegion(
                                  onEnter: (event) {
                                    if(event.down) {
                                      paint(curNode.row, curNode.col, Provider.of<PathNotifier>(context, listen: false).curBrush);
                                    }
                                  },
                                  child: GestureDetector(
                                    child: ChangeNotifierProvider.value(
                                      value: curNode,
                                      child: Node()
                                    ),
                                    onTap: () {
                                      paint(curNode.row, curNode.col, Provider.of<PathNotifier>(context, listen: false).curBrush);
                                    }
                                  ),
                                );
                              }
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
