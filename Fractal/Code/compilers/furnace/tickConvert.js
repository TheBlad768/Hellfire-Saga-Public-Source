"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.unconvertFrequencySpace = exports.convertFrequencySpace = exports.computePortaTarget = exports.updateFracMacros = exports.delayToRow = void 0;
const commands_1 = require("../../shared/commands");
const notes_1 = require("../../shared/notes");
const library_1 = require("./library");
const patternConvert_1 = require("./patternConvert");
function delayToRow(c, ch, _row, _tick, noteon) {
    var _a, _b, _c;
    let tick = _tick;
    let row = _row;
    const speedsLUT = [ch.convert.speed1 * c.targetSong.timebase, ch.convert.speed2 * c.targetSong.timebase,];
    while (tick > speedsLUT[row & 1]) {
        tick -= speedsLUT[row & 1];
        row++;
    }
    if (ch.base.hidden || ch.convert.row > row) {
        return;
    }
    if (ch.convert.row === row && ch.convert.tick > tick) {
        return;
    }
    let note = ch.convert.note, tieNote = null, realNote = ch.convert.realNote;
    let tie = ch.convert.legato || ch.convert.softNote || note === null, reset = false;
    if (ch.convert.active) {
        if (((_a = note === null || note === void 0 ? void 0 : note.id) !== null && _a !== void 0 ? _a : 0x1000) < notes_1.firstRealNote) {
            tie = false;
            tieNote = note;
        }
    }
    else {
        realNote = note = tieNote = notes_1.noteCut;
    }
    let songNote = new notes_1.SongNote(note, 0, tie);
    let ticks = 0;
    const checkTick = (row, tick) => {
        if (processTickEffects(row, tick, c, ch, songNote, realNote)) {
            songNote.delay = ticks;
            ticks = 0;
            if (ch.convert.hardResetOn && !songNote.tie && songNote.note !== null && songNote.note !== notes_1.noteCut && songNote.note !== notes_1.noteRest) {
                ch.convert.routine.items.push(new commands_1.SongFastCut());
            }
            ch.convert.routine.items.push(songNote);
            songNote = new notes_1.SongNote(tieNote, 0, tieNote === null);
            reset = true;
        }
    };
    for (let tickno = ch.convert.tick; tickno < (ch.convert.row === row ? tick : speedsLUT[ch.convert.row & 1]); tickno++) {
        ticks++;
        checkTick(ch.convert.row, tickno);
    }
    if (ch.convert.row !== row) {
        processSwitchRow(c, ch);
        for (let r = ch.convert.row + 1; r < row; r++) {
            for (let tickno = 0; tickno < (r === row ? tick : speedsLUT[r & 1]); tickno++) {
                ticks++;
                checkTick(r, tickno);
            }
            processSwitchRow(c, ch);
        }
        if (tick !== 0) {
            for (let tickno = 0; tickno < tick; tickno++) {
                ticks++;
                checkTick(row, tickno);
            }
        }
    }
    if (ticks > 0) {
        if (ch.convert.hardResetOn && !songNote.tie && songNote.note !== null && songNote.note !== notes_1.noteCut && songNote.note !== notes_1.noteRest) {
            ch.convert.routine.items.push(new commands_1.SongFastCut());
        }
        reset = true;
        songNote.delay = ticks;
        ch.convert.routine.items.push(songNote);
    }
    ch.convert.tick = tick;
    ch.convert.row = row;
    if (reset && ((_c = (_b = ch.convert.note) === null || _b === void 0 ? void 0 : _b.id) !== null && _c !== void 0 ? _c : 0) >= notes_1.firstRealNote) {
        ch.convert.note = null;
    }
}
exports.delayToRow = delayToRow;
function processSwitchRow(c, ch) {
    ch.convert.retrigger = NaN;
}
function processTickEffects(row, tick, c, ch, songNote, note) {
    var _a, _b;
    let ret = false, frac = false;
    if (ch.convert.portamento.resetSpeed) {
        ch.convert.portamento.resetSpeed = false;
        ch.convert.routine.items.push(new commands_1.SongPortaSpeed(0));
        ret = true;
    }
    if (ch.convert.volumeSlide) {
        ch.convert.volumeSlideTick += ch.convert.volumeSlide;
        let diff = Math[ch.convert.volumeSlide < 0 ? "ceil" : "floor"](ch.convert.volumeSlideTick);
        if (diff) {
            ch.convert.patVolume += diff;
            ch.convert.updateVolume = false;
            ch.convert.volumeSlideTick %= 1;
            if (ch.convert.volumeSlide < 0 && ch.convert.patVolume <= 0) {
                diff -= ch.convert.patVolume;
                ch.convert.patVolume = 0;
                if (true) {
                    ch.convert.volumeSlide = 0;
                }
            }
            else if (ch.convert.volumeSlide > 0 && ch.convert.patVolume >= 0x7F) {
                diff -= ch.convert.patVolume - 0x7F;
                ch.convert.patVolume = 0x7F;
                if (true) {
                    ch.convert.volumeSlide = 0;
                }
            }
            diff = ch.convert.patVolume - ch.convert.lastVolume;
            if (diff !== 0) {
                ch.convert.lastVolume = ch.convert.patVolume;
                ch.convert.routine.items.push(ch.convert.volumeIsTL ?
                    new commands_1.SongSetTL(ch.operator, ch.convert.lastVolume + ((_b = (_a = ch.convert.voice) === null || _a === void 0 ? void 0 : _a.totallevel[ch.operator]) !== null && _b !== void 0 ? _b : 0)) :
                    new commands_1.SongAddVolume(diff));
                ret = true;
            }
            if (ch.convert.volumeSlideSingleTick) {
                ch.convert.volumeSlide = 0;
            }
        }
    }
    if (!ch.convert.portamento.finished) {
        if (ch.convert.portamento.trackMode) {
            const target = computePortaTarget(ch);
            const { diff, actual, reset, } = handlePortamentoFreq(c, ch);
            frac = ret = true;
            if (diff !== 0 && !reset) {
                const resFrac = (0, notes_1.calcFracForFreq)(actual, ch.type) - ch.convert.patFrac - (ch.convert.resetNoteFrac ? 0 : ch.convert.noteFrac);
                ch.convert.portamento.frac = resFrac;
            }
            else if (reset) {
                ch.convert.noteFrac += (target - ch.convert.patFrac);
                ch.convert.resetNoteFrac = true;
                ch.convert.portamento.resetOnNextNote = true;
                ch.convert.portamento.finished = true;
                ch.convert.patFrac = target;
                ch.convert.portamento.frac = 0;
            }
        }
        else {
            const target = computePortaTarget(ch);
            const { reset, } = handlePortamentoFreq(c, ch);
            if (reset) {
                ch.convert.portamento.resetOnNextNote = true;
                ch.convert.patFrac = target;
                ret = true;
            }
        }
    }
    else if (ch.convert.portamento.trackMode && !ch.convert.portamento.empty) {
        if (songNote.note && songNote.note !== notes_1.noteRest) {
            ch.convert.portamento.empty = true;
            ch.convert.portamento.frac = 0;
            frac = ret = true;
        }
    }
    if (ch.convert.arpeggio.current && (--ch.convert.arpeggio.tick) <= 0) {
        ch.convert.arpeggio.phase++;
        ch.convert.arpeggio.phase %= 3;
        ch.convert.arpeggio.tick = ch.convert.arpeggio.current.speed;
        ch.convert.arpeggio.frac = [0, ch.convert.arpeggio.current.frac1, ch.convert.arpeggio.current.frac2,][ch.convert.arpeggio.phase];
        frac = ret = true;
    }
    if (updateFracMacros(ch) || frac) {
        (0, patternConvert_1.updateFrac)(ch);
        ret = true;
    }
    ret = updateOpMacros(ch) || ret;
    ret = updatePanMacro(ch) || ret;
    ret = updateDutyMacroPSG4(c, ch, songNote) || ret;
    ret = updatePhaseResetMacro(ch, songNote) || ret;
    if (!isNaN(ch.convert.retrigger)) {
        if ((tick % ch.convert.retrigger) === ch.convert.retrigger - 1) {
            songNote.note = note;
            songNote.tie = false;
            ret = true;
        }
    }
    return ret;
}
function updateDutyMacroPSG4(c, ch, songNote) {
    var _a, _b, _c, _d, _e, _f, _g;
    const duty = (_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.macros.duty;
    const arp = (_b = ch.convert.macroInstrument) === null || _b === void 0 ? void 0 : _b.macros.arpeggio;
    if (!(0, library_1.isNoise)(ch.type) || (!duty && !arp)) {
        return false;
    }
    const d = duty === null || duty === void 0 ? void 0 : duty.nextValue();
    const a = arp === null || arp === void 0 ? void 0 : arp.nextValue();
    if ((d === null || d === void 0 ? void 0 : d.end) !== false && (a === null || a === void 0 ? void 0 : a.end) !== false && (d === null || d === void 0 ? void 0 : d.change) !== true && (a === null || a === void 0 ? void 0 : a.change) !== true) {
        return false;
    }
    const dutyvalue = (_c = d === null || d === void 0 ? void 0 : d.value) !== null && _c !== void 0 ? _c : ch.convert.noiseMode;
    const modeid = !a ? ch.convert.noiseModeId : a.value + (isNaN((_d = arp === null || arp === void 0 ? void 0 : arp.rootNote) !== null && _d !== void 0 ? _d : 0) ? ch.convert.patNoteReal : 0);
    let note;
    if (dutyvalue & 2) {
        note = ["nPeriPSG3", "nWhitePSG3",][dutyvalue & 1];
        ch.convert.extern.isPSG3 = true;
    }
    else if (dutyvalue === 0) {
        note = ["nPeri40", "nPeri20", "nPeri10",][modeid];
        ch.convert.extern.isPSG3 = false;
    }
    else {
        note = ["nWhite40", "nWhite20", "nWhite10",][modeid];
        ch.convert.extern.isPSG3 = false;
    }
    if (note) {
        const nt = (_e = (0, notes_1.getNoteByName)(note)) !== null && _e !== void 0 ? _e : notes_1.noteCut;
        if (((d === null || d === void 0 ? void 0 : d.change) === true && c.file.info.flags.SNDutyMacroAlwaysResetsPhase === true) ||
            nt.name !== ((_f = ch.convert.dutyNote) === null || _f === void 0 ? void 0 : _f.name) || (a === null || a === void 0 ? void 0 : a.change) === true) {
            songNote.note = ch.convert.dutyNote = (_g = (0, notes_1.getNoteByName)(note)) !== null && _g !== void 0 ? _g : notes_1.noteCut;
        }
    }
    return true;
}
function updatePhaseResetMacro(ch, songNote) {
    var _a;
    const mac = (_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.macros.phaseReset;
    if (!mac) {
        return false;
    }
    const v = mac.nextValue();
    if (v.end || v.next === 0) {
        return false;
    }
    if (songNote.note === null) {
        songNote.note = notes_1.noteKey;
    }
    songNote.tie = false;
    return true;
}
function updateFracMacros(ch) {
    var _a, _b;
    let value = 0, change = false;
    const procMacroValue = (m) => {
        if ((m === null || m === void 0 ? void 0 : m.putInTracker) !== true) {
            return;
        }
        const r = m.nextValue(ch.type);
        value += r.value;
        change = change || r.change;
    };
    procMacroValue((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.macros.arpeggio);
    procMacroValue((_b = ch.convert.macroInstrument) === null || _b === void 0 ? void 0 : _b.macros.pitch);
    ch.convert.macroFrac = value;
    return change;
}
exports.updateFracMacros = updateFracMacros;
function updatePanMacro(ch) {
    var _a;
    const mac = (_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.macros.pan;
    if (!mac || (!(0, library_1.isFM)(ch.type) && !(0, library_1.isDAC)(ch.type))) {
        return false;
    }
    const v = mac.nextValue();
    if (!v.change && v.end) {
        return false;
    }
    ch.convert.routine.items.push(new commands_1.SongPan(v.value));
    return true;
}
function updateOpMacros(ch) {
    var _a, _b, _c, _d, _e, _f, _g, _h;
    let ret = false;
    const opu = {};
    if (!ch.convert.cut && ((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice) && (0, library_1.isFM)(ch.type)) {
        for (const op of (_b = ch.convert.macroInstrument.macros.ops) !== null && _b !== void 0 ? _b : []) {
            if (op.position >= op.macro.data.length) {
                if (!op.hasLoop()) {
                    continue;
                }
                op.position = op.macro.loop;
            }
            const v = op.nextValue();
            if (!v.change && v.end) {
                return false;
            }
            if ("operator" in op.macro) {
                ch.convert.macroInstrument.dynamicVoice[op.prop][op.macro.operator] = v.value;
            }
            else {
                ch.convert.macroInstrument.dynamicVoice[op.prop] = v.value;
            }
            const rval = ch.convert.macroInstrument.dynamicVoice.getRegister(op.reg);
            if (rval !== ch.convert.macroInstrument.reg[op.reg]) {
                ch.convert.macroInstrument.reg[op.reg] = rval;
                opu[op.reg] = rval;
                ret = true;
            }
        }
    }
    for (const v of Object.entries(opu)) {
        const n = parseInt(v[0], 10);
        if (n === 0xB4) {
            ch.convert.routine.items.push(new commands_1.SongSetAMSFMS((_e = (_d = (_c = ch.convert.macroInstrument) === null || _c === void 0 ? void 0 : _c.dynamicVoice) === null || _d === void 0 ? void 0 : _d.ams) !== null && _e !== void 0 ? _e : 0, (_h = (_g = (_f = ch.convert.macroInstrument) === null || _f === void 0 ? void 0 : _f.dynamicVoice) === null || _g === void 0 ? void 0 : _g.fms) !== null && _h !== void 0 ? _h : 0));
        }
        else if ((n & 0xF0) === 0x40) {
            ch.convert.routine.items.push(new commands_1.SongSetTL((n & 0xC) >> 2, v[1]));
        }
        else {
            ch.convert.routine.items.push(new commands_1.SongYMCommand(parseInt(v[0], 10), v[1]));
        }
    }
    return ret;
}
function computePortaTarget(ch) {
    const target = !isNaN(ch.convert.portamento.target) ? ch.convert.portamento.target : ch.convert.patFrac;
    if (target < 0x10000) {
        return target;
    }
    if (target < 0x20000) {
        return (ch.convert.portamento.root + (target & 0xF)) << 8;
    }
    if (target < 0x30000) {
        return (ch.convert.portamento.root - (target & 0xF)) << 8;
    }
    if (target < 0x40000) {
        return (0, notes_1.calcFracForFreq)(unconvertFrequencySpace(ch, ch.convert.portamento.rootFreq) + (target & 0xFFFF), ch.type);
    }
    if (target < 0x50000) {
        return (0, notes_1.calcFracForFreq)(unconvertFrequencySpace(ch, ch.convert.portamento.rootFreq) - (target & 0xFFFF), ch.type);
    }
    return 0;
}
exports.computePortaTarget = computePortaTarget;
function handlePortamentoFreq(c, ch) {
    if (ch.convert.portamento.finished || isNaN(ch.convert.portamento.targetFreq) || isNaN(ch.convert.portamento.rootFreq)) {
        return { diff: 0, actual: 0, reset: false, };
    }
    let reset = ch.convert.portamento.target >= 0x30000 && ch.convert.portamento.target < 0x40000;
    let diff = ch.convert.portamento.speedFreq, actual = ch.convert.portamento.rootFreq;
    const dist = ch.convert.portamento.targetFreq - ch.convert.portamento.rootFreq;
    if (dist < 0) {
        if (-dist > diff) {
            diff = -diff;
            ch.convert.portamento.rootFreq += diff;
            actual = ch.convert.portamento.rootFreq;
        }
        else {
            diff = -dist;
            actual = ch.convert.portamento.rootFreq = ch.convert.portamento.targetFreq;
            reset = true;
            if (c.file.info.flags.targetResetsSlides === true) {
                ch.convert.portamento.finished = true;
            }
            else {
                ch.convert.portamento.targetFreq = NaN;
            }
        }
    }
    else if (dist > diff) {
        ch.convert.portamento.rootFreq += diff;
        actual = ch.convert.portamento.rootFreq;
    }
    else {
        diff = dist;
        actual = ch.convert.portamento.rootFreq = ch.convert.portamento.targetFreq;
        reset = true;
        if (c.file.info.flags.targetResetsSlides === true) {
            ch.convert.portamento.finished = true;
        }
        else {
            ch.convert.portamento.targetFreq = NaN;
        }
    }
    return { diff, actual, reset, };
}
function convertFrequencySpace(ch, freq) {
    if (!(0, library_1.isFM)(ch.type)) {
        return freq;
    }
    const octaves = Math.floor(freq / 0x800);
    return freq - (octaves * 0x57C);
}
exports.convertFrequencySpace = convertFrequencySpace;
function unconvertFrequencySpace(ch, freq) {
    if (!(0, library_1.isFM)(ch.type)) {
        return freq;
    }
    let octave = 0;
    for (; octave < 10; octave++) {
        if (freq < (octave + 2) * 0x284) {
            break;
        }
    }
    return freq + (octave * 0x57C);
}
exports.unconvertFrequencySpace = unconvertFrequencySpace;
