Z80_Space			 EQU 0x2000
SAFE_MODE			 EQU 0x1
FEATURE_SOUNDTEST		 EQU VISUAL_DEBUG
FEATURE_STACK_DEPTH		 EQU 0x4
FEATURE_QUEUE_SIZE		 EQU 0x4
FEATURE_BACKUP			 EQU 0x0
FEATURE_REDKIDFIX		 EQU 0x1
dZ80				 EQU 0xA00000
dPSG				 EQU 0xC00011
MaxPitch			 EQU 0x1000
Z80E_Read			 EQU 0x18
ctbPt2				 EQU 0x2
ctFM1				 EQU 0x0
ctFM2				 EQU 0x1
ctFM3				 EQU 0x2
ctFM4				 EQU 0x4
ctFM5				 EQU 0x5
ctFM6				 EQU 0x6
ctbFM3sm			 EQU 0x3
ctFM3op1			 EQU 0x8
ctFM3op3			 EQU 0x9
ctFM3op2			 EQU 0xA
ctFM3op4			 EQU 0xB
ctbDAC				 EQU 0x4
ctDAC1				 EQU 0x13
ctDAC2				 EQU 0x16
ctbSPC				 EQU 0x6
ctTA				 EQU 0x40
ctPSG1				 EQU 0x80
ctPSG2				 EQU 0xA0
ctPSG3				 EQU 0xC0
ctPSG4				 EQU 0xE0
cltFM1				 EQU 0x0
cltFM2				 EQU 0x4
cltFM4				 EQU 0x8
cltFM5				 EQU 0xC
cltFM6				 EQU 0x10
cltFM3				 EQU 0x14
cltFM3o1			 EQU 0x14
cltFM3o2			 EQU 0x18
cltFM3o3			 EQU 0x1C
cltFM3o4			 EQU 0x20
cltTA				 EQU 0x24
cltDAC1				 EQU 0x28
cltDAC2				 EQU 0x2C
cltPSG1				 EQU 0x30
cltPSG2				 EQU 0x34
cltPSG3				 EQU 0x38
cltPSG4				 EQU 0x3C
cltEnd				 EQU 0x3C
stType				 EQU 0x0
stVoices			 EQU 0x0
stPriority			 EQU 0x4
stSamples			 EQU 0x4
stFlags				 EQU 0x8
stVibrato			 EQU 0x8
stEnvelope			 EQU 0xC
stChanSFX			 EQU 0x10
stTempo				 EQU 0x10
stTempoPAL			 EQU 0x12
stChannels			 EQU 0x14
stfNoMasterFreq			 EQU 0x0
stfNoMasterVol			 EQU 0x1
stfNoUW				 EQU 0x2
stfFM3				 EQU 0x3
stfBackup			 EQU 0x4
stfCont				 EQU 0x5
vtDisp				 EQU 0x0
vtShape				 EQU 0x2
vtMultiply			 EQU 0x4
vtDelay				 EQU 0x6
vtStep				 EQU 0x7
vtSize				 EQU 0x8
stFreq				 EQU 0x0
stStart				 EQU 0x2
stStartRev			 EQU 0x5
stLoop				 EQU 0x8
stLoopRev			 EQU 0xB
stRest				 EQU 0xE
stRestRev			 EQU 0x11
stRestLoop			 EQU 0x14
stRestLoopRev			 EQU 0x17
stDebug				 EQU 0x1A
stSize				 EQU 0x20
vvDebug				 EQU 0x0
vvAMSFMS			 EQU 0x2
vvAlgoFeedback			 EQU 0x3
vvDetMul			 EQU 0x4
vvRSAR				 EQU 0x8
vvAMD1R				 EQU 0xC
vvD2R				 EQU 0x10
vvD1LRR				 EQU 0x14
vvSSGEG				 EQU 0x18
vvTL				 EQU 0x1C
vvSize				 EQU 0x20
ciAddr				 EQU 0x0
ciMirror			 EQU 0x2
ciPanning			 EQU 0x6
ciNext				 EQU 0x8
ciFreqReg			 EQU 0xA
ciSendFreq			 EQU 0xA
ciVolumeReg			 EQU 0xE
ciSendVolume			 EQU 0xE
ciFreqData			 EQU 0x12
ciVolData			 EQU 0x14
ciType				 EQU 0x16
ciTable				 EQU 0x16
ciExtraRout			 EQU 0x1A
ciFirstDelay			 EQU 0x1E
ciMute				 EQU 0x1E
ciUnmuteReg			 EQU 0x22
ciUnmute			 EQU 0x22
ciPause				 EQU 0x26
ciTranspose			 EQU 0x2A
ciKeyOff			 EQU 0x2A
ciRegOffs			 EQU 0x2E
ciKeyOn				 EQU 0x2E
ciString			 EQU 0x32
ciVoiceData			 EQU 0x36
ciVoice				 EQU 0x36
ciPanReg			 EQU 0x3A
ciLoadPan			 EQU 0x3A
ciRestore			 EQU 0x3E
ciEnd				 EQU 0x42
ciPart				 EQU 0x42
ciVoiceRegs			 EQU 0x42
ciD1LReg			 EQU 0x46
ciVoiceOff			 EQU 0x47
ciKeyBit			 EQU 0x48
cdFlags				 EQU 0x0
cdEnvId				 EQU 0x1
cdEnvDelay			 EQU 0x2
cdEnvLastDelay			 EQU 0x3
cdEnvPos			 EQU 0x4
cdVibId				 EQU 0x6
cdVibDelay			 EQU 0x7
cdVibPos			 EQU 0x8
cdVolSize			 EQU 0xA
cPortaTarget			 EQU 0xA
cPortaDisp			 EQU 0xC
cdFracSize			 EQU 0xE
cdfPorta			 EQU 0x0
cdfDelay			 EQU 0x1
cdfVibrato			 EQU 0x7
cTrackFlags			 EQU 0x0
cAddr				 EQU cTrackFlags+0x0
cNoiseMode			 EQU cAddr+0x4
cOpMask				 EQU cNoiseMode+0x0
cLFO				 EQU cOpMask+0x1
cDelay				 EQU cLFO+0x1
cLastDelay			 EQU cDelay+0x1
cVoice				 EQU cLastDelay+0x1
cVolume				 EQU cVoice+0x1
	if FEATURE_SOUNDTEST
