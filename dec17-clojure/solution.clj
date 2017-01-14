(ns solution)

(use '[clojure.string :only (split-lines)])

(defn count-exactp
  "counts the number of exact packing combinations"
  [sizes volume]
  (if (seq sizes)
    (+ (count-exactp (rest sizes) (- volume (first sizes)))
       (count-exactp (rest sizes) volume))
    (if (zero? volume) 1 0)))

(defn enum-exactp
  "enumerates all exact packing combinations"
  [sizes volume]
  (if (seq sizes)
    (let [h (first sizes)
          t (rest sizes)
          p1 (map (partial cons h) (enum-exactp t (- volume h)))
          p2 (enum-exactp t volume)]
      (remove nil? (concat p1 p2)))
    (if (zero? volume) [[]] nil)))


(defn count-min
  "counts the number of minimum size exact packing combinations,
   returns [min-number min-size]"
  [sizes volume]
  (let [comb (sort-by count (enum-exactp sizes volume))
        min-size (count (first comb))
        min-number (count (take-while #(= min-size (count %)) comb))]
    [min-number min-size]))


(defn solve [sizes volume]
  (let [ncomb (count-exactp sizes volume)
        [nmin minsize] (count-min sizes volume)]
    (print "Volume" volume "has" ncomb "full combinations and"
           nmin "minimal combinations of size" minsize "\n")))


(defn -main [& args]
  (let [fname (nth args 0 "input.txt")
        volume (read-string (nth args 1 "150"))
        lines (clojure.string/split-lines (slurp fname))
        sizes (map read-string lines)]
    (solve sizes volume)))
