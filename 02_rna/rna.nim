import os
import std/strutils

let fileName = paramStr(1)
let dna = readFile(fileName)
let rna = multiReplace(dna, ("T", "U"))
echo rna