cChipVol			 EQU cVolume+0x1
cChipFrac			 EQU cChipVol+0x2
cChipFreq			 EQU cChipFrac+0x2
cCallStack			 EQU cChipFreq+0x2
	else
cCallStack			 EQU cVolume+1
	endif
cModeFlags			 EQU cCallStack+0x1
cStack				 EQU cModeFlags+0x1
cStackEnd			 EQU cStack+(FEATURE_STACK_DEPTH*4)
cNote				 EQU cStackEnd+0x0
cFrac				 EQU cNote+0x2
cQuot				 EQU cFrac+0x1
cSizeFull			 EQU cQuot+0x1
cPriority			 EQU cSizeFull+0x0
cSongTable			 EQU cPriority+0x0
cSoundID			 EQU cSongTable+0x4
cSizeSFX			 EQU cSoundID+0x2
cfVolume			 EQU 0x0
cfFreq				 EQU 0x1
cfCut				 EQU 0x2
cfTie				 EQU 0x3
cfRest				 EQU 0x4
cfRun				 EQU 0x7
cfNoMasterFreq			 EQU 0x0
cfNoMasterVol			 EQU 0x1
cfBlockUW			 EQU 0x2
cfUnderwater			 EQU 0x3
cfCont				 EQU 0x4
cfMuted				 EQU 0x5
mfPause				 EQU 0x0
mfSpecial			 EQU 0x3
mfBackup			 EQU 0x4
mfUnderwater			 EQU 0x5
mfExec				 EQU 0x6
	if SAFE_MODE
