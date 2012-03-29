(watch all)
(deftemplate line 
    (slot sq1) 
    (slot sq2) 
    (slot sq3))

(deftemplate occupied 
    (slot square)	
    (slot player)
    )


(deffacts inital-fact
    (turn "X"))

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

(deffunction not-player ()
    (
    	if(eq turn "X") then 
        (
        	return "O"
        )
        else
        (
            return "X"
        )    
    )
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
    (not( occupied (square ?x &: (or (eq ?x 3) (eq ?x 1) (eq ?x 7) (eq ?x 9)))))
    ;(not (occupied (square ?x &: )) ) 
    => 
    (printout t "There is a corner square free" crlf)
)

/* ***************************************
 Rules for choosing corner by rule 6 
 *****************************************/

(defrule top-left-free
    (not (occupied (square 1)))
    =>
    (printout t "Take top left")
    )

(defrule top-right-free
    (not (occupied (square 3)))
    =>
    (printout t "Take top left")
    )

(defrule bottom-left-free
    (not (occupied (square 7)))
    =>
    (printout t "Take top left")
    )

(defrule bottom-right-free
    (not (occupied (square 9)))
    =>
    (printout t "Take top left")
    )

/*End of rule 6 */

(defrule seven 
    (eq 1 1) 
    => 
    (printout t "two" crlf)
)

(reset)
(run)
