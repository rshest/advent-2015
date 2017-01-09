import java.util.*
import java.io.File

class Edge(val to: Node, val dist: Int)
class Node(val name: String, val index: Int) {
  var edges: ArrayList<Edge> = arrayListOf()
}

class Graph : HashMap<String, Node>()

fun parseGraph(lines: List<String>): Graph {
  var graph = Graph()
  val pattern = """(.+) to (.+) = (\d+)""".toRegex()
  for (line in lines) {
    val parts = pattern.find(line)?.groupValues
    val (str, from, to, dist) = parts!!
    graph.putIfAbsent(from, Node(from, graph.size))
    graph.putIfAbsent(to, Node(to, graph.size))
    graph[from]!!.edges.add(Edge(graph[to]!!, dist.toInt()))
    graph[to]!!.edges.add(Edge(graph[from]!!, dist.toInt()))
  }
  return graph
}

//  returns -1 if there is no path between two nodes
fun getSalesmanDist(graph: Graph, from: Node, to: Node): Sequence<Int> {
  val numNodes = graph.size
  var visited = Array<Int>(graph.size) { -1 }
  var res: MutableList<Int> = arrayListOf()

  //  depth-first enumeration of all possible paths
  fun enumPath(start: Node, dist: Int, numVisited: Int) {
    visited[start.index] = start.index
    if (start == to) {
      if (numVisited == numNodes) {
        res.add(dist)
      }
    } else {
      val neighbors = start.edges.filter { visited[it.to.index] == -1 }
      for (edge in neighbors) {
        enumPath(edge.to, dist + edge.dist, numVisited + 1)
      }
    }
    visited[start.index] = -1
  }

  enumPath(from, 0, 1)
  return res.asSequence()
}

fun getSalesmanDist(graph: Graph): Sequence<Int> {
  val nodes = graph.values.asSequence()
  return nodes.flatMap { n1 ->
    nodes.flatMap { n2 ->
      getSalesmanDist(graph, n1, n2)
    }
  }
}

fun printGraph(graph: Graph) {
  for ((name, node) in graph) {
    println("node: $name (${node.index})")
    node.edges.forEach {
      e -> println(" -> ${e.to.name} (${e.dist})")
    }
  }
}

//  read data
val file = if (args.size > 0) args[0] else "input.txt"
val lines = File(file).readLines()
val graph = parseGraph(lines)

val distances = getSalesmanDist(graph)
if (distances.count() == 0) {
  println("Path does not exist")
} else {
  println("Shortest distance: ${distances.min()}")
  println("Longest distance: ${distances.max()}")
}
