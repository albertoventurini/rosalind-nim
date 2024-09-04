import std/sequtils
import std/streams
import std/tables
import unittest

import grph

suite "Overlap Graphs":
  test "parseNextNode_emptyString_raisesException":
    expect(ValueError):
      discard parseNextNode(newStringStream(""))

  test "parseNextNode_withInvalidLine_raisesException":
    expect(ValueError):
      discard parseNextNode(newStringStream("Not a valid line"))
  
  test "parseNextNode_withValidLine_returnsNode":
    var stream: StringStream = newStringStream("""
>Rosalind_0498 something
AAATAAA
""")
    check parseNextNode(stream) == ("Rosalind_0498", "AAATAAA")
  
  test "addNodeToTables_withValidNode_addsNodeToTables":
    var prefixes = newTable[string, seq[Node]]()
    var suffixes = newTable[string, seq[Node]]()
    let node = ("Rosalind_0498", "AAATGGG")

    addNodeToTables(node, prefixes, suffixes)

    check any(prefixes["AAA"], proc(n: Node): bool = n == node)
    check any(suffixes["GGG"], proc(n: Node): bool = n == node)
  
  test "updateAdjacencyList_addsNodeCorrectly":
    let rosalind_0498 = ("Rosalind_0498", "AAATAAA")
    let rosalind_2391 = ("Rosalind_2391", "AAATTTT")
    var prefixes = newTable[string, seq[Node]]()
    var suffixes = newTable[string, seq[Node]]()
    var adjList = seq[tuple[v: Node, w: Node]].new()

    addNodeToTables(rosalind_0498, prefixes, suffixes)
    updateAdjacencyList(rosalind_0498, prefixes, suffixes, adjList)
    addNodeToTables(rosalind_2391, prefixes, suffixes)
    updateAdjacencyList(rosalind_2391, prefixes, suffixes, adjList)
    
    check adjList[].any(proc (nodes: tuple[v: Node, w: Node]): bool = nodes.v.name == "Rosalind_0498")