mErrorRoutine			 EQU dMemory+0x0
mTiming				 EQU mErrorRoutine+0x4
	else
mTiming			 EQU dMemory
	endif
mPanSFX				 EQU mTiming+0x7
mQueue				 EQU mPanSFX+0x5
mSpecKeysOff			 EQU mQueue+(FEATURE_QUEUE_SIZE*2)
mLastCue			 EQU mSpecKeysOff+0x1
mSpindash			 EQU mLastCue+0x1
mFilter				 EQU mSpindash+0x1
mMasterVol			 EQU mFilter+0x1
mMasterVolPSG			 EQU mMasterVol+0x2
mMasterTempo			 EQU mMasterVolPSG+0x2
mSFXFM1				 EQU mMasterTempo+0x2
mVolSFXFM1			 EQU mSFXFM1+(cSizeSFX)
mFreqSFXFM1			 EQU mVolSFXFM1+(cdVolSize)
mSFXFM2				 EQU mFreqSFXFM1+(cdFracSize)
mVolSFXFM2			 EQU mSFXFM2+(cSizeSFX)
mFreqSFXFM2			 EQU mVolSFXFM2+(cdVolSize)
mSFXFM4				 EQU mFreqSFXFM2+(cdFracSize)
mVolSFXFM4			 EQU mSFXFM4+(cSizeSFX)
mFreqSFXFM4			 EQU mVolSFXFM4+(cdVolSize)
mSFXFM5				 EQU mFreqSFXFM4+(cdFracSize)
mVolSFXFM5			 EQU mSFXFM5+(cSizeSFX)
mFreqSFXFM5			 EQU mVolSFXFM5+(cdVolSize)
mSFXDAC2			 EQU mFreqSFXFM5+(cdFracSize)
mVolSFXDAC2			 EQU mSFXDAC2+(cSizeSFX)
mFreqSFXDAC2			 EQU mVolSFXDAC2+(cdVolSize)
mSFXPSG1			 EQU mFreqSFXDAC2+(cdFracSize)
mVolSFXPSG1			 EQU mSFXPSG1+(cSizeSFX)
mFreqSFXPSG1			 EQU mVolSFXPSG1+(cdVolSize)
mSFXPSG2			 EQU mFreqSFXPSG1+(cdFracSize)
mVolSFXPSG2			 EQU mSFXPSG2+(cSizeSFX)
mFreqSFXPSG2			 EQU mVolSFXPSG2+(cdVolSize)
mSFXPSG3			 EQU mFreqSFXPSG2+(cdFracSize)
mVolSFXPSG3			 EQU mSFXPSG3+(cSizeSFX)
mFreqSFXPSG3			 EQU mVolSFXPSG3+(cdVolSize)
mSFXPSG4			 EQU mFreqSFXPSG3+(cdFracSize)
mVolSFXPSG4			 EQU mSFXPSG4+(cSizeSFX)
mBackupStart			 EQU mVolSFXPSG4+(cdVolSize)
mTempoSong			 EQU mBackupStart+0x0
mTempoCur			 EQU mTempoSong+0x2
mTempoAcc			 EQU mTempoCur+0x2
mFlags				 EQU mTempoAcc+0x2
mModeFM3			 EQU mFlags+0x1
mSpecKeysOn			 EQU mModeFM3+0x1
mPanning			 EQU mSpecKeysOn+0x1
mRegLFO				 EQU mPanning+0x7
mSongTable			 EQU mRegLFO+0x2
mFM1				 EQU mSongTable+0x4
mVolFM1				 EQU mFM1+(cSizeFull)
mFreqFM1			 EQU mVolFM1+(cdVolSize)
mFM2				 EQU mFreqFM1+(cdFracSize)
mVolFM2				 EQU mFM2+(cSizeFull)
mFreqFM2			 EQU mVolFM2+(cdVolSize)
mFM4				 EQU mFreqFM2+(cdFracSize)
mVolFM4				 EQU mFM4+(cSizeFull)
mFreqFM4			 EQU mVolFM4+(cdVolSize)
mFM5				 EQU mFreqFM4+(cdFracSize)
mVolFM5				 EQU mFM5+(cSizeFull)
mFreqFM5			 EQU mVolFM5+(cdVolSize)
mFM6				 EQU mFreqFM5+(cdFracSize)
mVolFM6				 EQU mFM6+(cSizeFull)
mFreqFM6			 EQU mVolFM6+(cdVolSize)
mFM3o1				 EQU mFreqFM6+(cdFracSize)
mVolFM3o1			 EQU mFM3o1+(cSizeFull)
mFreqFM3o1			 EQU mVolFM3o1+(cdVolSize)
mFM3o2				 EQU mFreqFM3o1+(cdFracSize)
mVolFM3o2			 EQU mFM3o2+(cSizeFull)
mFreqFM3o2			 EQU mVolFM3o2+(cdVolSize)
mFM3o3				 EQU mFreqFM3o2+(cdFracSize)
mVolFM3o3			 EQU mFM3o3+(cSizeFull)
mFreqFM3o3			 EQU mVolFM3o3+(cdVolSize)
mFM3o4				 EQU mFreqFM3o3+(cdFracSize)
mVolFM3o4			 EQU mFM3o4+(cSizeFull)
mFreqFM3o4			 EQU mVolFM3o4+(cdVolSize)
mTA				 EQU mFreqFM3o4+(cdFracSize)
mFreqTA				 EQU mTA+(cSizeFull)
mDAC1				 EQU mFreqTA+(cdFracSize)
mVolDAC1			 EQU mDAC1+(cSizeFull)
mFreqDAC1			 EQU mVolDAC1+(cdVolSize)
mDAC2				 EQU mFreqDAC1+(cdFracSize)
mVolDAC2			 EQU mDAC2+(cSizeFull)
mFreqDAC2			 EQU mVolDAC2+(cdVolSize)
mPSG1				 EQU mFreqDAC2+(cdFracSize)
mVolPSG1			 EQU mPSG1+(cSizeFull)
mFreqPSG1			 EQU mVolPSG1+(cdVolSize)
mPSG2				 EQU mFreqPSG1+(cdFracSize)
mVolPSG2			 EQU mPSG2+(cSizeFull)
mFreqPSG2			 EQU mVolPSG2+(cdVolSize)
mPSG3				 EQU mFreqPSG2+(cdFracSize)
mVolPSG3			 EQU mPSG3+(cSizeFull)
mFreqPSG3			 EQU mVolPSG3+(cdVolSize)
mPSG4				 EQU mFreqPSG3+(cdFracSize)
mVolPSG4			 EQU mPSG4+(cSizeFull)
mBackupEnd			 EQU mVolPSG4+(cdVolSize)
mErrorChannel			 EQU mBackupEnd+(0)
mDynamic			 EQU mErrorChannel+(0)
mOverwriteTL			 EQU mDynamic+(0)
mErrorExtra			 EQU mOverwriteTL+0x4
mEnableDAC			 EQU mErrorExtra+0x0
mAddrDAC			 EQU mEnableDAC+0x0
mFreqDAC			 EQU mAddrDAC+0x4
mBackupData			 EQU mFreqDAC+0x2
	if FEATURE_BACKUP
