/*******************TEMPLATES******************/

/***********************************************
 * any three squares sq1,sq2,sq3 that form a 
 * straight line in any order
 ***********************************************/
(deftemplate line 
    (slot sq1) 
    (slot sq2) 
    (slot sq3)
)

/***********************************************
 * for each occupied square, where p is either
 * X or O
 ***********************************************/
(deftemplate occupied 
    (slot square)	
    (slot player)
)

/*******************FACTS**********************/

/***********************************************
 * representation of the board with all the lines 
 * and special squares
 ***********************************************/
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

/******************FUNCTIONS********************/

/***********************************************
 * function to place a piece on the board in
 * square location with piece piectoplay
 ***********************************************/
(deffunction place-piece (?location ?piecetoplay)
    (assert (occupied (square ?location) (player ?piecetoplay)))
)

/***********************************************
 * Set the current state to swap for swapping players
 ***********************************************/
(deffunction swap(?currentstate)
    (retract ?currentstate)
    (assert(state "swap"))
)

/*******************RULES**********************/

/***********************************************
 * When we are in swap state and active player is  
 * X, then we make the active player O
 ***********************************************/
(defrule swapPlayerX
    (declare (salience 50)) ; if we are trying to swap player, we must do this first
    ?swapping <- (state "swap") ; Check we are trying to swap player 
    ?player <- (currentplayer "X") ; are we player X
    => 
    	(retract ?player) ; This is no longer the current player  
    	(assert (currentplayer "O")) ; Nought is now the current player
    	(retract ?swapping) ; We are done swapping
    	(assert (state "playing")) ; Go back in to main play state
)

/***********************************************
 * When we are in swap state and active player is  
 * O, then we make the active player X
 ***********************************************/
(defrule swapPlayerO
    (declare (salience 50)) ; if we are trying to swap player, we must do this first
    ?swapping <- (state "swap") ; Check we are trying to swap player
    ?player <- (currentplayer "O") ; are we player O
    =>  
    	(retract ?player) ; This is no longer the current player  
    	(assert (currentplayer "X")) ; Cross is now the current player
    	(retract ?swapping) ; We are done swapping
    	(assert (state "playing")) ; Go back in to main play state
)    

/* ****************************************
 Rule 1 : choose a square to get 3 in a row 
 *****************************************/
(defrule one
    (declare (salience 7))	; This is the highest priority rule
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z)) ; Find a line in the board
    (currentplayer ?piece) ; Get the current playing piece 
    
    (occupied (square ?x) (player ?playedpiece&:(eq ?playedpiece ?piece))) ; Is the first square occupied by the current player
    (occupied (square ?y) (player ?playedpiece&:(eq ?playedpiece ?piece))) ; And the second square occupied by the current player
    (not(occupied (square ?z))) ; but the last square empty
     =>
         (assert (occupied (square ?z) (player ?piece))) ; This square is now occupied by the current player
    	 (retract ?playing) ; This a winning move so we are done
    	 (assert (state "ended"))
)

/* ***************************************
 Rule 2: choose a square which would give them 3 in a row
 *****************************************/
(defrule two 
    (declare (salience 6)) ; This is the second rule to execute so 2nd highest priority
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (currentplayer ?piece) ; Get the current playing piece 
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z)) ; Find a line in the board
    (occupied (square ?x) (player ?playedpiece&:(neq ?piece ?playedpiece))) ; Check the first square is occupied by the other player
    (occupied (square ?y) (player ?playedpiece&:(neq ?piece ?playedpiece))) ; And the second square
    (not(occupied (square ?z))) ; But the last square is empty
     =>
         (place-piece ?z ?piece) ; Place the current players piece in the empty square     
    	 (swap ?playing) ; We are now swapping players
)

/* ***************************************
 Rule 3: choose a square that gives you a double row 
 *****************************************/
