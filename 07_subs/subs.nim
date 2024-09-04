import os
import std/streams
import std/sequtils
from std/strutils import join

proc findNeedleInHaystack(s, t: string): seq[int] =
    var occurrences = newSeq[int]()

    for i in 0 ..< s.len:
        var j = 0
        while j < t.len and (i+j) < s.len and s[i+j] == t[j]:
            inc j
        if j == t.len:
            occurrences.add(i+1)

    return occurrences

proc parseStream(stream: Stream): (string, string) =
    let s = readLine(stream)
    let t = readLine(stream)
    return (s, t)

let fileName = paramStr(1)
let fileStream = newFileStream(fileName)
if not isNil(fileStream):
    let (s, t) = parseStream(fileStream)
    let occurrences = findNeedleInHaystack(s, t)
    echo occurrences.mapIt($it).join(" ")
    fileStream.close()