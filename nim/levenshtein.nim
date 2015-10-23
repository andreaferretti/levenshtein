import streams, times, memo

proc readWords(path: string): seq[string] =
  result = @[]
  var
    input = newFileStream(path, fmRead)
    s = ""
  defer:
    input.close()
  while readLine(input, s):
    result.add(s)

iterator couples[A](xs: seq[A]): auto =
  for i in 0 .. < xs.len:
    for j in (i + 1) .. < xs.len:
      yield (xs[i], xs[j])

template tail(s: string): string = s[1 .. s.high]

template head(s: string): char = s[0]

proc lev(t: tuple[a, b: string]): int {.memoized.} =
  let (a, b) = t
  if a.len == 0: return b.len
  if b.len == 0: return a.len
  let
    d1 = lev((a.tail, b)) + 1
    d2 = lev((a, b.tail)) + 1
    d3 = lev((a.tail, b.tail)) + (if a.head == b.head: 0 else: 1)
  return min(min(d1, d2), d3)

proc levenshtein(a, b: string): int =
  resetCache(lev)
  lev((a, b))

when isMainModule:
  let
    words = readWords("../words1000.txt")
    numCouples = words.len * (words.len - 1) / 2
  var total = 0'i64
  let start = epochTime()
  for a, b in couples(words):
    total += levenshtein(a, b)
  let time = ((epochTime() - start) * 1000).int
  echo "The average Levenshtein distance is ", total.float / numCouples.float
  echo "The time to compute this was ", time, " ms"