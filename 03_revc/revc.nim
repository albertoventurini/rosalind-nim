import os

proc complement(c: char): char =
    return case c:
        of 'A': 'T'
        of 'T': 'A'
        of 'C': 'G'
        of 'G': 'C'
        else:
            raise newException(ValueError, "Invalid letter")

let fileName = paramStr(1)
var dna = readFile(fileName)

for i in 0 .. dna.len div 2:
    let j = dna.len - 1 - i
    if i > j:
        break
    elif i == j:
        dna[i] = complement(dna[i])
    else:
        let temp = dna[i]
        dna[i] = complement(dna[j])
        dna[j] = complement(temp)

echo dna


