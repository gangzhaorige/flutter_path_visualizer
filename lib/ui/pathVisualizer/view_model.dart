
// ViewModel
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_path_visualizer/ui/component/node/view_model.dart';

import '../../styles.dart';

Map<NodeType, String> map = const {
  NodeType.ENDNODE : 'End node',
  NodeType.STARTNODE : 'Start node',
  NodeType.WALL : 'Wall node',
};

Map<Algorithm, String> map2 = const {
  Algorithm.BFS : 'Breath First Search',
  Algorithm.DFS : 'Depth First Search',
};

enum Algorithm {
  BFS,
  DFS,
}

class PathVisualizerViewModel extends ChangeNotifier {
  int maxRow = 40;
  int maxCol = 25;
  int startRow = 5;
  int startCol = 5;
  int endRow = 0;
  int endCol = 0;
  bool isUpdating = false;
  bool mouseIsPressed = false;
  Algorithm curAlgorithm = Algorithm.BFS;
  List<Algorithm> algorithms = [Algorithm.BFS, Algorithm.DFS];

  void changeAlgorithm(Algorithm algo) {
    curAlgorithm = algo;
    notifyListeners();
  }

  List<List<NodeModel>> grid = [];

  List<List<int>> directions = [
    [1, 0],
    [0, -1],
    [-1, 0],
    [0, 1],
  ];

  void generateGrid() {
    grid.clear();
    for (int i = 0; i < maxRow; i++) {
      List<NodeModel> row = [];
      for (int j = 0; j < maxCol; j++) {
        bool isStart = i == startRow && j == startCol;
        bool isEnd = i == endRow && j == endCol;
        row.add(
          NodeModel(
            row: i,
            col: j,
            visited: false,
            nodeType: () {
              if(isStart) {
                return NodeType.STARTNODE;
              } else if (isEnd) {
                return NodeType.ENDNODE;
              }
              return NodeType.EMPTY;
            } (),
            colors: () {
              if (isStart) {
                return ColorStyle.start;
              } else if (isEnd) {
                return ColorStyle.end;
              } else {
                return ColorStyle.notVisited;
              }
            } (),
          ),
        );
      }
      grid.add(row);
    }
    notifyListeners();
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
          if (!model.visited && model.nodeType != NodeType.WALL) {
            model.previousNode = node;
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
      if (!isOutOfBoard(curRow, curCol) && !grid[curRow][curCol].visited && grid[curRow][curCol].nodeType != NodeType.WALL) {
        NodeModel next = grid[curRow][curCol];
        next.previousNode = node;
        dfsHelper(list, next);
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

  Future<int> updateUI(List<NodeModel> visitedNodeInOrder,) async {
    Queue<NodeModel> shortestPathOrder = getNodesInShortestPathOrder(grid[endRow][endCol]);
    for (int i = 0; i <= visitedNodeInOrder.length; i++) {
      if(i == visitedNodeInOrder.length) {
        Future.delayed(Duration(milliseconds: 16 * i)).then((value) {
          animateShortestPath(shortestPathOrder);
        });
        return Future.value(visitedNodeInOrder.length * 16 + shortestPathOrder.length * 16);
      }
      Future.delayed(Duration(milliseconds: 16 * i)).then((value) {
        visitedNodeInOrder[i].updateVisited();
      });
    }
    return Future.value(visitedNodeInOrder.length * 16);
  }

  void animateShortestPath(Queue<NodeModel> shortestPathOrder) {
    int i= 0;
    while(shortestPathOrder.isNotEmpty) {
      NodeModel cur = shortestPathOrder.removeFirst();
      Future.delayed(Duration(milliseconds: 50 * i)).then((value) {
        cur.updatePath();
      });
      i++;
    }
  }

  Future<void> resetGrid() async {
    for (List<NodeModel> row in grid) {
      for (NodeModel node in row) {
        node.unVisit();
        node.resetColor();
        node.previousNode = null;
      }
    }
    notifyListeners();
  }

  void resetAll() {
    for (List<NodeModel> row in grid) {
      for (NodeModel node in row) {
        node.unVisit();
        node.resetColor();
        node.previousNode = null;
        if(node.nodeType == NodeType.WALL) {
          node.toggleWall(NodeType.WALL, this);
        }
      }
    }
    notifyListeners();
  }

  Queue<NodeModel> getNodesInShortestPathOrder(NodeModel endNode) {
    Queue<NodeModel> queue = new Queue();
    NodeModel cur = endNode;
    while(cur != null) {
      queue.addFirst(cur);
      cur = cur.previousNode;
    }
    return queue;
  }

  void change() {
    isUpdating = !isUpdating;
    notifyListeners();
  }


  void makeEmptyNode(int row, int col) {
    grid[row][col].nodeType = NodeType.EMPTY;
    grid[row][col].colors = [Colors.white,Colors.white];
    notifyListeners();
  }

  void removeStart() {
    grid[startRow][startCol].nodeType = NodeType.EMPTY;
    grid[startRow][startCol].colors = ColorStyle.notVisited;
    grid[startRow][startCol].notifyListeners();
  }

  void removeEnd() {
    grid[endRow][endCol].nodeType = NodeType.EMPTY;
    grid[endRow][endCol].colors = ColorStyle.notVisited;
    grid[endRow][endCol].notifyListeners();
  }

  void executeAlgorithm() async {
    change();
    List<NodeModel> nodes;
    if(curAlgorithm == Algorithm.BFS) {
      nodes = bfs();
    } else {
      nodes = dfs();
    }
    int timer = await updateUI(nodes);
    Future.delayed(Duration(milliseconds: timer)).then(
      (value) {
        change();
      }
    );
  }
}