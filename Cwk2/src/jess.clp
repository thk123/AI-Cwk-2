;(watch all)
(deftemplate line 
    (slot sq1) 
    (slot sq2) 
    (slot sq3))

(deftemplate occupied 
    (slot square)	
    (slot player)
    )

(defglobal ?*player* = "X")

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

(assert (state "playing"))

(deffunction place-piece (?location ?playing)
    (assert (occupied (square ?location) (player ?*player*)))
    (retract ?playing)
)

(deffunction not-player ()
    (
    	if(eq ?*player* "X") then 
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
    ?playing <- (state "playing")
    (eq 1 1)
     =>
         (printout t "one" crlf)
)

(defrule two 
    ?playing <- (state "playing")
    (equals 1 7)
    => 
)
(defrule three 
    ?playing <- (state "playing")
    (equals 1 0) 
    => 
    (printout t "three" crlf)
)
(defrule four 
    ?playing <- (state "playing")
    (eq 1 1) 
    => 
    (printout t "four" crlf)
)

/* ***************************************
 Rule for choosing centre by rule 5 
 *****************************************/

(defrule centre-piece 
    ?playing <- (state "playing")
    (not (occupied (square 5)))
    => 
    (place-piece 5 ?playing)
    (printout t "five" crlf)
)

/* ***************************************
 Rules for choosing corner by rule 6 
 *****************************************/

(defrule top-left-free
    ?playing <- (state "playing")
    (not (occupied (square 1)))
    =>
    (printout t "Take top left" crlf)
    (place-piece 1 ?playing)
    (printout t "Top left chosen")
    )

(defrule top-right-free
    ?playing <- (state "playing")
    (not (occupied (square 3)))
    =>
    (printout t "Take top right" crlf)
    (place-piece 3 ?playing)
    )

(defrule bottom-left-free
    ?playing <- (state "playing")
    (not (occupied (square 7)))
    =>
    (printout t "Take bottom left" crlf)
    (place-piece 7 ?playing)
    )

(defrule bottom-right-free
    ?playing <- (state "playing")
    (not (occupied (square 9)))
    =>
    (printout t "Take bottom right" crlf)
    (place-piece 9 ?playing)
    )

/*End of rule 6 */

(defrule seven 
    ?playing <- (state "playing")
    (eq 1 1) 
    => 
    (printout t "seven" crlf)
)

(defrule swap-player
    (not(state "playing"))
    =>
    (
        if(eq ?*player* "X") then ?*player* <- "O"
    	else ?*player* <- "X"
    )
    (assert(state "playing"))
    (printout t "CURRENT PLAYER IS " ?*player* crlf)
    
)

(reset)
;(agenda)
(run)
