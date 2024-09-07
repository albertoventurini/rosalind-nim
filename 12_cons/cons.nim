import os
import std/sequtils
import std/streams
import nre
import std/enumutils
import std/strutils

type
    DnaString = ref DnaStringObj
    DnaStringObj = object
        name: string
        str: string
    Base = enum
        A, C, G, T
    ProfileMatrix = array[Base, seq[int]]


template useStream(stream: Stream, body: untyped) =
    if not isNil(stream):
        try:
            body
        finally:
            stream.close()

let firstLinePattern = re">(\w+)(?:\s+.+)?"
proc parseNextDnaString(stream: Stream): DnaString =
    if atEnd(stream):
        raise newException(ValueError, "Stream is at end")

    let firstLine = readLine(stream)
    let match = firstLine.match(firstLinePattern)
    if match.isNone:
        raise newException(ValueError, "Invalid line: " & firstLine)

    let name = match.get.captures[0]
    var str = ""

    while not atEnd(stream) and peekChar(stream) != '>':
        str &= readLine(stream)

    DnaString(name: name, str: str)

proc calcProfileMatrix(stream: Stream): ProfileMatrix =
    var m: ProfileMatrix
    var firstString: bool = true

    useStream(stream):
        var dnaString = parseNextDnaString(stream)

        m[A] = newSeq[int](dnaString.str.len)
        m[C] = newSeq[int](dnaString.str.len)
        m[G] = newSeq[int](dnaString.str.len)
        m[T] = newSeq[int](dnaString.str.len)

        while true:
            for i in 0 ..< dnaString.str.len:
                let base = parseEnum[Base]($dnaString.str[i])
                inc m[base][i]
            if atEnd(stream):
                break
            dnaString = parseNextDnaString(stream)

    return m


proc toString(m: ProfileMatrix): string =
    echo "A: " & m[A].mapIt($it).join(" ")
    echo "C: " & m[C].mapIt($it).join(" ")
    echo "G: " & m[G].mapIt($it).join(" ")
    echo "T: " & m[T].mapIt($it).join(" ")

proc getOneConsensusString(m: ProfileMatrix): string =
    var s = ""
    for i in 0 ..< m[A].len:
        var maxCount = 0
        var maxBase = A
        for j in items(Base):
            if m[j][i] > maxCount:
                maxCount = m[j][i]
                maxBase = j
        s.add($maxBase)
    return s

let fileName = paramStr(1)
let fileStream = newFileStream(fileName)
let profileMatrix = calcProfileMatrix(fileStream)
let consensusString = getOneConsensusString(profileMatrix)

echo consensusString
echo profileMatrix.toString