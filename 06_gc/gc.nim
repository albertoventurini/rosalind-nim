import os
import std/sequtils
import std/streams
import nre
import std/strformat

type
    DnaString = ref DnaStringObj
    DnaStringObj = object
        name: string
        str: string

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

proc calcGcContent(dnaString: DnaString): float =
    let gcCount = dnaString.str.countIt(it == 'G' or it == 'C')
    return (gcCount / dnaString.str.len) * 100

proc calcMaxGcContent(stream: Stream): (DnaString, float) =
    var maxGcString: DnaString = nil
    var maxGcContent = -1.0

    while not atEnd(stream):
        let str = parseNextDnaString(stream)
        let gcContent = calcGcContent(str)
        if gcContent > maxGcContent:
            maxGcContent = gcContent
            maxGcString = str
    
    return (maxGcString, maxGcContent)

let fileName = paramStr(1)
let fileStream = newFileStream(fileName)
if not isNil(fileStream):
    let maxGcContent = calcMaxGcContent(fileStream)
    echo $maxGcContent[0].name
    echo $maxGcContent[1]
 
    fileStream.close()