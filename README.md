Levenshtein
===========

This is a little benchmark about computing Levenshtein distances in various
programming languages.

The task
--------

The Levenshtein distance (or edit distance) of two words `s` and `t` is the
minimum number of modifications needed to turn `s` into `t`. Valid modifications
include:

* adding a character;
* removing a character;
* changing a character into a different one.

For instance the Levenshtein distance between `house` and `home` is two.

It can be computed as follows. Let `s1` be the tail of `s` and `t1` that of `t`.
Compute the three numbers `d(s, t1) + 1`, `d(s1, t) + 1` and `d(s1, t1) + x`
where `x` is 0 if `s` and `t` start with the same character, and 1 otherwise.

Then `d(s, t)` is the minimum of these three numbers. Unless, of course, either
`s` or `t` is empty, in which case the distance is just the length of the other
word.

The task amounts to compute all pairwise distances between distinct words in
the file `words1000.txt` and report the average distance. The expected result
is 8.570003708668546. The timing shall not include reading the file itself.

Dynamic programming
-------------------

A simple way to do this is to compute a matrix where the entry `A[i][j]` is
the distance between the last `i` characters of `s` and the last `j` of `t`.
This can be computed incrementally, and the bottom-right entry is the desired
result.

This is fast, but not very interesting. We still include entries for dynamic
programming computations, but just as a baseline.

Memoization
-----------

The more interesting task is to compute these distances by the recursive
definition given above. The reason why this is interesting is that it is a
good way to test the meta-programming capabilities of your programming
language.

You see, implementing the recursion naively will require a looong time. One can
do better by memoizing the function.

Now, memoization already requires that functions are first-class entities. But
memoization of *recursive* functions is subtler, because the self-calls will,
in most implementations, still refer to the non-memoized function.

One way to overcome this requires that your language either has macros or
can otherwise alter the AST of the function at runtime.

This is enough if one wants to call the Levenshtein function once. But we are
going to call it about half a million times. If one just does memoization along
the way - thereby filling a hashtable of precomputed values - the cache is
going to become very big, and things will slow down to a crawl. Hence, we need
something more: the ability to clear the cache of the memoization between one
call and the other.

So, in a sense, the task is more about seeing whether this is even possible in
various programming languages, and secondarily testing the run time. It is
expected that this will be orders of magnitude slower than dynamic programming,
because of the extra function calls, and also because locating entries in an
array is faster than a hashmap.

But the memoization style is more interesting, because it stresses closures,
hashtables, and possibly reflection.