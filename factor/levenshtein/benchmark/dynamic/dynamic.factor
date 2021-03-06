! Copyright (C) 2015 Andrea Ferretti.
! See http://factorcode.org/license.txt for BSD license.
USING: io.encodings.ascii io.files kernel lcs math
  math.combinatorics sequences tools.time ;
IN: levenshtein.dynamic.benchmark

: total-levenshtein-distance ( seq -- total )
  2 <combinations> [ first2 levenshtein ] map-sum ;

: number-of-pairs ( seq -- n )
  length dup 1 - * 2 / ;

: avg-levenshtein-distance ( seq -- avg )
  [ total-levenshtein-distance >float ] [ number-of-pairs >float ] bi / ; inline

: levenshtein-benchmark ( file -- avg )
  ascii file-lines [ avg-levenshtein-distance ] time ; inline