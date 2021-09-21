import 'dart:collection';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/colorStyle.dart';
import 'package:flutter_path_visualizer/components/node_description.dart';

import 'components/appbar/appbar.dart';
import 'components/node/node.dart';

Map<Brush, String> brushMap = const {
  Brush.end : 'End node',
  Brush.start : 'Start node',
  Brush.wall : 'Wall node',
};

Map<Algorithm, String> algorithmMap = const {
  Algorithm.bfs : 'Breath First Search',
  Algorithm.dfs : 'Depth First Search',
};

Map<Speed, String> speedMap = const {
  Speed.fast : 'Fast',
  Speed.average : 'Average',
  Speed.slow : 'Slow',
};

Map<Speed, int> speedValue = const {
  Speed.fast : 10,
  Speed.average : 15,
  Speed.slow : 20,
};

enum Brush {
  wall,
  start,
  end,
}

enum Algorithm {
  dfs,
  bfs,
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

  Brush curBrush = Brush.wall;
  Algorithm curAlgorithm = Algorithm.bfs;
  Speed curSpeed = Speed.fast; 

  List<List<Node>> nodesStatus = [];
  List<List<GlobalKey<NodeState>>> nodeKey;
  List<List<GlobalKey<FlipCardState>>> flipKey;
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
    [1, 0],
    [0, -1],
    [-1, 0],
    [0, 1],
  ];

  @override
  void initState() {
    super.initState();
    nodeKey = List.generate(totalRow, (row) => List.generate(totalCol, (col) => GlobalKey<NodeState>(debugLabel: '$row $col')));
    flipKey = List.generate(totalRow, (row) => List.generate(totalCol, (col) => GlobalKey<FlipCardState>(debugLabel: '$row $col')));
    for(int row = 0; row < totalRow; row++) {
      List<Node> curRow = [];
      for(int col = 0; col < totalCol; col++) {
        curRow.add(
          Node(
            key: nodeKey[row][col],
            cardKey: flipKey[row][col],
            row: row,
            col: col,
            nodeColor: row == startRow && col == startCol ? ColorStyle.start : row == endRow && col == endCol ? ColorStyle.end : null,
          ),
        );
      }
      nodesStatus.add(curRow);
    }
  }

  List<Node> bfs() {
    List<Node> list = [];
    Queue<Node> queue = Queue();
    queue.add(nodesStatus[startRow][startCol]);
    while (queue.isNotEmpty) {
      int size = queue.length;
      for (int i = 0; i < size; i++) {
        Node curNode = queue.removeFirst();
        if (curNode.visited) {
          continue;
        }
        visitNode(curNode.row, curNode.col);
        list.add(curNode);
        if (curNode.row == endRow && curNode.col == endCol) {
          return list;
        }
        List<Node> neighbors = getNeighbors(curNode.row, curNode.col);
        for (Node model in neighbors) {
          if (!model.visited) {
            model.prev = curNode;
            queue.add(model);
          }
        }
      }
    }
    return list;
  }

  List<Node> dfs() {
    List<Node> list = [];
    dfsHelper(list, nodesStatus[startRow][startCol]);
    return list;
  }

  void dfsHelper(List<Node> list, Node curNode) {
    if (nodesStatus[endRow][endCol].visited || curNode.visited) {
      return;
    }
    visitNode(curNode.row, curNode.col);
    list.add(curNode);
    if (curNode.row == endRow && curNode.col == endCol) {
      return;
    }
    List<Node> neighbors = getNeighbors(curNode.row, curNode.col);
    for (Node model in neighbors) {
      if (!model.visited) {
        model.prev = curNode;
        dfsHelper(list, model);
      }
    }
    return;
  }

  List<Node> getPathFromStartToEnd(Node endNode) {
    List<Node> list = [];
    Node cur = endNode;
    while(cur != null) {
      list.insert(0, cur);
      cur = cur.prev;
    }
    return list;
  }

  List<Node> getNeighbors(int row, int col) {
    List<Node> list = [];
    for (List<int> direction in directions) {
      int curRow = row + direction[0];
      int curCol = col + direction[1];
      if (!isOutOfBoard(curRow, curCol) && !nodesStatus[curRow][curCol].isWall) {
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
    nodeKey[row][col].currentState.setColor(color);
  }

  void paint(int row, int col) {
    if (!isStartOrEnd(row, col)) {
      if (curBrush == Brush.wall) {
        if (nodesStatus[row][col].isWall) {
          updateVisit(row, col, ColorStyle.notVisited);
          nodesStatus[row][col].isWall = false;
        } else {
          updateVisit(row, col, ColorStyle.wall);
          nodesStatus[row][col].isWall = true;
        }
      } else if (curBrush == Brush.start && !isEnd(row, col)) {
        nodesStatus[row][col].isWall = false;
        updateVisit(startRow, startCol, ColorStyle.notVisited);
        startRow = row;
        startCol = col;
        updateVisit(startRow, startCol, ColorStyle.start);
      } else if (curBrush == Brush.end && !isStart(row, col)) {
        nodesStatus[row][col].isWall = false;
        updateVisit(endRow, endCol, ColorStyle.notVisited);
        endRow = row;
        endCol = col;
        updateVisit(endRow, endCol, ColorStyle.end);
      }
    }
  }

  void executeAlgorithm() {
    List<Node> orderOfVisit;
    if (curAlgorithm == Algorithm.bfs) {
      orderOfVisit = bfs();
    } else {
      orderOfVisit = dfs();
    }
    List<Node> pathingOrder = getPathFromStartToEnd(nodesStatus[endRow][endCol]);
    visualizeAlgorithm(orderOfVisit, pathingOrder);
  }

  Future<int> visualizeAlgorithm(List<Node> orderOfVisit, List<Node> pathingOrder) {
    for(int i = 0; i <= orderOfVisit.length; i++) {
      if(i == orderOfVisit.length) {
        Future.delayed(Duration(milliseconds: speedValue[curSpeed] * i)).then((value) {
          visualizeFromStartToEnd(pathingOrder);
        });
        return Future.value(orderOfVisit.length * speedValue[curSpeed] + pathingOrder.length * speedValue[curSpeed]);
      }
      Future.delayed(Duration(milliseconds: speedValue[curSpeed] * i)).then((value) {
        if (!isStartOrEnd(orderOfVisit[i].row, orderOfVisit[i].col)) {
          updateVisit(orderOfVisit[i].row, orderOfVisit[i].col, ColorStyle.visited);
          orderOfVisit[i].cardKey.currentState.toggleCard();
        }
      });
    }
    return Future.value(orderOfVisit.length * speedValue[curSpeed]);
  }

  void visualizeFromStartToEnd(List<Node> pathingOrder) {
    int index = 0;
    for(Node cur in pathingOrder) {
      Future.delayed(Duration(milliseconds: index * speedValue[curSpeed])).then((value) {
        if (!isStartOrEnd(cur.row, cur.col)) {
          updateVisit(cur.row, cur.col, ColorStyle.startToEnd);
          cur.cardKey.currentState.toggleCard();
        }
      });
      index++;
    }
  }

  Future<void> resetGrid() async {
    for (int i = 0; i < nodesStatus.length; i++) {
      for (int j = 0; j < nodesStatus[0].length; j++) {
        Node curNode = nodesStatus[i][j];
        unvisitNode(i, j);
        if(isStartOrEnd(i, j) || curNode.isWall) {
          continue;
        }
        nodeKey[i][j].currentState.setColor(ColorStyle.notVisited);
        curNode.prev = null;
      }
    }
  }

  Future<void> resetAll() async {
    for (int i = 0; i < nodesStatus.length; i++) {
      for (int j = 0; j < nodesStatus[0].length; j++) {
        Node curNode = nodesStatus[i][j];
        unvisitNode(i, j);
        if(isStartOrEnd(i, j)) {
          continue;
        }
        curNode.isWall = false;
        nodeKey[i][j].currentState.setColor(ColorStyle.notVisited);
        curNode.prev = null;
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

  void setBrush(Brush type) {
    setState(() {
      curBrush = type;
    });
  }

  void setAlgorithm(Algorithm type) {
    setState(() {
      curAlgorithm = type;
    });
  }

  void setSpeed(Speed type) {
    setState(() {
      curSpeed = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAppBar(
            curBrush: curBrush,
            curAlgorithm: curAlgorithm,
            curSpeed: curSpeed,
            onBrushChange: setBrush,
            onAlgorithmChange: setAlgorithm,
            resetAll: resetAll,
            resetGrid: resetGrid,
            executeAlgorithm: executeAlgorithm,
            onSpeedChange: setSpeed,
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
                    for (List<Node> row in nodesStatus) ...[
                      Column(
                        children: [
                          for (Node curNode in row) ... [
                            MouseRegion(
                              onEnter: (event) {
                                if(event.down) {
                                  paint(curNode.row, curNode.col);
                                  curNode.cardKey.currentState.toggleCard();
                                }
                              },
                              child: GestureDetector(
                                child: curNode,
                                onTap: () {
                                  paint(curNode.row, curNode.col);
                                  curNode.cardKey.currentState.toggleCard();
                                }
                              ),
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
