import os
import std/sequtils
import std/streams

template useStream(stream: Stream, body: untyped) =
    if not isNil(stream):
        try:
            body
        finally:
            stream.close()

proc hammingDist(s1, s2: string): int =
    doAssert s1.len == s2.len
    zip(s1, s2).countIt(it[0] != it[1])

let fileName = paramStr(1)
let fileStream = newFileStream(fileName)
useStream(fileStream):
    let s1 = readLine(fileStream)
    let s2 = readLine(fileStream)
    echo $hammingDist(s1, s2)