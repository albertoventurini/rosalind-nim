import os
import std/streams
# import re
import nre
import std/tables

const k = 3

# let fileName = paramStr(1)
# var dna = readFile(fileName)

type
    Node* = tuple[name: string, dna: string]
    AdjacencyList = seq[tuple[v: Node, w: Node]]
    AffixTable* = Table[string, seq[Node]]

var adjList: ref AdjacencyList = seq[tuple[v: Node, w: Node]].new()

var nodesByPrefix: ref AffixTable = newTable[string, seq[Node]]()
var nodesBySuffix: ref AffixTable = newTable[string, seq[Node]]()

let firstLinePattern = re">(\w+)(?:\s+.+)?"

proc parseNextNode*(stream: Stream): Node =
    if atEnd(stream):
        raise newException(ValueError, "Stream is at end")

    let firstLine = readLine(stream)
    let match = firstLine.match(firstLinePattern)
    if match.isNone:
        raise newException(ValueError, "Invalid line: " & firstLine)

    let name = match.get.captures[0]
    var dna = ""

    while not atEnd(stream) and peekChar(stream) != '>':
        dna &= readLine(stream)

    (name, dna)

proc addNodeToTables*(node: Node, prefixes, suffixes: ref AffixTable) =
    let prefix = node.dna[0..k-1]
    let suffix = node.dna[^k..^1]

    if not prefixes.hasKey(prefix):
        prefixes[prefix] = newSeq[Node]()
    
    prefixes[prefix].add(node)

    if not suffixes.hasKey(suffix):
        suffixes[suffix] = newSeq[Node]()
    
    suffixes[suffix].add(node)

proc updateAdjacencyList*(node: Node, prefixes, suffixes: ref AffixTable, adjList: ref AdjacencyList) = 
    let prefix = node.dna[0..k-1]
    let suffix = node.dna[^k..^1]

    if prefixes.hasKey(suffix):
        for n in items(prefixes[suffix]):
            if node.name != n.name:
                adjList[].add((node, n))
    
    if suffixes.hasKey(prefix):
        for n in items(suffixes[prefix]):
            if node.name != n.name:
                adjList[].add((n, node))

proc processInputStream(stream: Stream) =
    while not atEnd(stream):
        let node = parseNextNode(stream)
        addNodeToTables(node, nodesByPrefix, nodesBySuffix)
        updateAdjacencyList(node, nodesByPrefix, nodesBySuffix, adjList)


let fileName = paramStr(1)
let fileStream = newFileStream(fileName)
if not isNil(fileStream):
    processInputStream(fileStream)

    for t in items(adjList[]):
        echo t.v.name & " " & $t.w.name
    
    fileStream.close()