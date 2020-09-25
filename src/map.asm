;
;
;
;
;                               Waterfall   <-->   Turnip farm  <-->  Ocean beach
;                                  ^                                     ^
;                                  |                                     |
;                                  v                                     v
;                               Clearing                               Woods
;                                                                        ^
;                                                                        |
;                                                                        v
;                                                Rocky outcrop <-->  Snowy plains
;
;
;

CLEARING:
    dw WATERFALL    ; north
    dw 0x0000       ; south
    dw 0x0000       ; east
    dw 0x0000       ; west
    db "You arrive in a clearing, a trail in the woods leads north towards what seems like a waterfall.", \
        " You can't remember how you got here, but it is autumn, and the scent of the coppered leaves remind you of", \
        " something... something you can't quite put your finger on.", 10, 13, 0

WATERFALL:
    dw 0x0000       ; north
    dw CLEARING     ; south
    dw FARM         ; east
    dw 0x0000       ; west
    db "You drown in a tsunami after the walls behind the waterfall collapse in such a dramatic fashion", \
        " that you'd rather have done this than not.", 13, 10, 10, \
        "Suddenly you are resurrected by an apparition, a ghostly squirrel who seems overly concerned about your", \
        " well-being. Looking around, you see that there is a well worn path to the east,", \
        " as well as the somewhat safer return to the south from wence those autumnal leaves are calling.", 13, 10, 0

FARM:
    dw 0x0000        ; north
    dw 0x0000        ; south
    dw BEACH         ; east
    dw WATERFALL     ; west
    db "You find yourself in a most peculiar turnip farm.", 13, 10, 10, \
       "Towards the east you see an enticing ocean lapping against a white, sandy beach.", 13, 10, 10, \
       "Reassuringly, the waterfall still lies to the west.", 13, 10, 0

BEACH:
    dw 0x0000        ; north
    dw WOODS         ; south
    dw 0x0000        ; east
    dw FARM          ; west
    db "You are at a very lovely beach. The sand is warm beneath your toes and a curious penguin is ", \
       " pecking your knee.", 13, 10, \
       "You can travel west back to the comfort of the turnip farm or take a rocky road south towards a clump of", 13, 10, \
       " trees that apparently bribed a cartographer into calling it a woods.", 13, 10, 0

WOODS:
    dw BEACH         ; north
    dw SNOWY_PLAINS  ; south
    dw 0x0000        ; east
    dw 0x0000        ; west
    db "You find yourself in a deep, dark wood. Noises around you cackle and crunch and you have the strangest", \
       " feeling that somebody... or someTHING... is watching you...", 13, 10, 10, \
       "You can escape north to the beach or travel south to a mysterious white shimmer on the horizon.", 13, 10, 0

SNOWY_PLAINS:
    dw WOODS         ; north
    dw 0x0000        ; south
    dw 0x0000        ; east
    dw ROCKY_OUTCROP ; west
    db "The crunching of fresh snow under your feet coupled with a chill in the air lets you know that you have", \
       " finally arrived what were distant snowy plains. As far as the eye can see the cold cotton blanket of winter coats the landscape, ", \
       "except for a cheeky rocky outcrop to the west.", 13, 10, 10, \
       "Far to the north are that sloth of trees that thinks it's a forest.", 13, 10, 0

ROCKY_OUTCROP:
    dw 0x000         ; north
    dw 0x0000        ; south
    dw SNOWY_PLAINS  ; east
    dw 0x000         ; west
    db "It is indeed fairly rocky here at the outcrop. Geological forces clearly formed this without consulting a single health and safety officer.", 13, 10, 10, \
       "You ponder the existence of an incrop while trying to remember how to retrace your steps to the east.", 13, 10, 0

