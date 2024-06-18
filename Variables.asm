; ===========================================================================
; RAM variables
; ===========================================================================

		include	"Data/Misc/SRAM Equates.asm"		; has to be included here because of forward referencing

; RAM variables - General
	phase	ramaddr($FFFF0000)					; Pretend we're in the RAM
dvHistory:								; memory of visual debugger history
RAM_Start:
Chunk_table:							ds.b $8000			; Chunk (128x128) definitions, $80 bytes per definition
Chunk_table_End

CreditsPlane = (Chunk_table_End-$2000)
CreditsSprite = (CreditsPlane-(((224/8)+1)*$20))
CreditsLetters = CreditsPlane

dxData:								ds.b $10; extra data for Fractal
dvTestScale:								; memory of visual debugger test scale
dvMemory:								; memory of visual debugger
Player_1:								; Main character in 1 player mode
v_player:
Object_RAM:							ds.b object_size
Reserved_object_2:						ds.b object_size
Reserved_object_3:					ds.b object_size			; During a level, an object whose sole purpose is to clear the collision response list is stored here
Dynamic_object_RAM:				ds.b object_size*90		; 90 objects
Dynamic_object_RAM_End
									ds.b object_size
v_Dust:								ds.b object_size
v_Shield:							ds.b object_size
v_Trail:								ds.b object_size
v_Breathing_bubbles:					ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
v_WaterWave:						ds.b object_size
v_FDZ3_Rain:						ds.b object_size
v_Invincibility_stars:					ds.b object_size*4		; 4 objects
									ds.b $34				; Null
Object_RAM_End

	; Special mapping RAM space where sprite mappings are copied over to
	; reduce overall number of pieces on-screen when rendering the
	; forground plant/chain/pillar objects.

OBJFGP_FAST	=	1						; MJ: if using faster method (0 = use more precise method)
OBJFGP_SLOTS	=	6						; MJ: number of slots allowed to show at once
OBJFGP_SIZE	=	$100						; MJ: size of mappings data per slot
Map_PlantFG:	ds.b	((OBJFGP_SLOTS*4)*2)+(OBJFGP_SLOTS*OBJFGP_SIZE)	; MJ: special mapping system for the FG plants

TempSaveRAM				ds.b	SR_SlotSize

Kos_decomp_buffer:					ds.w $800			; Each module in a KosM archive is decompressed here and then DMAed to VRAM
Kos_decomp_buffer_End
H_scroll_buffer:
v_hscrolltablebuffer:					ds.l 224				; Horizontal scroll table is built up here and then DMAed to VRAM
h_vscrolltablebuffer:					ds.w (224*2)-64				; MJ: Vertical scroll table for H-blank
v_deformtablebuffer:					ds.w 64				; offsets for background scroll positions, used by ApplyDeformation
H_scroll_buffer_End
Collision_response_list:				ds.b 128				; Collision response list
Pos_table:							ds.w 64*2			; Recorded player XY position buffer
Ring_status_table:					ds.w 512				; Ring status table(1 word). Maximum 512 rings
Ring_status_table_End
Object_respawn_table:					ds.b 768				; Object respawn table(1 byte). Maximum 768 objects
Object_respawn_table_End
Sprite_table_buffer:					ds.b 80*8
Sprite_table_buffer_End
Sprite_table_input:					ds.b $80*8			; Sprite table input buffer
Sprite_table_input_End
ExtraSpriteBuffer:						ds.b $200			; Data for extra sprites that need to be displayed. This data can be just anything, it is used by ExtraSprite routines.
ExtraSpriteBuffer_End

DMA_queue:
VDP_Command_Buffer:				ds.b $FC				; Stores all the VDP commands necessary to initiate a DMA transfer
DMA_queue_slot:
VDP_Command_Buffer_Slot:			ds.l 1				; Points to the next free slot on the queue