mEnd				 EQU mBackupData+(mBackupEnd-mBackupStart)
	else
mEnd			 EQU mBackupData
	endif
mMasterFrac			 EQU mPSG4+cFrac
mSpecMask			 EQU mFM3o1+cOpMask
mSpecXor			 EQU mFM3o2+cOpMask
com_First			 EQU 0xD9
com_Frac			 EQU 0xD9
com_Vol				 EQU 0xDA
com_Tempo			 EQU 0xDB
com_VolEnv			 EQU 0xDC
com_FreqEnv			 EQU 0xDD
com_VolVibSet			 EQU 0xDE
com_VolVibOn			 EQU 0xDF
com_VolVibOff			 EQU 0xE0
com_FreqVibSet			 EQU 0xE1
com_FreqVibOn			 EQU 0xE2
com_FreqVibOff			 EQU 0xE3
com_PortaSpeed			 EQU 0xE4
com_PortaTarget			 EQU 0xE5
com_FastCut			 EQU 0xE6
com_LFO				 EQU 0xE7
com_Pan				 EQU 0xE8
com_AMSFMS			 EQU 0xE9
com_OpMask			 EQU 0xEA
com_YMW				 EQU 0xEB
com_SetTLA			 EQU 0xEC
com_SetTLB			 EQU 0xED
com_Queue			 EQU 0xEE
com_Tie				 EQU 0xEF
com_Hold			 EQU 0xEF
com_Voice			 EQU 0xF0
com_Backup			 EQU 0xF1
com_Stop			 EQU 0xF2
com_Ret				 EQU 0xF3
com_Jump			 EQU 0xF4
com_Call			 EQU 0xF5
com_Cont			 EQU 0xF6
com_CondJump			 EQU 0xF7
com_BitJump			 EQU 0xF8
com_CommSet			 EQU 0xF9
com_CommAdd			 EQU 0xFA
com_Flags			 EQU 0xFB
com_SpinRev			 EQU 0xFC
com_SpinReset			 EQU 0xFD
com_Last			 EQU 0xFD
sTie				 EQU 0xEF
sHold				 EQU 0xEF
evcom_First			 EQU 0x80
evcom_ReadFull			 EQU 0x80
evcom_ReadUpper			 EQU 0x82
evcom_ReadLower			 EQU 0x84
evcom_Delay			 EQU 0x86
evcom_Hold			 EQU 0x88
evcom_Mute			 EQU 0x8A
evcom_Exit			 EQU 0x8C
evcom_Jump			 EQU 0x8E
evcom_Last			 EQU 0x8E
evShortByte_First		 EQU 0x0
evShortByte_Last		 EQU 0x7F
evShortByte_Offs		 EQU 0x3F
evShortNote_First		 EQU 0xA0
evShortNote_Last		 EQU 0xFF
evShortBNote_Offs		 EQU 0xCE
meCueFail			 EQU 0x0
meInvalidQueue			 EQU 0x4
meTrackFail			 EQU 0x8
meChannelInvalid		 EQU 0xC
meVoicesTA			 EQU 0x10
meVoicesPSG			 EQU 0x14
meOutOfRangeNoteTA		 EQU 0x18
meOutOfRangeNotePSG		 EQU 0x1C
meOutOfRangeNoteDAC		 EQU 0x20
meOutOfRangeNoteFM		 EQU 0x24
meInvalidFilter			 EQU 0x28
meInvalidSample			 EQU 0x2C
meInvalidVoice			 EQU 0x30
meInvalidVibratoShape		 EQU 0x34
meInvalidDelay			 EQU 0x38
meInvalidCallStack		 EQU 0x3C
meInvalidCommand		 EQU 0x40
meFastCut			 EQU 0x44
meLFO				 EQU 0x48
meAMSFMS			 EQU 0x4C
meOpMask			 EQU 0x50
meTLAB				 EQU 0x54
meYM				 EQU 0x58
meCont				 EQU 0x5C
meMax				 EQU 0x5C
	if VISUAL_DEBUG
