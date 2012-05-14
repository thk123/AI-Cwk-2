;(watch all)
(deftemplate line 
    (slot sq1) 
    (slot sq2) 
    (slot sq3))

(deftemplate occupied 
    (slot square)	
    (slot player)
    )

;(defglobal ?*player* = "O")

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


/*(deffunction swapplayer()
    if(eq ?*player* "X") then (
        bind ?*player* "O")
    else (bind ?*player* "X")
    
    (printout t "Choosing player: " ?*player* crlf)
)*/

(deffunction place-piece (?location ?piecetoplay)
    (assert (occupied (square ?location) (player ?piecetoplay)))
    ;(swapplayer)
    (assert (state "swap"))
)

/*(deffunction not-player ()
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
)*/

(defrule swapPlayerX
    (declare (salience 50))
    ?swapping <- (state "swap")
    ?player <- (currentplayer "X")
    =>
	(printout t "Swapping player from X to O" crlf)  
    (retract ?player)  
    (assert (currentplayer "O"))
    (retract ?swapping)
    (assert (state "playing")))

(defrule swapPlayerO
    (declare (salience 50))
    ?swapping <- (state "swap")
    ?player <- (currentplayer "O")
    =>
	(printout t "Swapping player from O to X" crlf)  
    (retract ?player)  
    (assert (currentplayer "X"))
    (retract ?swapping)
    (assert (state "playing")))
    

/* ****************************************
 Rule 1 : choose a square to get 3 in a row 
 *****************************************/
(defrule one
    (declare (salience 7))	
    ?playing <- (state "playing")
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z))
    (currentplayer ?piece)
    ;(occupied (square ?x) (player ?*player*))
    ;(occupied (square ?y) (player ?*player*))
    (occupied (square ?x) (player ?playedpiece&:(eq ?playedpiece ?piece)));?*player*
    (occupied (square ?y) (player ?playedpiece&:(eq ?playedpiece ?piece)))
    (not(occupied (square ?z)))
     =>
    	 (facts)
    	 (printout t "rule one: " ?z  ?*player* crlf)
         (assert (occupied (square ?z) (player ?piece)))
    	 (retract ?playing)
    	 (assert (state "ended"))
    	 (facts)
)

/* ***************************************
 Rule 2: choose a square which would give them 3 in a row
 *****************************************/
(defrule two 
    (declare (salience 6))
    ?playing <- (state "playing")
    (currentplayer ?piece)
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z))
    (occupied (square ?x) (player ?playedpiece&:(neq ?piece ?playedpiece)))
    (occupied (square ?y) (player ?playedpiece&:(neq ?piece ?playedpiece)))
    (not(occupied (square ?z)))
     =>
    	 (printout t "rule two: " ?z crlf)
         (place-piece ?z ?piece)       
    	 (retract ?playing)
		 (assert (state "swap"))
)
/* ***************************************
 Rule 3: choose a square that gives you a double row 
 *****************************************/
(defrule three 
    (declare (salience 5))
    ?playing <- (state "playing")
    (currentplayer ?piece)
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z) ) ;Find a line
    (line (sq1 ?a&:(eq ?a ~?x)) (sq2 ?b&:(eq ?b ~?y)) (sq3 ?z) ) ;Find a different line that shares a square with the first line
    
    (occupied (square ?x) (player ?playedpiece&:(eq ?piece ?playedpiece))) ; We want one end of the first line to be occupied 
    (occupied (square ?a) (player ?playedpiece&:(eq ?piece ?playedpiece))) ; And one end of the other line to be occupied
    (not (occupied (square ?y))) ; The other squares need to be not occupied 
    (not (occupied (square ?b)))
    (not (occupied (square ?z)))
    => 
	     (printout t "three: " ?z ?piece crlf)
	     (place-piece ?z ?piece)
	     (retract ?playing)
		 (assert (state "swap"))
    	
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
    (currentplayer ?piece)
    (centre ?x)
    (not (occupied (square ?x)))
    =>
    	    (printout t "five" ?x ?piece crlf) 
	    (place-piece ?x ?piece)

)

/* ***************************************
 Rule 6: choose corner square
 *****************************************/

(defrule place-corner
    (declare (salience 2))
    ?playing <- (state "playing")
    (currentplayer ?piece)
    (corner ?x)
    (not (occupied (square ?x)))
    =>
	    (printout t "Take corner: " ?x ?piece ?playing crlf)
	    (place-piece ?x ?piece)
)

/* ***************************************
 Rule 7 : choose another square
 *****************************************/

(defrule seven 
    (declare (salience 1))
    ?playing <- (state "playing")
    (currentplayer ?piece)
    (square ?x)
    (not (occupied (square ?x)))
    => 
    (printout t "random square: " ?x crlf)
    (place-piece ?x ?piece)
)

/*(defrule swap-player
    (declare (salience -1143245423))
    (not(state "playing"))
    =>
    (
        if(eq* ?*player* "X") then (bind ?*player* "O")
    	else (bind ?*player* "X")
    )
    (assert(state "playing"))
    (printout t "CURRENT PLAYER IS " ?*player* crlf)
    
)*/

(defrule checkended
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
    	(printout t ?1 ?2 ?3 crlf ?4 ?5 ?6 crlf ?7 ?8 ?9 crlf)
)

(reset)
(assert (state "playing"))
(assert (currentplayer "X"))

;(assert (occupied (square 1) (player "O")))
;(assert (occupied (square 2) (player "O")))
(agenda)
(run)