Camera_RAM:								; Various camera and scroll-related variables are stored here
H_scroll_amount:
CamXdiff				ds.w 1				; Number of pixels camera scrolled horizontally in the last frame * $100
V_scroll_amount:
CamYdiff				ds.w 1				; Number of pixels camera scrolled vertically in the last frame * $100
Camera_target_min_X_pos:
TargetBoundLeft				ds.w 1
Camera_target_max_X_pos:
TargetBoundRight			ds.w 1
Camera_target_min_Y_pos:
TargetBoundTop				ds.w 1
Camera_target_max_Y_pos:
TargetBoundBot				ds.w 1
Camera_min_X_pos:
BoundLeft				ds.w 1
Camera_max_X_pos:
BoundRight				ds.w 1
Camera_min_Y_pos:
BoundTop				ds.w 1
Camera_max_Y_pos:
BoundBot				ds.w 1
H_scroll_frame_offset:
CamLag					ds.w 1				; If this is non-zero with value x, horizontal scrolling will be based on the player's position x / $100 + 1 frames ago
CamXExtend				ds.l 1				; Camera X extension against P1 speed
CamYExtend				ds.l 1				; Camera Y extension against P1 speed
BkpCams					ds.l 8				; Copy of camera values to be used by plane updating part
BkpFlags				ds.l 2				; Copy of scroll flags used by plane updating part
Pos_table_index:			ds.b 1
Pos_table_byte:				ds.b 1
Distance_from_screen_top:
CamYoff					ds.w 1				; The vertical scroll manager scrolls the screen until the player's distance from the top of the screen is equal to this (or between this and this + $40 when in the air). $60 by default
CamPassMult				ds.w 4				; flags to determine whether a camera's axis has passed a $10 multiple (1 FG + 3 BG cameras)
CamXsclDelay				ds.w 1				; amount of delay to move the camera horizontally
ScrollFG								; flags to determine where to update the plane map
.u					ds.w 1
.d					ds.w 1
.l					ds.w 1
.r					ds.w 1
ScrollBG1								; ''
.u					ds.w 1
.d					ds.w 1
.l					ds.w 1
.r					ds.w 1
ScrollBG2								; ''
.u					ds.w 1
.d					ds.w 1
.l					ds.w 1
.r					ds.w 1
ScrollBG3								; ''
.u					ds.w 1
.d					ds.w 1
.l					ds.w 1
.r					ds.w 1
HScroll_Shift:
Camera_Hscroll_shift:			ds.w 3
FGHscroll_shift:				ds.w 3
Camera_X_Center:			ds.w 1
Camera_max_Y_pos_changing:
ScrollBGV				ds.b 1				; Set when the maximum camera Y pos is undergoing a change
Dynamic_resize_routine:			ds.b 1
Fast_V_scroll_flag:			ds.b 1				; If this is set vertical scroll when the player is on the ground and has a speed of less than $800 is capped at 24 pixels per frame instead of 6
Scroll_lock:
ScrollDisable				ds.b 1				; If this is set scrolling routines aren't called
v_screenposx:
Camera_X_pos:
CamXFG					ds.l 1
v_screenposy:
Camera_Y_Pos:
CamYFG					ds.l 1
NullCam					ds.l 2
CamXBG1
CamXBG					ds.l 1				; Camera X-position for BG ; cam #2
CamYBG1
CamYBG					ds.l 1				; Camera Y-position for BG
CamXBG2					ds.l 1				; Camera X-position for BG ; cam #3
CamYBG2					ds.l 1				; Camera Y-position for BG
CamXBG3					ds.l 1				; Camera X-position for BG ; cam #4
CamYBG3					ds.l 1				; Camera Y-position for BG
Camera_X_pos_copy:
CamXFGcopy				ds.l 1
Camera_Y_pos_copy:
CamYFGcopy				ds.l 1
Camera_X_pos_rounded:			ds.w 1				; rounded down to the nearest block boundary ($10th pixel)
Camera_Y_pos_rounded:			ds.w 1				; rounded down to the nearest block boundary ($10th pixel)
Camera_X_pos_BG_copy:			ds.l 1
Camera_Y_pos_BG_copy:			ds.l 1
Camera_X_pos_BG_rounded:		ds.w 1				; rounded down to the nearest block boundary ($10th pixel)
Camera_Y_pos_BG_rounded:		ds.w 1				; rounded down to the nearest block boundary ($10th pixel)
Camera_X_pos_coarse:
CamXFGcoarse				ds.w 1				; Rounded down to the nearest chunk boundary (128th pixel)
Camera_Y_pos_coarse:
CamYFGcoarse				ds.w 1				; Rounded down to the nearest chunk boundary (128th pixel)
Camera_X_pos_coarse_back:
CamXBGcoarse				ds.w 1				; Camera_X_pos_coarse - $80
Camera_Y_pos_coarse_back:
CamYBGcoarse				ds.w 1				; Camera_Y_pos_coarse - $80
Plane_double_update_flag:		ds.w 1				; Set when two block are to be updated instead of one (i.e. the camera's scrolled by more than $10 pixels)
Screen_X_wrap_value:
CamXwrap				ds.w 1				; Set to $FFFF
Screen_Y_wrap_value:
CamYwrap				ds.w 1				; Either $7FF or $FFF
Camera_Y_pos_mask:			ds.w 1				; Either $7F0 or $FF0
Layout_row_index_mask:			ds.w 1				; Either $3C or $7C
Plane_buffer_2_addr:			ds.l 1				; The address of the second plane buffer to process, if applicable
Screen_shaking_flag:			ds.l 1				; Activates screen shaking code (if existent) in layer deformation routine
Screen_shaking_sound:		ds.w 1
Water_trigger_save:			ds.w 1
Camera_RAM_End
ScreenWobble:				ds.b	1			; causes screen to wobble up and down and slowly diminish to 0
ScreenWobble_Angle:			ds.b	1

Ring_start_addr_ROM:			ds.l 1				; Address in the ring layout of the first ring whose X position is >= camera X position - 8
Ring_end_addr_ROM:			ds.l 1				; Address in the ring layout of the first ring whose X position is >= camera X position + 328
Ring_start_addr_RAM:			ds.w 1				; Address in the ring status table of the first ring whose X position is >= camera X position - 8
Ring_consumption_table:							; Stores the addresses of all rings currently being consumed
Ring_consumption_count:			ds.w 1				; The number of rings being consumed currently
Ring_consumption_list:			ds.b $7E			; The remaining part of the ring consumption table
Ring_consumption_table_End

	; to-do: optimize buffers, need to take less RAM
PlaneBuf				ds.b ($80*2*2)+2		; 16 higher bits of VDP commands array for Scroll Engine's VInt section + tail
VRAMBuf					ds.b $100*2*2*2			; Tilemap array for Scroll Engine's VInt section

dMemory:
v_snddriver_ram:			ds.b $C00			; Start of RAM for the sound driver data

v_gamemode:
Game_mode:				ds.b 1
V_int_routine:
v_vbla_routine:				ds.b 1

SonicControl:
Ctrl_1_logical:
v_jpadhold2:
Ctrl_1_held_logical:			ds.b 1
v_jpadpress2:
Ctrl_1_pressed_logical:			ds.b 1
Joypad:
Ctrl_1:
Ctrl_1_held:
Ctrl_1_hold:
v_jpadhold1:				ds.b 1
v_jpadpress1:
Ctrl_1_press:
Ctrl_1_pressed:				ds.b 1
Ctrl_2:
Ctrl_2_held:
Ctrl_2_hold:
v_jpad2hold1:				ds.b 1
v_jpad2press1:
Ctrl_2_press:
Ctrl_2_pressed:				ds.b 1
v_vdp_buffer1:
VDP_reg_1_command:			ds.w 1				; AND the lower byte by $BF and write to VDP control port to disable display, OR by $40 to enable
VDP_windows_save:			ds.w 1
VDP_windows_size:			ds.w 1
Demo_timer:
v_demolength:				ds.w 1				; The time left for a demo to start/run
V_scroll_value:								; Both foreground and background
v_scrposy_dup:
V_scroll_value_FG:			ds.w 1
V_scroll_value_BG:			ds.w 1
H_scroll_value:
v_scrposx_dup:
H_scroll_value_FG:			ds.w 1
H_scroll_value_BG:			ds.w 1
v_hbla_hreg:
H_int_counter_command:			ds.b 1				; Contains a command to write to VDP register $0A (line interrupt counter)
v_hbla_line:
H_int_counter:				ds.b 1				; Just the counter part of the command
Extra_VDP_Write:			ds.b 2				; NAT: Extra word to be written to VDP on certain screen modes
v_pfade_start:
Palette_fade_info:							; Both index and count
Palette_fade_index:			ds.b 1				; Colour to start fading from
v_pfade_size:
Palette_fade_count:			ds.b 1				; The number of colours to fade

ExtraSpriteRoutineFirst:		ds.l 1				; routine address for extra sprite stuff (before sprites)
ExtraSpriteRoutineLast:			ds.l 1				; routine address for extra sprite stuff (after sprites)
Lag_frame_count:			ds.w 1				; More specifically, the number of times V-int routine 0 has run. Reset at the end of a normal frame
v_random:
RNG_seed:				ds.l 1				; Used by the random number generator
f_pause:
Game_paused:				ds.b 1
PauseSlot:				ds.b 1				; pause menu slot
v_spritecount:
Sprites_drawn:				ds.w 1				; Used to ensure the sprite limit isn't exceeded
v_vdp_buffer2:
DMA_data_thunk:								; Used as a RAM holder for the final DMA command word. Data will NOT be preserved across V-INTs, so consider this space reserved
DMA_trigger_word:			ds.w 1				; Transferred from RAM to avoid crashing the Mega Drive
f_hbla_pal:
H_int_flag:				ds.w 1				; Unless this is set H-int will return immediately
WindTunnel_flag:			ds.b 1
f_lockctrl:
Ctrl_1_locked:				ds.b 1
v_framecount:
Level_frame_counter:			ds.b 1				; The number of frames which have elapsed since the level started
v_framebyte				ds.b 1
Rings_manager_routine:			ds.b 1				; Routine counter for the ring loading manager
Level_started_flag:			ds.b 1
f_restart:
Restart_level_flag:			ds.w 1
Sonic_Knux_top_speed:			ds.w 1
Sonic_Knux_acceleration:		ds.w 1
Sonic_Knux_deceleration:		ds.w 1
v_SonFrameNum:				ds.b 1
v_TailsTailFrameNum:			ds.b 1
Object_load_addr_front:			ds.l 1				; The address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse + $280
Object_load_addr_back:			ds.l 1				; The address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse - $80
Object_respawn_index_front:		ds.w 1				; The object respawn table index for the object at Obj_load_addr_front
Object_respawn_index_back:		ds.w 1				; The object respawn table index for the object at Obj_load_addr_back
Collision_addr:				ds.l 1				; Points to the primary or secondary collision data as appropriate
Primary_collision_addr:			ds.l 1
Secondary_collision_addr:		ds.l 1
GravityAngle:				ds.b 1				; represents angle of gravity. 00 is normal gravity, and floor detection is done every 40 degrees (offset by 20)
Primary_Angle:				ds.b 1
Secondary_Angle:			ds.b 1
Object_load_routine:			ds.b 1				; Routine counter for the object loading manager
Deform_Lock:				ds.b 1
Boss_flag:				ds.b 1				; Set if a boss fight is going on
Sonic_NoKill:				ds.b 1
Warper_Flag:				ds.b 1
Water_flag:				ds.b 1
TitleCard_end_flag:			ds.b 1
LevResults_end_flag:			ds.b 1
PauseHideDebug				ds.b 1				; for hiding the pause menu items if the debug buttons have been pressed
ScreenEvent_routine:			ds.w 1
BackgroundEvent_routine:
Background_event_routine:		ds.w 1
ScreenEvent_flag:			ds.b 1
BackgroundEvent_flag:			ds.b 1
DrawPlane_Position:			ds.w 1				; value that keeps track of the vertical or horizontal position of the DrawPlane routine
DrawPlane_Count:			ds.w 1				; value that keeps track of the number of rows or columns that are yet to be drawn
Debug_placement_mode:							; Both routine and type
Debug_placement_routine:		ds.b 1
Debug_placement_type:			ds.b 1				; 0 = normal gameplay, 1 = normal object placement, 2 = frame cycling
Debug_camera_delay:				ds.b 1
Debug_camera_speed:				ds.b 1
Debug_object:				ds.b 1				; The current position in the debug mode object list
Level_end_flag:				ds.b 1
LastAct_end_flag:			ds.b 1
NoBackgroundEvent_flag:			ds.b 1
Debug_mode_flag:			ds.w 1
DPLC_SlottedRAM
Slotted_object_bits:			ds.b 8
Signpost_addr:				ds.w 1
Hyper_Sonic_flash_timer:		ds.b 1
Black_Stretch_flag:			ds.b 1
PalCycle_Frame:				ds.w 1
PalCycle_Timer:				ds.w 1
PalCycle_Frame2:			ds.w 1
PalCycle_Timer2:			ds.w 1
PalCycle_Frame3:			ds.w 1
PalCycle_Timer3:			ds.w 1
Palette_refade_count:			ds.b 1
Negative_flash_timer:			ds.b 1
FDZ3Rain_Spawn:				ds.b 1				; if not 0, spawning FDZ3 rain works
MGZEmbers_Spawn:							; number of frames until embers can spawn. 0 means they can sapwn always.
FDZ3Rain_Process:			ds.b 1
Lava_Event:				ds.w 1
NoPause_flag:				ds.b 1
PalRotation_flag:			ds.b 1
PalRotation_pointer:			ds.l 1
PalRotation_buffer:			ds.b $22
Chain_bonus_counter:			ds.w 1
Time_bonus_countdown:			ds.w 1				; Used on the results screen
Ring_bonus_countdown:			ds.w 1				; Used on the results screen
Total_bonus_countup:			ds.w 1
Lag_frame_count_End

Water_level:								; Keeps fluctuating
Water_Level_1:				ds.w 1
Water_Level_2:
Mean_water_level:			ds.w 1				; The steady central value of the water level
Water_Level_3:
Target_water_level:			ds.w 1
Water_on:								; Is set based on Water_flag
Water_speed:				ds.b 1				; This is added to or subtracted from Mean_water_level every frame till it reaches Target_water_level
Water_routine:
Water_entered_counter:			ds.b 1				; Incremented when entering and exiting water, read by the the floating AIZ spike log, cleared on level initialisation and dynamic events of certain levels
Water_move:
Water_full_screen_flag:			ds.b 1				; Set if water covers the entire screen (i.e. the underwater pallete should be DMAed during V-int rather than the normal palette)
Water_hurt_delay			ds.b 1				; number of frames until Sonic will be hurt under water
					ds.b 1

ConsoleRegion =				*
Graphics_flags:				ds.b 1				; Bit 7 set = English system, bit 6 set = PAL system
Do_Updates_in_H_int:			ds.b 1				; If this is set Do_Updates will be called from H-int instead of V-int
Last_star_post_hit:
Last_star_pole_hit:			ds.b 1
Level_music:				ds.w 1
Palette_fade_timer:			ds.w 1				; The palette gets faded in until this timer expires

Block_table_addr_ROM:				ds.l 1				; Block table pointer(Block (16x16) definitions, 8 bytes per definition)
Layout
Level_layout_addr_ROM:				ds.l 1				; Level layout pointer
Level_layout2_addr_ROM:				ds.l 1				; Level layout 2 pointer
Object_index_addr:					ds.l 1				; Points to either the object index for levels

Level_data_addr_RAM:
.AnPal:								ds.l 1
.Resize:								ds.l 1
.WaterResize:							ds.l 1
.AfterBoss:							ds.l 1
.ScreenInit:							ds.l 1
.BackgroundInit:						ds.l 1
.ScreenEvent:							ds.l 1
.BackgroundEvent:					ds.l 1
.AnimateTiles:						ds.l 1
.AniPLC:								ds.l 1
Level_data_addr_RAM_End

Kos_decomp_queue_count:				ds.w 1					; The number of pieces of data on the queue. Sign bit set indicates a decompression is in progress
Kos_decomp_stored_registers:			ds.b $28					; Allows decompression to be spread over multiple frames
Kos_decomp_stored_SR:				ds.w 1
Kos_decomp_bookmark:				ds.l 1					; The address within the Kosinski queue processor at which processing is to be resumed
Kos_description_field:					ds.w 1					; Used by the Kosinski queue processor the same way the stack is used by the normal Kosinski decompression routine
Kos_decomp_queue:											; 2 longwords per entry, first is source location and second is decompression location
Kos_decomp_source:					ds.l 8					; The compressed data location for the first entry in the queue
Kos_decomp_destination:				= Kos_decomp_queue+4	; The decompression location for the first entry in the queue
Kos_decomp_queue_End
Kos_modules_left:						ds.w 1					; The number of modules left to decompresses. Sign bit set indicates a module is being decompressed/has been decompressed
Kos_last_module_size:					ds.w 1					; The uncompressed size of the last module in words. All other modules are $800 words
Kos_module_queue:					ds.b 6*PLCKosM_Count	; 6 bytes per entry, first longword is source location and next word is VRAM destination
Kos_module_source:					= Kos_module_queue		; The compressed data location for the first module in the queue
Kos_module_destination:				= Kos_module_queue+4	; The VRAM destination for the first module in the queue
Kos_module_queue_End

v_pal_water_dup:
Target_water_palette:											; Used by palette fading routines
Target_water_palette_line_1:			ds.w 16
Target_water_palette_line_2:			ds.w 16
Target_water_palette_line_3:			ds.w 16
Target_water_palette_line_4:			ds.w 16
v_pal_water:
Water_palette:												; This is what actually gets displayed
Water_palette_line_1:					ds.w 16
Water_palette_line_2:					ds.w 16
Water_palette_line_3:					ds.w 16
Water_palette_line_4:					ds.w 16
v_pal_dry:
Normal_palette:												; This is what actually gets displayed
Normal_palette_line_1:				ds.w 16
Normal_palette_line_2:				ds.w 16
Normal_palette_line_3:				ds.w 16
Normal_palette_line_4:				ds.w 16
v_pal_dry_dup:
Target_palette:												; Used by palette fading routines
Target_palette_line_1:					ds.w 16
Target_palette_line_2:					ds.w 16
Target_palette_line_3:					ds.w 16
Target_palette_line_4:					ds.w 16

Pal_BlendAmount				ds.w 1				; blend amount (QQFF - 0000 to 0100)

v_vbla_count:
V_int_run_count:			ds.w 1				; The number of times V-int has run
v_vbla_word:				ds.b 1
v_vbla_byte:				ds.b 1
v_zone:
Current_zone:
Current_zone_and_act:			ds.b 1
v_act:
Current_act:				ds.b 1
Transition_Zone:			ds.b 1				; NAT: Used for various things, such as level music object
Transition_Act:				ds.b 1
TSecrets_count:						ds.b 1
MSecrets_count:						ds.b 1

v_timehr:							= *
Timer:								= *
Timer_hour:							ds.b 1
v_timemin:							= *
Timer_minute:						ds.b 1
v_timesec:							= *
Timer_second:						ds.b 1
v_timecent:							= *
Timer_frame:						= *
Timer_centisecond:					ds.b 1					; The second gets incremented when this reaches 60
f_timeover:							= *
Time_over_flag:						ds.b 1
f_ringcount:							= *
Update_HUD_ring_count:				ds.b 1
f_timecount:							= *
Update_HUD_timer:					ds.b 1
Extended_mode:						ds.b 1
Death_count:							ds.w 1
v_hp:
v_rings:
Ring_count:				ds.b 1
v_prevhp:				ds.b 1
HP_Ani_Frames:				ds.b 5
HP_Ani_Timers:				ds.b 5
HUD_Xvel:				ds.w 1				; x-velocity of HUD
HUD_Xpos:				ds.l 1				; x-position of HUD onscreen
HUD_State =				*-1				; if set to 0, HUD is not visible, -1 is HUD exiting the screen, 1 or more is HUD entering and staying on screen
DecimalScoreRAM:			ds.l 1
DecimalScoreRAM2:			ds.l 1

Saved_Camera_min_X_pos:			ds.w 1
Saved_Camera_max_X_pos:			ds.w 1
Saved_Camera_min_Y_pos:			ds.w 1
Saved_camera_max_Y_pos:			ds.w 1
Saved_zone_and_act:			ds.w 1
Saved_X_pos:				ds.w 1
Saved_Y_pos:				ds.w 1
Saved_ring_count:			ds.w 1
Saved_timer:				ds.l 1
Saved_mappings:				ds.l 1
Saved_art_tile:				ds.w 1
Saved_solid_bits:			ds.w 1				; Copy of Player 1's top_solid_bit and lrb_solid_bit
Saved_camera_X_pos:			ds.w 1
Saved_camera_Y_pos:			ds.w 1
Saved_mean_water_level:			ds.w 1
Saved_water_full_screen_flag:		ds.b 1
Saved_dynamic_resize_routine:		ds.b 1
Saved_status_secondary:			ds.b 1
Saved_last_star_post_hit:		ds.b 1
Saved_GravityAngle:			ds.b 1
Saved_status:				ds.b 1

v_oscillate:					= *
Oscillating_variables:			= *
Oscillating_Numbers:			= *
Oscillation_Control:			ds.w 1
Oscillating_Data:				ds.b $40
Level_trigger_array:			ds.b $10			; Used by buttons, etc
Anim_Counters:				ds.b $10			; Each word stores data on animated level art, including duration and current frame
Vine_Acceleration:			ds.w 1
v_oscillate_end

Rings_frame_timer:			ds.b 1
Rings_frame:				ds.b 1
Ring_spill_anim_counter:		ds.b 1
Ring_spill_anim_frame:			ds.b 1
Ring_spill_anim_accum:			ds.w 1

Check_dead:				ds.w 1
Check_skipTS:				ds.w 1
Check_IntroCleared:			ds.w 1
Check_CreditsCleared:			ds.w 1
Check_GluttonyDead:			ds.w 1
Lust_Cutscene:				ds.w 1
Gloamglozer_Cutscene:			ds.w 1
Firebrand_InterlPassed:			ds.w 1
VilliansMeetingPassed:			ds.w 1
SCZ1_Cutscene:				ds.w 1
SCZ2_WaterLevel:				ds.w 1
Lust_Dead:				ds.w 1
CutsceneTimer:				ds.w 1
Can_Shoot:				ds.w 1
Chesire_Appeared:			ds.w 1
Skull_Invulnerability:			ds.w 1
Enlarged_InstaShield:			ds.w 1
Spirit_Shield:				ds.w 1
Grounder_Alive:				ds.w 1
Sonic_Dead:				ds.w 1
EvilEye_Event:				ds.w 1
EvilEye_StonesDeleted:			ds.w 1
InvPalRet:				ds.w 1
AstarothCompleted:			ds.w 1
MidBoss_Flag:				ds.w 1
Seizure_Flag:				ds.w 1
Difficulty_Flag:			ds.w 1
ExtendedCam_Flag:			ds.w 1
HeartDeleteFlag:			ds.w 1
HeadlissIsFeal:				ds.w 1
Scythes_Throwed:			ds.w 1
Hand_Squeezes_Player:		ds.w 1
DialogueAlreadyShown:		ds.w 1
EvilEye_GravityEvent:				ds.w 1
Secrets_buffer:				ds.b 2*4*4			; 2 secrets * 4 act * 4 zone (32 bytes)
Secrets_buffer_end

Pos_objTable_Start
Pos_objTable_index:			ds.b 1
Pos_objTable_byte:			ds.b 1
Pos_objTable:				ds.b $100			; Recorded position buffer
Pos_objTable_End

Sprite_Link:				ds.w 1				; MJ: link ID storage location
Sprite_Size:				ds.w 1				; MJ: size of table to transfer

Previous_zone				ds.w 1				; zone from previous play
FirstRun				ds.b 1				; if the level has been played before (after a death)
BadEmulator				ds.b 1				; if the emulator is bad
YouDiedY				ds.b 1				; Y position of the "You Died" sprites
ForceMuteYM2612				ds.b 1				; if the YM2612 is meant to force mute
SupportSRAM				ds.b 1				; if SRAM is supported
FirstSRAM				ds.b 1				; if this is the first time SRAM is ran

CreditsData
CreditsBoundPos				ds.w 1				; boundary position to go to
CreditsBoundary				ds.b 1				; boundary counter/flag
CreditsMessage				ds.b 1				; message/credits text to show
CreditsLine				ds.b 1				; line rendering flag
CreditsRead				ds.b 1				; reading mappings from plane to 68k RAM
CreditsLine_Amount			ds.w 1				; line rendering position
CreditsRoutine				ds.l 1				; routine to run for credits text
CreditsText_Ready			ds.b 1				; if the text sprites can be displayed
CreditsHold				ds.b 1				; hold timer before moving sprites off again
CreditsMonCount				ds.b 1				; monitor count (total number of monitors destroyed)
CreditsLastMSG				ds.b 1				; last message shown
CreditsDelayMSG				ds.b 1				; message ID to play after the current message is shown (for the "find all monitors" message)
CreditsFinalText			ds.b 1				; signifies to load uncompressed small and large text for the final credits roll
CreditsString				ds.l 1				; string pointer to credits roll text
CreditsMapText				ds.b 1				; if there's a line of credits mappings ready to be transferred
CreditsMapDouble			ds.b 1				; if there's a double line and the text needs repeating twice
CreditsLastVScroll			ds.w 1				; last V-scroll position of written text to detect once it's fully scrolled
CreditsFinish				ds.b 1				; set credits to finish
CreditsFadeTimer			ds.b 1				; fade timer for end of credits
CreditsTailsX				ds.l 1				; X position of tails
CreditsTailsXCam			ds.w 1				; camera X disposition
CreditsData_End


SwapPlanes				ds.b 1				; if the planes should swap
SwapVScroll				ds.b 1				; if V-scroll should be swapped
SwapHScroll				ds.b 1				; if H-scroll should be swapped
					ds.b 1	; even

System_stack_size			ds.b $100			; ~$100 bytes ; this is the top of the stack, it grows downwards($FEF0-$FFF0)
System_stack:
V_int_jump:					ds.w 1				; 6 bytes ; contains an instruction to jump to the V-int handler
V_int_addr:					ds.l 1
H_int_jump:					ds.w 1				; 6 bytes ; contains an instruction to jump to the H-int handler
H_int_addr:					ds.l 1
Checksum_string:				ds.l 1				; set to 'INIT' once the checksum routine has run

R_WordPad				ds.w	1			; padding so the "movep.l" can be used without affecting the previous register
R_VDP97					ds.w	1			; D654 3210 - DMA Fill Source (D = Fill mode)
R_VDP96					ds.w	1			; FEDC BA98 - ''
R_VDP95					ds.w	1			; 7654 3210 - ''
R_VDP94					ds.w	1			; FEDC BA98 - DMA Fill Size (FFFF bytes)
R_VDP93					ds.w	1			; 7654 3210 - ''
R_WordDMA				ds.w	1			; last destination word RAM (due to bug on older hardware)

CentipedePosTable			ds.b 4*$60		; stores previous boss positions for the segments to use ; is only used for this boss, so it can be repurposed for other uses in other parts of the game
	if * > 0		; Don't declare more space than the RAM can contain!
		fatal "The RAM variable declarations are too large by $\{*} bytes."
	endif
	if MOMPASS=1
		message "The current RAM available $\{0-*} bytes."
	endif

	dephase			; Stop pretending

	phase	0
CreShape	ds.b	1	; if FF, end of SST		; current shape for the master sprite which will expand
CreShow		ds.b	1					; if the sprite should be hidden
CrePosX		ds.w	1					; current X position
CrePosY		ds.w	1					; current Y position
CreDestX	ds.w	1					; destination X
CreDestY	ds.w	1					; destination Y
CreTimer	ds.w	1					; timer before sprite is meant to move in/out
CrePattern	ds.w	1					; pattern index address of letter to show
CreSlot		ds.w	1					; pointer to a master slot (the sprite which will expand which this letter will merge to)
CreCount	ds.b	1					; the sprite count away from the master
		ds.b	1	; even
CreSize
	dephase

	dephase			; this is somehow needed? Thanks, AS!
	!org	0		; Reset the program counter

; ===========================================================================
; ---------------------------------------------------------------------------
; dxData declarations
; ---------------------------------------------------------------------------

dxFlags			EQU dxData				; flags for commands
dxbUnderwater		EQU 7					; set if underwater mode fade is active
dxbUnderwaterOn		EQU 6					; set if underwater mode is active
dxbUnderwaterCmd	EQU 5					; set if underwater command was played
dxbShoes		EQU 3					; set if speed shoes fade is active
dxbShoesOn		EQU 4					; set if speed shoes is active
dxbRingSpeaker		EQU 0					; active ring speaker

dxShoesIndex		EQU dxData+1				; index of the speed shoes data
dxShoesTempo		EQU dxData+2				; speed shoes tempo value
dxFadeOff		EQU dxData+4				; offset for volume fade
dxFadeVol		EQU dxData+6				; fade volume offset
dxWaterTempo		EQU dxData+8				; underwater tempo offset
dxWaterFrac		EQU dxData+$A				; underwater fraction offset
dxWaterVol		EQU dxData+$C				; underwater volume offset
dxWaterVolPSG		EQU dxData+$D				; underwater volume offset (PSG)
dxWaterIndex		EQU dxData+$E				; index of the underwater fade
dxWaterVibIx		EQU dxData+$F				; index to the vibrato table