dvPlaneW			 EQU 0xD000
dvPlaneA			 EQU 0xC000
dvPlaneB			 EQU 0xE000
dvSprites			 EQU 0xF400
dvScroll			 EQU 0xF000
dvtGray				 EQU 0x0
dvtGold				 EQU 0x2000
dvtWhit				 EQU 0x4000
dvtGren				 EQU 0x6000
dvtRedd				 EQU 0x100
dvtAaac				 EQU 0x2100
dvtAaaa				 EQU 0x4100
dvtAaab				 EQU 0x6100
dvGraphTile			 EQU 0x80
dvGraphHeight			 EQU 0x14
dvGraphY			 EQU 0x3
dvGraphHistSz			 EQU 0x140
dvGraphHis2Sz			 EQU 0x50
dvPianoSpSize			 EQU 0x90
dvRawPadHold			 EQU dvMemory+0x0
dvRawPadPress			 EQU dvRawPadHold+0x2
dvPadHold			 EQU dvRawPadPress+0x2
dvPadPress			 EQU dvPadHold+0x2
dvIntFlag			 EQU dvPadPress+0x2
dvFrame				 EQU dvIntFlag+0x1
dvAdvance			 EQU dvFrame+0x1
dvPosition			 EQU dvAdvance+0x2
dvSongTable			 EQU dvPosition+0x0
dvSongHeader			 EQU dvSongTable+0x4
dvExternalProc			 EQU dvSongHeader+0x4
dvSndTestId			 EQU dvExternalProc+0x4
dvTestDelay			 EQU dvSndTestId+0x2
dvGrapParam			 EQU dvTestDelay+0x1
dvmSelChan			 EQU dvGrapParam+0x1
dvChanData			 EQU dvmSelChan+0x2
dvChanOffs			 EQU dvChanData+0x4
dvModeId			 EQU dvChanOffs+0x2
dvModeUpdate			 EQU dvModeId+0x0
dvTestSelection			 EQU dvModeUpdate+0x4
dvTestType			 EQU dvTestSelection+0x2
dvTestMax			 EQU dvTestType+0x2
dvTestUpdate			 EQU dvTestMax+0x2
dvTestHistCount			 EQU dvTestUpdate+0x4
dvFullHisPos			 EQU dvTestHistCount+0x2
dvGraphScale			 EQU dvFullHisPos+0x2
dvGraphOff			 EQU dvGraphScale+0x2
dvGraphRout			 EQU dvGraphOff+0x2
dvGraphCol			 EQU dvGraphRout+0x4
dvGraphLast			 EQU dvGraphCol+0x2
dvTestId			 EQU dvGraphLast+0x2
dvTrackerLeft			 EQU dvTestId+0x0
dvGraphLast2			 EQU dvTrackerLeft+0x0
dvTestEdit			 EQU dvGraphLast2+0x2
dvTrackerBlank			 EQU dvTestEdit+0x0
dvGraphCol2			 EQU dvTrackerBlank+0x0
dvGraphHisPos2			 EQU dvGraphCol2+0x2
dvTrackerFlags			 EQU dvGraphHisPos2+0x2
dvGraphLeft			 EQU dvTrackerFlags+0x2
dvTrackLineAddr			 EQU dvGraphLeft+0x2
dvGraphHisPos			 EQU dvTrackLineAddr+0x0
dvTrackLines			 EQU dvGraphHisPos+0x2
dvPianoSprites			 EQU dvTrackLines+0x0
dvGraphHistory			 EQU dvPianoSprites+0x0
dvGraphHisEnd			 EQU dvGraphHistory+(dvGraphHistSz*2)
dvCallStackAddr			 EQU dvGraphHisEnd+0x0
dvGraphAbove			 EQU dvCallStackAddr+0x0
dvCallStack			 EQU dvGraphAbove+0x4
dvGraphBuffer			 EQU dvCallStack+0x0
dvGraphBelow			 EQU dvGraphBuffer+(dvGraphHeight*8*4)
dvGraphAbove2			 EQU dvGraphBelow+0x0
dvTestBuffer			 EQU dvGraphAbove2+0x4
dvGraphBuffer2			 EQU dvTestBuffer+0x0
dvTrackEndAddr			 EQU dvGraphBuffer2+(dvGraphHeight*8*4)
dvGraphBelow2			 EQU dvTrackEndAddr+0x0
dvEnd				 EQU dvGraphBelow2+0x4
dvMusicId			 EQU 0x0
dvMusicInfo			 EQU 0x0
dvSfxId				 EQU 0x4
dvSfxInfo			 EQU 0x4
dvFracOffset			 EQU 0x8
dvMusHistory			 EQU 0x8
dvSfxHistory			 EQU 0xC
dvChannelCom			 EQU 0x10
dvVolumeCom			 EQU 0x14
dvString			 EQU 0x18
	endif
