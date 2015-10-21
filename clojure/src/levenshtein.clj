(ns levenshtein
  (:require
    [clojure.java.io :as io]
    [clojure.math.combinatorics :as comb]))

(defn dist []
  "An implementation of the Levenshtein distance.
   The Levenshtein distance represents the number
   of letters to be changed, added or removed to
   turn one word into the other.

   This function works like a factory for Levenshtein
   functions, each one having its own memo cache.
   This way the recursive call is fast, and the
   cache does not explode when using the Levenshtein
   over and over again."
  (with-local-vars
    [lev (memoize (fn [x y]
              (cond
                (empty? x) (count y)
                (empty? y) (count x)
                :else
                  (let [a (rest x)
                        b (rest y)
                        diff (if (= (first x) (first y)) 0 1)]
                       (min
                         (inc (lev a y))
                         (inc (lev b x))
                         (+ (lev a b) diff))))))]
     (.bindRoot lev @lev)
     @lev))

(defn read-words [path]
  (with-open [rdr (io/reader path)]
    (vec (line-seq rdr))))

(defn all-pairs [coll]
  (when-let [s (next coll)]
    (lazy-cat (for [y s] [(first coll) y])
              (all-pairs s))))

(defn -main
  [& args]
    (let [
      words (read-words "../words1000.txt")
      n (count words)
      pairs (comb/combinations words 2)
      levs (map (fn [[a b]] ((dist) a b)) pairs)
      total (reduce + 0 levs)
      levs-length (/ (* n (- n 1)) 2)
      average (/ total levs-length)]
        (println (first pairs))
        ; (println (last pairs))
        ; (println (last pairs))
        (println average)
    ))