(defrule three 
    (declare (salience 5))
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (currentplayer ?piece) ; Get the current playing piece 
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z) ) ; Find a line
    (line (sq1 ?a&:(eq ?a ~?x)) (sq2 ?b&:(eq ?b ~?y)) (sq3 ?z) ) ; Find a different line that shares a square with the first line
    
    (occupied (square ?x) (player ?playedpiece&:(eq ?piece ?playedpiece))) ; We want one end of the first line to be occupied 
    (occupied (square ?a) (player ?playedpiece&:(eq ?piece ?playedpiece))) ; And one end of the other line to be occupied
    (not (occupied (square ?y))) ; The other squares need to be not occupied 
    (not (occupied (square ?b)))
    (not (occupied (square ?z)))
    => 
	     (place-piece ?z ?piece) ; Place the current players piece in the crucial square
	     (swap ?playing) ; We are now swapping players
)
/*****************************************
 Rule 4 : choose a square that would give them a double row 
 *****************************************/
(defrule four 
    (declare (salience 4))
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (currentplayer ?piece) ; Get the current playing piece 
    (line (sq1 ?x) (sq2 ?y) (sq3 ?z) ) ; Find a line
    (line (sq1 ?a&:(eq ?a ~?x)) (sq2 ?b&:(eq ?b ~?y)) (sq3 ?z) ) ;Find a different line that shares a square with the first line
    
    (occupied (square ?x) (player ?playedpiece&:(neq ?piece ?playedpiece))) ; We want one end of the first line to be occupied 
    (occupied (square ?a) (player ?playedpiece&:(neq ?piece ?playedpiece))) ; And one end of the other line to be occupied
    (not (occupied (square ?y))) ; The other squares need to be not occupied 
    (not (occupied (square ?b)))
    (not (occupied (square ?z)))
    => 
	     (place-piece ?z ?piece) ; Place the current players piece in the crucial square
	     (swap ?playing) ; We are now swapping players
)

/*****************************************
 Rule 5 : choose centre square
 *****************************************/
(defrule centre-piece 
    (declare (salience 3))
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (currentplayer ?piece) ; Get the current playing piece 
    (centre ?x) ; Get the centre square
    (not (occupied (square ?x))); Check the centre square is unoccupied
    => 
	    (place-piece ?x ?piece) ; Place the current players piece in the middle
		(swap ?playing) ; We are now swapping players
)

/*****************************************
 Rule 6: choose corner square
 *****************************************/
(defrule place-corner
    (declare (salience 2))
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (currentplayer ?piece) ; Get the current playing piece 
    (corner ?x) ; Get a corner square
    (not (occupied (square ?x))) ; Check the corner square is not occupied
    =>
	    (place-piece ?x ?piece) ; Place the current players piece in the corner square
    	(swap ?playing) ; We are now swapping players
)

/*****************************************
 Rule 7 : choose another square
 *****************************************/
(defrule seven 
    (declare (salience 1))
    ?playing <- (state "playing") ; Check we are looking to play a rule
    (currentplayer ?piece) ; Get the current playing piece 
    (square ?x) ; Find a square 
    (not (occupied (square ?x))) ; Check the square is not occupied
    => 
   		(place-piece ?x ?piece) ; Place the current players piece in the square
    	(swap ?playing) ; We are now swapping players
)

/*****************************************
 * If a player has won, "occupy" the 
 * remaining squares with dashes so the
 * board gets drawn by rule checkend
 *****************************************/
(defrule fillinblanks
   	(state "ended") ; The game has ended (eg someone won)
    (square ?x) ; Find a square
    (not (occupied (square ?x))) ; If that square is unoccupied 
    =>
 		(assert (occupied (square ?x) (player "-"))) ; "Occupy" it with a dash   	
)

/*****************************************
 * Check to see if the board is full, if so
 * print it out
 *****************************************/
(defrule checkended
    (occupied (player ?1) (square 1)) ; All the squares occupied
    (occupied (player ?2) (square 2))
    (occupied (player ?3) (square 3))
    (occupied (player ?4) (square 4))
    (occupied (player ?5) (square 5))
    (occupied (player ?6) (square 6))
    (occupied (player ?7) (square 7))
    (occupied (player ?8) (square 8))
    (occupied (player ?9) (square 9))
    =>
    	(printout t ?1 ?2 ?3 crlf ?4 ?5 ?6 crlf ?7 ?8 ?9 crlf) ; Print out the board
)

(reset)

(assert (state "playing"))
(assert (currentplayer "X"))

(run)
