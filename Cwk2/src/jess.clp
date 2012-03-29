(watch all)
(deftemplate line 
    (slot sq1) 
    (slot sq2) 
    (slot sq3))
(deftemplate occupied 
    (slot square)	
    (slot player)
    )

(deffacts lines
    (line (sq1 1) (sq2 2) (sq3 3))
    (line (sq1 4) (sq2 5) (sq3 6))
    (line (sq1 7) (sq2 8) (sq3 9))
    (line (sq1 1) (sq2 4) (sq3 7))
    (line (sq1 2) (sq2 5) (sq3 8))
    (line (sq1 3) (sq2 6) (sq3 9))
    (line (sq1 1) (sq2 5) (sq3 9))
    (line (sq1 3) (sq2 5) (sq3 7))
)

(deffacts oneline
    (occupied (square 1) (player "X"))
	(occupied (square 2) (player "X"))
	;(occupied (square 3) (player "X"))
    )

(defrule one
    (line (sq1 ?sq1) (sq2 ?sq1) (sq3 ?sq3))
    (occupied {square != ?sq3})
     =>
         (printout t "one" crlf)
)

;(deffunction twoAdjacent (line))

(defrule two 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)
(defrule three 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)
(defrule four 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)
(defrule five 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)
(defrule six 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)
(defrule seven 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)

(reset)
(run)