ddStackError			 EQU 0x4
ddStackChannel			 EQU 0x8
ddStackExtra			 EQU 0xC
ddStackD7			 EQU 0x10
ddStackLen			 EQU 0x14
	if VISUAL_DEBUG
PAD_TH				 EQU 0x6
PAD_TR				 EQU 0x5
PAD_TL				 EQU 0x4
	endif
	if VISUAL_DEBUG
dvHistory_FM3o1			 EQU dvHistory+0x0
	endif
	if VISUAL_DEBUG
dvHistory_FM3o2			 EQU dvHistory+0x3C0
	endif
	if VISUAL_DEBUG
dvHistory_FM3o3			 EQU dvHistory+0x780
	endif
	if VISUAL_DEBUG
dvHistory_FM3o4			 EQU dvHistory+0xB40
	endif
	if VISUAL_DEBUG
dvHistory_TA			 EQU dvHistory+0xF00
	endif
	if VISUAL_DEBUG
dvHistory_FM1			 EQU dvHistory+0x12C0
	endif
	if VISUAL_DEBUG
dvHistory_FM2			 EQU dvHistory+0x1680
	endif
	if VISUAL_DEBUG
dvHistory_FM4			 EQU dvHistory+0x1A40
	endif
	if VISUAL_DEBUG
