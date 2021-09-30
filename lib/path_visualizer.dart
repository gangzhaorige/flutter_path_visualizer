import 'dart:collection';
import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:flutter_path_visualizer/main.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

// [0] algorithm name, [1] description
Map<Algorithm, List<String>> algorithmMap = const {
  Algorithm.bfs : ['Breath First Search', 'Breath First Search is unweighted and guarantees the shortest path.'],
  Algorithm.dfs : ['Depth First Search', 'Death First Search is unweighted and does not guarantee the shortest path'],
  Algorithm.dijkstra : ['Dijkstra Search', 'Dijkstra Algorithm is weighted and guarantees the shortest path'],
  Algorithm.aStar : ['A* Search', 'A* Algorithm is weighted and guarantees the shortest path'],
};

Map<Speed, String> speedMap = const {
  Speed.fast : 'Fast',
  Speed.average : 'Average',
  Speed.slow : 'Slow',
};

Map<Speed, int> speedValue = const {
  Speed.fast : 5,
  Speed.average : 20,
  Speed.slow : 35,
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
  aStar,
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

  int startRow = 5;
  int startCol = 15;
  int endRow = 55;
  int endCol = 15;
  int totalRow = 60;
  int totalCol = 30;

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
    if (curNode.isWall || curNode.visited || nodesStatus[endRow][endCol].visited) {
      return;
    }
    visitNode(curNode.row, curNode.col);
    list.add(curNode);
    if (curNode.row == endRow && curNode.col == endCol) {
      return;
    }
    List<NodeModel> neighbors = getUnvisitedNeighbors(curNode.row, curNode.col);
    for (NodeModel model in neighbors) {
      if(!model.visited) {
        model.prev = curNode;
        dfsHelper(list, model);
      }
    }
    return;
  }

  List<NodeModel> dijkstra() {
    List<NodeModel> list = [];
    nodesStatus[startRow][startCol].distance = 0;
    PriorityQueue<NodeModel> queue = PriorityQueue<NodeModel>((a, b) => a.distance - b.distance);
    queue.add(nodesStatus[startRow][startCol]);
    while(queue.isNotEmpty) {
      NodeModel curNode = queue.removeFirst();
      List<NodeModel> neighbors = getNeighbors(curNode.row, curNode.col);
      visitNode(curNode.row, curNode.col);
      list.add(curNode);
      if(curNode.row == endRow && curNode.col == endCol) {
        return list;
      }
      for (NodeModel model in neighbors) {
        if(!model.visited && !model.isWall && model.distance > curNode.distance + model.weight + 1) {
          model.prev = curNode;
          model.distance = curNode.distance + model.weight + 1;
          queue.add(model);
        }
      }
    }
    return list;
  }

  List<NodeModel> aStar() {
    List<NodeModel> open = [];
    List<NodeModel> order = [];
    Set<NodeModel> closed = new Set();
    NodeModel startNode = nodesStatus[startRow][startCol];
    startNode.distance = 0;
    startNode.fn = 0;
    open.add(startNode);
    while(open.isNotEmpty) {
      open.sort();
      NodeModel cur = open.removeAt(0);
      closed.add(cur);
      order.add(cur);
      if(cur.row == endRow && cur.col == endCol) {
        return order;
      }
      List<NodeModel> neighbors = getNeighbors(cur.row, cur.col);
      for(NodeModel neighbor in neighbors) {
        if(neighbor.isWall) {
          continue;
        }
        if(closed.contains(neighbor)) {
          continue;
        }
        int gCost = cur.distance + neighbor.weight + 1;
        int heuristic = heuristic_cost_estimate(neighbor, nodesStatus[endRow][endCol]);
        int fn = gCost + heuristic;
        if(neighbor.distance < gCost || !open.contains(neighbor)) {
          neighbor.distance = gCost;
          neighbor.heuristic = heuristic;
          neighbor.fn = fn;
          neighbor.prev = cur;
          if(!open.contains(neighbor)) {
            open.add(neighbor);
          }
        }
      }
    }
    return order;
  }

  int heuristic_cost_estimate(NodeModel a, NodeModel b) {
    int deltaX = (a.row - b.row).abs();
    int deltaY = (a.col - b.col).abs();
    return deltaX + deltaY;
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

  List<NodeModel> getNeighbors(int row, int col) {
    List<NodeModel> list = [];
    for (List<int> direction in directions) {
      int curRow = row + direction[0];
      int curCol = col + direction[1];
      if (!isOutOfBoard(curRow, curCol)) {
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
          node.weight = 5;
        } else {
          node.weight = 0;
        }
        node.notifyListeners();
      }
    }
  }

  void executeAlgorithm(Algorithm curAlgorithm, Speed curSpeed, Function setVisualizing) {
    resetGrid().then((value) => Future.delayed(Duration(milliseconds: 500)).then((value) {
      List<NodeModel> orderOfVisit;
      if (curAlgorithm == Algorithm.bfs) {
        orderOfVisit = bfs();
      } else if (curAlgorithm == Algorithm.dfs) {
        orderOfVisit = dfs();
      } else if (curAlgorithm == Algorithm.dijkstra) { 
        orderOfVisit = dijkstra();
      } else {
        orderOfVisit = aStar();
      }
      List<NodeModel> pathingOrder = getPathFromStartToEnd(nodesStatus[endRow][endCol]);
      visualizeAlgorithm(orderOfVisit, pathingOrder, curSpeed, setVisualizing);
    }));
  }

  Future<int> visualizeAlgorithm(List<NodeModel> orderOfVisit, List<NodeModel> pathingOrder, Speed curSpeed, Function setVisualizing) {
    setVisualizing(true);
    for(int i = 0; i <= orderOfVisit.length; i++) {
      if(i == orderOfVisit.length) {
        Future.delayed(Duration(milliseconds: speedValue[curSpeed] * i)).then((value) {
          visualizeFromStartToEnd(pathingOrder, curSpeed);
        });
        Future.delayed(Duration(milliseconds: orderOfVisit.length * speedValue[curSpeed] + pathingOrder.length * speedValue[curSpeed])).then((value) {
          setVisualizing(false);
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
        if(!isStartOrEnd(i, j) && !curNode.isWall) {
          curNode.nodeColor = ColorStyle.notVisited;
        }
        curNode.distance = 10000;
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
        curNode.isWall = false;
        if(!isStartOrEnd(i, j)) {
          nodesStatus[i][j].nodeColor = ColorStyle.notVisited;
        }
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

  void randomWalls() {
    print('called');
    Random rng = new Random();
    for(int i = 0; i < nodesStatus.length; i++) {
      for(int j = 0; j < nodesStatus[0].length; j++) {
        if(!isStartOrEnd(i, j)) {
          NodeModel node = nodesStatus[i][j];
          int random = rng.nextInt(5);
          if(random > 3) {
            node.isWall = true;
            node.changeColor(ColorStyle.wall);
          }
        }
      }
    }
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
            randomWalls: randomWalls,
          ),
          MaterialButton(
            onPressed: randomWalls,
            child: Text('PRess Me'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      width: 100.w,
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
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.only(top: 50),
                      alignment: Alignment.center,
                      child: Center(
                        child: Selector<PathNotifier, Algorithm>(
                          selector: (_, state) => state.curAlgorithm,
                          builder: (_, data, __) {
                            return Text(
                              '${algorithmMap[data][1]}',
                              style: TextStyle(
                                fontSize: 10.sp,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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
                                    if(event.down && !Provider.of<PathNotifier>(context, listen: false).isVisualizing) {
                                      paint(curNode.row, curNode.col, Provider.of<PathNotifier>(context, listen: false).curBrush);
                                    }
                                  },
                                  child: GestureDetector(
                                    child: ChangeNotifierProvider.value(
                                      value: curNode,
                                      child: Node()
                                    ),
                                    onTap: () {
                                      if(!Provider.of<PathNotifier>(context, listen: false).isVisualizing){
                                        paint(curNode.row, curNode.col, Provider.of<PathNotifier>(context, listen: false).curBrush);
                                      }
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
