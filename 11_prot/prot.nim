import os
import std/sequtils
import std/streams
import std/tables
import std/enumutils
import std/strutils

template useStream(stream: Stream, body: untyped) =
    if not isNil(stream):
        try:
            body
        finally:
            stream.close()

type Codon = enum
    UUU, CUU, AUU, GUU,
    UUC, CUC, AUC, GUC,
    UUA, CUA, AUA, GUA,
    UUG, CUG, AUG, GUG,
    UCU, CCU, ACU, GCU,
    UCC, CCC, ACC, GCC,
    UCA, CCA, ACA, GCA,
    UCG, CCG, ACG, GCG,
    UAU, CAU, AAU, GAU,
    UAC, CAC, AAC, GAC,
    UAA, CAA, AAA, GAA,
    UAG, CAG, AAG, GAG,
    UGU, CGU, AGU, GGU,
    UGC, CGC, AGC, GGC,
    UGA, CGA, AGA, GGA,
    UGG, CGG, AGG, GGG

type AminoAcid = enum
    A, C, D, E, F, G, H, I,
    K, L, M, N, P, Q, R,
    S, T, V, W, Y, STOP

let translationTable = {
    UUU: F,    CUU: L, AUU: I, GUU: V,
    UUC: F,    CUC: L, AUC: I, GUC: V,
    UUA: L,    CUA: L, AUA: I, GUA: V,
    UUG: L,    CUG: L, AUG: M, GUG: V,
    UCU: S,    CCU: P, ACU: T, GCU: A,
    UCC: S,    CCC: P, ACC: T, GCC: A,
    UCA: S,    CCA: P, ACA: T, GCA: A,
    UCG: S,    CCG: P, ACG: T, GCG: A,
    UAU: Y,    CAU: H, AAU: N, GAU: D,
    UAC: Y,    CAC: H, AAC: N, GAC: D,
    UAA: STOP, CAA: Q, AAA: K, GAA: E,
    UAG: STOP, CAG: Q, AAG: K, GAG: E,
    UGU: C,    CGU: R, AGU: S, GGU: G,
    UGC: C,    CGC: R, AGC: S, GGC: G,
    UGA: STOP, CGA: R, AGA: R, GGA: G,
    UGG: W,    CGG: R, AGG: R, GGG: G 
}.toTable

iterator codons(dna: string): Codon =
    var i = 0
    while i <= dna.len:
        let codonStr = dna[i..i+2]
        yield parseEnum[Codon](codonStr)
        i += 3

proc translate(codon: Codon): AminoAcid =
    translationTable[codon]

let fileName = paramStr(1)
let fileStream = newFileStream(fileName)
useStream(fileStream):
    let codonStr = readLine(fileStream)

    var aminoAcidStr = ""

    for c in codons(codonStr):
        let a = translate(c)
        if a == STOP:
            break
        aminoAcidStr.add($a)

    echo aminoAcidStr