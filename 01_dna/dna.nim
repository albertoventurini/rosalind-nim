import std/strformat
import std/tables

var baseCounts = {'A': 0, 'C': 0, 'G': 0, 'T': 0}.toTable
var dnaString = readFile("rosalind_dna.txt")

for c in items(dnaString):
    if c in baseCounts:
        inc(baseCounts[c])

echo fmt"{baseCounts['A']} {baseCounts['C']} {baseCounts['G']} {baseCounts['T']}"