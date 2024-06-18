Ani_MechaSonic:
                dc.w byte_MechaSonicStand-Ani_MechaSonic        ;0
                dc.w byte_MechaSonicFold-Ani_MechaSonic         ;1
                dc.w byte_MechaSonicDash-Ani_MechaSonic         ;2
                dc.w byte_MechaSonicRoll-Ani_MechaSonic         ;3
                dc.w byte_MechaSonicUnfold-Ani_MechaSonic       ;4
                dc.w byte_MechaSonicFall-Ani_MechaSonic         ;5
                dc.w byte_MechaSonicFly-Ani_MechaSonic          ;6
                dc.w byte_MechaSonicCast-Ani_MechaSonic         ;7
                dc.w byte_MechaSonicTransform-Ani_MechaSonic    ;8
                dc.w byte_MechaSonicDeath-Ani_MechaSonic        ;9
                dc.w byte_MechaSonicBurningSkull-Ani_MechaSonic ;A
                dc.w byte_MechaSonicRespawning-Ani_MechaSonic   ;B
                dc.w byte_MechaSonicFlyIdle-Ani_MechaSonic      ;C
                dc.w byte_MechaSonicFoldInAir-Ani_MechaSonic    ;D
                dc.w byte_MechaSonicUnfoldInAir-Ani_MechaSonic  ;E
byte_MechaSonicStand:           dc.b 0, 0, $FF, 0
byte_MechaSonicFold:            dc.b 3, 0, 1, 2, $FD, 3
byte_MechaSonicDash:            dc.b 3, 0, 1, 2, $FE, 1, 0
byte_MechaSonicRoll:            dc.b 2, 3, 4, 5, $FF, 0
byte_MechaSonicUnfold:          dc.b 3, 2, 1, $FD, 0
byte_MechaSonicFall:            dc.b 3, 6, 7, $11, 8, $FE, 1, 0
byte_MechaSonicFly:             dc.b 1, 9, $A, $FF, 0
byte_MechaSonicCast:            dc.b 2, 6, 7, 0, $B, $FE, 1, 0
byte_MechaSonicTransform:       dc.b 0, $C, $FF, 0
byte_MechaSonicDeath:           dc.b 4, 1, $D, $E, $FE, 1, 0
byte_MechaSonicBurningSkull:    dc.b 3, 4, 5, 6, $FF, 0
byte_MechaSonicRespawning:      dc.b 2, $E, $F, $10, $FF, 0
byte_MechaSonicFlyIdle:         dc.b 1, $11, $12, $FF, 0
byte_MechaSonicFoldInAir:       dc.b 2, 7, 6, $FD, 3
byte_MechaSonicUnfoldInAir:     dc.b 2, 6, 7, $11, $FD, $C
                even