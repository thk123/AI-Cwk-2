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

(deffacts board
    (line (sq1 1) (sq2 3) (sq3 2))
    (line (sq1 1) (sq2 2) (sq3 3))
    (line (sq1 2) (sq2 3) (sq3 1))
    (line (sq1 2) (sq2 1) (sq3 3))
    (line (sq1 3) (sq2 2) (sq3 1))
    (line (sq1 3) (sq2 1) (sq3 2))
    
    (line (sq1 4) (sq2 5) (sq3 6))
    (line (sq1 4) (sq2 6) (sq3 5))
    (line (sq1 5) (sq2 4) (sq3 6))
    (line (sq1 5) (sq2 6) (sq3 4))
    (line (sq1 6) (sq2 5) (sq3 4))
    (line (sq1 6) (sq2 4) (sq3 5))
    
    (line (sq1 7) (sq2 8) (sq3 9))
    (line (sq1 7) (sq2 9) (sq3 8))
    (line (sq1 8) (sq2 7) (sq3 9))
    (line (sq1 8) (sq2 9) (sq3 7))
    (line (sq1 9) (sq2 8) (sq3 7))
    (line (sq1 9) (sq2 7) (sq3 8))
    
    (line (sq1 1) (sq2 4) (sq3 7))
    (line (sq1 1) (sq2 7) (sq3 4))
    (line (sq1 4) (sq2 1) (sq3 7))
    (line (sq1 4) (sq2 7) (sq3 1))
    (line (sq1 7) (sq2 4) (sq3 1))
    (line (sq1 7) (sq2 1) (sq3 4))
    
    (line (sq1 2) (sq2 5) (sq3 8))
    (line (sq1 2) (sq2 8) (sq3 5))
    (line (sq1 5) (sq2 2) (sq3 8))
    (line (sq1 5) (sq2 8) (sq3 2))
    (line (sq1 8) (sq2 5) (sq3 2))
    (line (sq1 8) (sq2 2) (sq3 5))
    
    (line (sq1 3) (sq2 6) (sq3 9))
    (line (sq1 3) (sq2 9) (sq3 6))
    (line (sq1 6) (sq2 3) (sq3 9))
    (line (sq1 6) (sq2 9) (sq3 3))
    (line (sq1 9) (sq2 6) (sq3 3))
    (line (sq1 9) (sq2 3) (sq3 6))
    
    (line (sq1 1) (sq2 5) (sq3 9))
    (line (sq1 1) (sq2 9) (sq3 5))
    (line (sq1 5) (sq2 1) (sq3 9))
    (line (sq1 5) (sq2 9) (sq3 1))
    (line (sq1 9) (sq2 5) (sq3 1))
    (line (sq1 9) (sq2 1) (sq3 5))
    
    (line (sq1 3) (sq2 5) (sq3 7))
    (line (sq1 3) (sq2 7) (sq3 5))
    (line (sq1 5) (sq2 3) (sq3 7))
    (line (sq1 5) (sq2 7) (sq3 3))
    (line (sq1 7) (sq2 3) (sq3 5))
    (line (sq1 7) (sq2 5) (sq3 3))
    
    (centre 5)
    
    (corner 1)
    (corner 3)
    (corner 7)
    (corner 9)
    
    (square 1)
    (square 2)
    (square 3)
    (square 4)
    (square 5)
    (square 6)
    (square 7)
    (square 8)
    (square 9)
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

/* ***************************************
 Rule 1 : choose a square to get 3 in a row 
 *****************************************/
(defrule one
    (declare (salience 7))
    ?playing <- (state "playing")
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z))
    (occupied (square ?x) (player ?*player*))
    (occupied (square ?y) (player ?*player*))
    (not(occupied (square ?z)))
     =>
         (place-piece ?z ?playing)
         (printout t "rule one: " ?z crlf)
    	 (retract ?playing)
    	 (assert (state "ended"))
)

/* ***************************************
 Rule 2: choose a square which would give them 3 in a row
 *****************************************/
(defrule two 
    (declare (salience 6))
    
    ?playing <- (state "playing")
    
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z))
    
    (occupied (square ?x) (player ?player&:(eq ?player ~?*player*)))
    
    (occupied (square ?y) (player ?player&:(eq ?player ~?*player*)))
    
    (not(occupied (square ?z)))
    
     =>
         (place-piece ?z ?playing)
         (printout t "rule two: " ?z crlf) 
)
/* ***************************************
 Rule 3: choose a square that gives you a double row 
 *****************************************/
(defrule three 
    (declare (salience 5))
    ?playing <- (state "playing")
    (equals 1 0) 
    => 
    	(printout t "three" crlf)
)
/* ***************************************
 Rule 4 : choose a square that would give them a double row 
 *****************************************/
(defrule four 
    (declare (salience 4))
    ?playing <- (state "playing")
    (eq 1 1) 
    => 
    	(printout t "four" crlf)
)

/* ***************************************
 Rule 5 : choose centre square
 *****************************************/

(defrule centre-piece 
    (declare (salience 3))
    ?playing <- (state "playing")
    (centre ?x)
    (not (occupied (square ?x)))
    => 
	    (place-piece ?x ?playing)
	    (printout t "five" crlf)
)

/* ***************************************
 Rule 6: choose corner square
 *****************************************/

(defrule place-corner
    (declare (salience 2))
    ?playing <- (state "playing")
    (corner ?x)
    (not (occupied (square ?x)))
    =>
	    (printout t "Take corner: " ?x crlf)
	    (place-piece ?x ?playing)
)

/* ***************************************
 Rule 7 : choose another square
 *****************************************/

(defrule seven 
    (declare (salience 1))
    ?playing <- (state "playing")
    (square ?x)
    (not (occupied (square ?x)))
    => 
    (printout t "random square: " ?x crlf)
    (place-piece ?x ?playing)
)

(defrule swap-player
    (not(state "playing"))
    =>
    (
        if(eq* ?*player* "X") then (bind ?*player* "O")
    	else (bind ?*player* "X")
    )
    (assert(state "playing"))
    (printout t "CURRENT PLAYER IS " ?*player* crlf)
    
)

(defrule checkended
    ?state <- (state ~"playing")
    (occupied (player ?1) (square 1))
    (occupied (player ?2) (square 2))
    (occupied (player ?3) (square 3))
    (occupied (player ?4) (square 4))
    (occupied (player ?5) (square 5))
    (occupied (player ?6) (square 6))
    (occupied (player ?7) (square 7))
    (occupied (player ?8) (square 8))
    (occupied (player ?9) (square 9))
    =>
    	(retract ?state)
    	(printout t ?1 ?2 ?3 crlf ?4 ?5 ?6 crlf ?7 ?8 ?9 crlf)
)

(reset)
(agenda)
(run)