dvHistory_FM5			 EQU dvHistory+0x1E00
	endif
	if VISUAL_DEBUG
dvHistory_FM6			 EQU dvHistory+0x21C0
	endif
	if VISUAL_DEBUG
dvHistory_SFXFM1		 EQU dvHistory+0x2580
	endif
	if VISUAL_DEBUG
dvHistory_SFXFM2		 EQU dvHistory+0x2940
	endif
	if VISUAL_DEBUG
dvHistory_SFXFM4		 EQU dvHistory+0x2D00
	endif
	if VISUAL_DEBUG
dvHistory_SFXFM5		 EQU dvHistory+0x30C0
	endif
	if VISUAL_DEBUG
dvHistory_DAC1			 EQU dvHistory+0x3480
	endif
	if VISUAL_DEBUG
dvHistory_DAC2			 EQU dvHistory+0x3840
	endif
	if VISUAL_DEBUG
dvHistory_SFXDAC2		 EQU dvHistory+0x3C00
	endif
	if VISUAL_DEBUG
dvHistory_PSG1			 EQU dvHistory+0x3FC0
	endif
	if VISUAL_DEBUG
dvHistory_PSG2			 EQU dvHistory+0x4380
	endif
	if VISUAL_DEBUG
dvHistory_PSG3			 EQU dvHistory+0x4740
	endif
	if VISUAL_DEBUG
dvHistory_PSG4			 EQU dvHistory+0x4B00
	endif
	if VISUAL_DEBUG
dvHistory_SFXPSG1		 EQU dvHistory+0x4EC0
	endif
	if VISUAL_DEBUG
dvHistory_SFXPSG2		 EQU dvHistory+0x5280
	endif
	if VISUAL_DEBUG
dvHistory_SFXPSG3		 EQU dvHistory+0x5640
	endif
	if VISUAL_DEBUG
dvHistory_SFXPSG4		 EQU dvHistory+0x5A00
	endif
	if VISUAL_DEBUG
dHistoryInfoEnd			 EQU dvHistory+0x5DC0
	endif
	if VISUAL_DEBUG
dvmGlobal_DrawStr		 EQU 0x0
dvmGlobal_DrawNumMap		 EQU 0x8
dvmGlobal_DrawNumMapA1		 EQU 0xC
dvmGlobal_DrawGetAddr		 EQU 0x10
	endif
	if VISUAL_DEBUG
dvmTracker_Lines		 EQU 0xF
dvmTracker_Top			 EQU 0xA
	endif
