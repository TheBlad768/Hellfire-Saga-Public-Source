"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postEffects = exports.mainEffects = exports.portaEffects = exports.preEffects = exports.globalPreEffects = void 0;
const furnace_module_interface_1 = require("../../shared/furnace-module-interface");
const commands_1 = require("../../shared/commands");
const lib_1 = require("../../shared/lib");
const notes_1 = require("../../shared/notes");
const song_1 = require("../../shared/song");
const info_1 = require("./info");
const library_1 = require("./library");
const tickConvert_1 = require("./tickConvert");
const instruments_1 = require("./instruments");
exports.globalPreEffects = {
    0x09: (value, ch, c) => {
        if (value) {
            for (const chh of c.channels[c.index]) {
                if (chh) {
                    chh.convert.setSpeed1 = value;
                }
            }
        }
        return true;
    },
    0x0F: (value, ch, c) => {
        if (value) {
            for (const chh of c.channels[c.index]) {
                if (chh) {
                    chh.convert.setSpeed2 = value;
                }
            }
        }
        return true;
    },
    0x17: (value, ch, c, chlist) => {
        if (typeof value === "number") {
            ch.convert.is17 = value !== 0;
            const dach = chlist[c.linkFM6 === song_1.ChannelType.DAC1 ? "dac1" : "dac2"];
            if (!chlist.fm6 || !c.linkFM6 || !dach) {
                c.helper.warn(c.getInfo(), "PCM toggle (17" + (0, lib_1.hex)(2, value !== null && value !== void 0 ? value : 0) + ") can only be used when FM6 is linked! Ignoring...");
                return true;
            }
            dach.convert.is17 = value !== 0;
            if (!ch.convert.pitchedSample) {
                dach.convert.setActive = value !== 0;
                chlist.fm6.convert.setActive = value === 0;
            }
        }
        return true;
    },
    0x68: (value, ch, c) => {
        c.convert.jumpMode = (value !== null && value !== void 0 ? value : 0) & 0xF0;
        if (typeof value !== "number") {
            return true;
        }
        c.convert.timingIndex = value & 0xF;
        return true;
    },
    0x69: (value, ch, c) => {
        if (typeof value !== "number") {
            return true;
        }
        c.convert.timingValue = value;
        return true;
    },
};
exports.preEffects = {
    0xEF: (value, ch, c) => {
        c.helper.warn(c.getInfo(), "Global pitch (EF" + (0, lib_1.hex)(2, value !== null && value !== void 0 ? value : 0) + ") is not supported! Ignoring...");
        return true;
    },
    0x18: (value, ch, c) => {
        c.helper.warn(c.getInfo(), "EXT3 toggle (18" + (0, lib_1.hex)(2, value !== null && value !== void 0 ? value : 0) + ") is not supported! Ignoring...");
        return true;
    },
    0xEA: (value, ch) => {
        ch.convert.legato = !!value;
        return true;
    },
    0xEB: (value, ch) => {
        if (typeof value === "number") {
            ch.convert.sampleBank = value;
        }
        return true;
    },
    0xEC: (value, ch) => {
        if (value && ch.convert.active) {
            ch.convert.cutDelay = value;
        }
        return true;
    },
    0xED: (value, ch) => {
        if (value) {
            ch.convert.tickDelay = value;
        }
        return true;
    },
    0xE5: (value, ch) => {
        if (typeof value === "number" && ch.convert.active) {
            ch.convert.detune = Math.round((value - 0x80) / 0x7F * 0x100);
            ch.convert.updateFrac = true;
        }
        return true;
    },
    0xC0: (value, ch, c) => {
        return setTps(ch, c, value !== null && value !== void 0 ? value : 0);
    },
    0xC1: (value, ch, c) => {
        return setTps(ch, c, 0x100 | (value !== null && value !== void 0 ? value : 0));
    },
    0xC2: (value, ch, c) => {
        return setTps(ch, c, 0x200 | (value !== null && value !== void 0 ? value : 0));
    },
    0xC3: (value, ch, c) => {
        return setTps(ch, c, 0x300 | (value !== null && value !== void 0 ? value : 0));
    },
};
function setTps(ch, c, value) {
    var _a, _b, _c;
    if (!ch.convert.active) {
        return false;
    }
    c.targetSong.ticksPerSecond = value < 10 ? 10 : value;
    const res = (0, info_1.calcTempo)(c);
    if (isNaN(res)) {
        return false;
    }
    (_a = ch.channel) === null || _a === void 0 ? void 0 : _a.routine.items.push(new commands_1.SongTempo(res, (_c = (_b = c.song.getSong(c.index + 1)) === null || _b === void 0 ? void 0 : _b.flags.PAL) !== null && _c !== void 0 ? _c : false));
    return true;
}
exports.portaEffects = {
    0x01: (value, ch, c, x, rd) => {
        let target = 0;
        switch (true) {
            case (0, library_1.isDAC)(ch.type):
                target = c.file.info.flags.limitSlides === true ? 0xC * 8 : notes_1.maxNoteDAC;
                break;
            case (0, library_1.isPSG)(ch.type):
                target = 0x5E;
                break;
            case ch.type === song_1.ChannelType.TA:
                target = notes_1.maxNoteTA - 1;
                break;
            case (0, library_1.isFM)(ch.type):
                target = c.file.info.flags.limitSlides === true ? 0xC * 8 : 0x75;
                break;
        }
        setPortamento(c, ch, value !== null && value !== void 0 ? value : 0, target << 8, true, rd);
        return true;
    },
    0x02: (value, ch, c, x, rd) => {
        let target = 0;
        switch (true) {
            case (0, library_1.isDAC)(ch.type):
                target = c.file.info.flags.limitSlides === true ? 0 : notes_1.minNoteDAC;
                break;
            case (0, library_1.isPSG)(ch.type):
                target = 0x8;
                break;
            case ch.type === song_1.ChannelType.TA:
                target = notes_1.minNoteTA;
                break;
            case (0, library_1.isFM)(ch.type):
                target = c.file.info.flags.limitSlides === true ? 0 : notes_1.minNoteFM;
                break;
        }
        setPortamento(c, ch, value !== null && value !== void 0 ? value : 0, target << 8, true, rd);
        return true;
    },
    0xE1: (value, ch, c, x, rd) => {
        const v = value !== null && value !== void 0 ? value : 0;
        setPortamento(c, ch, (v & 0xF0) >> 2, 0x10000 | (v & 0xF), false, rd);
        return true;
    },
    0xE2: (value, ch, c, x, rd) => {
        const v = value !== null && value !== void 0 ? value : 0;
        setPortamento(c, ch, (v & 0xF0) >> 2, 0x20000 | (v & 0xF), false, rd);
        return true;
    },
    0x03: (value, ch, c, x, rd) => {
        setPortamento(c, ch, value !== null && value !== void 0 ? value : 0, NaN, false, rd);
        return true;
    },
    0xF1: (value, ch, c, x, rd) => singleSlide(1, value !== null && value !== void 0 ? value : 0, ch, c, rd),
    0xF2: (value, ch, c, x, rd) => singleSlide(-1, value !== null && value !== void 0 ? value : 0, ch, c, rd),
};
function singleSlide(direction, value, ch, c, rd) {
    const offset = value * (((0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA) ? -direction : direction);
    setPortamento(c, ch, 0x7FFF, offset < 0 ? (0x40000 | -offset) : (0x30000 | offset), true, rd);
    return true;
}
function setPortamento(c, ch, speed, target, slide, rd) {
    var _a;
    if (!ch.convert.active) {
        return false;
    }
    if ((0, library_1.isNoise)(ch.type)) {
        c.helper.warn(c.getInfo(), "PSG4 does not support portamento effect in " + ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + "!");
        return;
    }
    if (speed === 0) {
        if (ch.convert.portamento.trackMode !== true) {
            ch.convert.portamento.resetSpeed = true;
        }
        ch.convert.arpeggio.inhibit = false;
        ch.convert.updateFrac = true;
        ch.convert.portamento.finished = true;
        return;
    }
    ch.convert.portamento.noteSetsTarget = isNaN(target);
    ch.convert.portamento.isSlide = slide;
    if (c.file.info.flags.pitchMode === furnace_module_interface_1.FurnacePitchMode.fullLinear) {
        ch.convert.portamento.empty = ch.convert.portamento.finished = false;
        ch.convert.portamento.trackMode = false;
        return;
    }
    if (ch.convert.portamento.empty || ch.convert.portamento.finished) {
        if (ch.convert.portamento.noteSetsTarget && typeof (rd === null || rd === void 0 ? void 0 : rd.note) !== "number") {
            ch.convert.arpeggio.inhibit = false;
            ch.convert.updateFrac = true;
            ch.convert.portamento.finished = true;
            return;
        }
        else if (ch.convert.portamento.noteSetsTarget || typeof (rd === null || rd === void 0 ? void 0 : rd.note) !== "number") {
            if (ch.convert.portamento.empty) {
                ch.convert.portamento.root = ch.convert.patFrac >> 8;
                const frac = ch.convert.patFrac - (ch.convert.resetNoteFrac ? 0 : ch.convert.noteFrac);
                ch.convert.portamento.rootFreq = (0, tickConvert_1.convertFrequencySpace)(ch, (0, notes_1.calcRawFreq)(frac, ch.type));
            }
        }
        else if (!ch.convert.portamento.noteSetsTarget) {
            ch.convert.portamento.rootFreq = ch.convert.portamento.root = NaN;
        }
    }
    if (!ch.convert.portamento.noteSetsTarget) {
        ch.convert.portamento.target = target;
        ch.convert.portamento.targetFreq = (0, tickConvert_1.convertFrequencySpace)(ch, (0, notes_1.calcRawFreq)((0, tickConvert_1.computePortaTarget)(ch), ch.type));
    }
    ch.convert.portamento.speedFreq = speed;
    ch.convert.portamento.empty = ch.convert.portamento.finished = false;
    ch.convert.portamento.trackMode = (0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA;
    if (ch.convert.portamento.trackMode) {
        return;
    }
    ch.convert.portamento.speed = Math.round((0x100 / 0x38) * speed);
    ch.convert.portamento.update = true;
}
function setArpeggio(ch, value, speed) {
    var _a, _b, _c, _d, _e, _f;
    if (!ch.convert.active) {
        return false;
    }
    if (!ch.convert.arpeggio.set) {
        ch.convert.arpeggio.set = {
            enabled: true, reset: false, speed: (_b = (_a = ch.convert.arpeggio.current) === null || _a === void 0 ? void 0 : _a.speed) !== null && _b !== void 0 ? _b : 1,
            frac1: (_d = (_c = ch.convert.arpeggio.current) === null || _c === void 0 ? void 0 : _c.frac1) !== null && _d !== void 0 ? _d : 0, frac2: (_f = (_e = ch.convert.arpeggio.current) === null || _e === void 0 ? void 0 : _e.frac2) !== null && _f !== void 0 ? _f : 0,
        };
    }
    if (speed) {
        ch.convert.arpeggio.set.speed = speed;
    }
    if (typeof value === "number") {
        ch.convert.arpeggio.set.frac1 = (value >> 4) * 0x100;
        ch.convert.arpeggio.set.frac2 = (value & 0xF) * 0x100;
        if (value === 0) {
            ch.convert.arpeggio.set.enabled = false;
        }
        else {
            ch.convert.arpeggio.set.reset = true;
        }
    }
}
function doUnidirectionalSlide(ch, value, base, single) {
    if (!ch.convert.active) {
        return false;
    }
    ch.convert.volumeSlide = (((value !== null && value !== void 0 ? value : 0) + 1) * ((0, library_1.isPSG)(ch.type) ? 8 : 1)) * base;
    ch.convert.volumeSlideSingleTick = single;
    if (!single) {
        ch.convert.volumeSlideTick = 0;
    }
    return true;
}
function doBidirectionalSlide(ch, value, base) {
    if (!ch.convert.active) {
        return false;
    }
    const down = ((value !== null && value !== void 0 ? value : 0) >> 4) & 0xF, up = (value !== null && value !== void 0 ? value : 0) & 0xF;
    if (up !== 0) {
        ch.convert.volumeSlide = (up * ((0, library_1.isPSG)(ch.type) ? 8 : 1)) * base;
    }
    else {
        ch.convert.volumeSlide = (-down * ((0, library_1.isPSG)(ch.type) ? 8 : 1)) * base;
    }
    ch.convert.volumeSlideTick = 0;
    ch.convert.volumeSlideSingleTick = false;
    return true;
}
exports.mainEffects = {
    0xE0: (value, ch) => {
        if (value) {
            setArpeggio(ch, null, value);
        }
        return true;
    },
    0x00: (value, ch) => {
        setArpeggio(ch, value !== null && value !== void 0 ? value : 0, null);
        return true;
    },
    0x0C: (value, ch) => {
        if (ch.convert.active) {
            ch.convert.retrigger = value !== null && value !== void 0 ? value : 0;
        }
        return true;
    },
    0xE3: (value, ch, c) => {
        switch (value) {
            case 0:
            case 1:
            case 2:
                ch.convert.vibrato.mode = value;
                ch.convert.vibrato.update = true;
                c.helper.warn(c.getInfo(), "Vibrato mode (E3" + (0, lib_1.hex)(2, value) + ") is not yet implemented! Ignoring...");
                break;
        }
        return true;
    },
    0xE4: (value, ch) => {
        if (typeof value === "number") {
            ch.convert.vibrato.extDepth = value / 0xF * 0x100;
            ch.convert.vibrato.update = true;
        }
        return true;
    },
    0x04: (value, ch) => {
        if (!ch.convert.active) {
            return false;
        }
        ch.convert.vibrato.update = true;
        if (typeof value !== "number" || (value & 0xF) === 0 || (value & 0xF0) === 0) {
            ch.convert.vibrato.enabled = false;
            ch.convert.vibrato.vibrato = undefined;
            return true;
        }
        ch.convert.vibrato.enabled = true;
        ch.convert.vibrato.depth = value & 0xF;
        ch.convert.vibrato.speed = (value >> 4) & 0xF;
        return true;
    },
    0x0A: (value, ch) => doBidirectionalSlide(ch, value, 0.25),
    0xFA: (value, ch) => doBidirectionalSlide(ch, value, 4),
    0xF3: (value, ch) => doUnidirectionalSlide(ch, value, -1 / 25, false),
    0xF4: (value, ch) => doUnidirectionalSlide(ch, value, 1 / 25, false),
    0xF8: (value, ch) => doUnidirectionalSlide(ch, value, -1 / 25, true),
    0xF9: (value, ch) => doUnidirectionalSlide(ch, value, 1 / 25, true),
    0x20: (value, ch, c, list) => {
        if (typeof value !== "number" || !ch.convert.active || !list.psg4) {
            return true;
        }
        list.psg4.convert.noiseMode = (value & 0x10 ? 1 : 0) | (value & 1 ? 2 : 0);
        if (list.psg3) {
            list.psg3.convert.updateVolume = true;
            list.psg3.convert.extern.isPSG3 = (value & 0x10) !== 0;
        }
        return true;
    },
    0x08: (value, ch, c) => {
        if (!ch.convert.active) {
            return false;
        }
        if ((0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA) {
            c.helper.warn(c.getInfo(), "Panning (08" + (0, lib_1.hex)(2, value !== null && value !== void 0 ? value : 0) + ") is not supported on PSG and TA channels! Ignoring...");
            return true;
        }
        const left = ((value !== null && value !== void 0 ? value : 0) >> 4) & 0xF, right = (value !== null && value !== void 0 ? value : 0) & 0xF;
        let pan = 0x00;
        if (left > right) {
            pan = -0x7F;
        }
        else if (left < right) {
            pan = 0x7F;
        }
        ch.convert.routine.items.push(new commands_1.SongPan(pan));
        return true;
    },
    0x80: (value, ch, c) => {
        if (!ch.convert.active) {
            return false;
        }
        if ((0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA) {
            c.helper.warn(c.getInfo(), "Smooth panning (80" + (0, lib_1.hex)(2, value !== null && value !== void 0 ? value : 0) + ") is not supported on PSG and TA channels! Ignoring...");
            return true;
        }
        if (value === 0) {
            value = 1;
        }
        ch.convert.routine.items.push(new commands_1.SongPan((value !== null && value !== void 0 ? value : 0x80) - 0x80));
        return true;
    },
    0x10: (value, ch) => {
        if (!ch.convert.active) {
            return false;
        }
        ch.convert.routine.items.push(new commands_1.SongSetLFO(!value ? 0 : (value & 0xF0) === 0 ? 0 : value & 7 | 8));
        return true;
    },
    0x11: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Feedback (11" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        ch.convert.instrument = -1;
        ch.convert.macroInstrument.dynamicVoice.feedback = value & 0x7;
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0xB0));
        return true;
    },
    0x12: (value, ch, c) => totalLevel(0, "12", value, ch, c),
    0x13: (value, ch, c) => totalLevel(2, "13", value, ch, c),
    0x14: (value, ch, c) => totalLevel(1, "14", value, ch, c),
    0x15: (value, ch, c) => totalLevel(3, "15", value, ch, c),
    0x19: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Attack Rate (19" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        ch.convert.macroInstrument.dynamicVoice.attackrate[0] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.attackrate[1] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.attackrate[2] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.attackrate[3] = value & 0x1F;
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x50));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x58));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x54));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x5C));
        ch.convert.instrument = -1;
        return true;
    },
    0x1A: (value, ch, c) => attackRate(0, "1A", value, ch, c),
    0x1B: (value, ch, c) => attackRate(2, "1B", value, ch, c),
    0x1C: (value, ch, c) => attackRate(1, "1C", value, ch, c),
    0x1D: (value, ch, c) => attackRate(3, "1D", value, ch, c),
    0x56: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Decay 1 rate (56" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        ch.convert.macroInstrument.dynamicVoice.decay1rate[0] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.decay1rate[1] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.decay1rate[2] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.decay1rate[3] = value & 0x1F;
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x60));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x68));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x64));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x6C));
        ch.convert.instrument = -1;
        return true;
    },
    0x57: (value, ch, c) => decay1Rate(0, "57", value, ch, c),
    0x58: (value, ch, c) => decay1Rate(2, "58", value, ch, c),
    0x59: (value, ch, c) => decay1Rate(1, "59", value, ch, c),
    0x5A: (value, ch, c) => decay1Rate(3, "5A", value, ch, c),
    0x5B: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Decay 2 rate (5B" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        ch.convert.macroInstrument.dynamicVoice.decay2rate[0] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.decay2rate[1] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.decay2rate[2] = value & 0x1F;
        ch.convert.macroInstrument.dynamicVoice.decay2rate[3] = value & 0x1F;
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x70));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x78));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x74));
        ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x7C));
        ch.convert.instrument = -1;
        return true;
    },
    0x5C: (value, ch, c) => decay2Rate(0, "5C", value, ch, c),
    0x5D: (value, ch, c) => decay2Rate(2, "5D", value, ch, c),
    0x5E: (value, ch, c) => decay2Rate(1, "5E", value, ch, c),
    0x5F: (value, ch, c) => decay2Rate(3, "5F", value, ch, c),
    0x16: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Multiple (16" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        const op = opLUT[(value >> 4) & 0xF];
        if (op >= 0) {
            ch.convert.macroInstrument.dynamicVoice.multiple[op] = value & 0xF;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x30 | (op << 2)));
            ch.convert.instrument = -1;
        }
        return true;
    },
    0x50: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Amplitude Modulation (50" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        const op = opLUT[(value >> 4) & 0xF];
        if (op >= 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.ampmod[op] = (value & 0xF) === 0 ? 0 : 1;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x60 | (op << 2)));
        }
        else if ((value & 0xF0) === 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.ampmod[0] = (value & 0xF) === 0 ? 0 : 1;
            ch.convert.macroInstrument.dynamicVoice.ampmod[1] = (value & 0xF) === 0 ? 0 : 1;
            ch.convert.macroInstrument.dynamicVoice.ampmod[2] = (value & 0xF) === 0 ? 0 : 1;
            ch.convert.macroInstrument.dynamicVoice.ampmod[3] = (value & 0xF) === 0 ? 0 : 1;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x60));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x68));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x64));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x6C));
        }
        return true;
    },
    0x51: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Sustain Level (51" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        const op = opLUT[(value >> 4) & 0xF];
        if (op >= 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.decay1level[op] = value & 0xF;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x80 | (op << 2)));
        }
        else if ((value & 0xF0) === 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.decay1level[0] = value & 0xF;
            ch.convert.macroInstrument.dynamicVoice.decay1level[1] = value & 0xF;
            ch.convert.macroInstrument.dynamicVoice.decay1level[2] = value & 0xF;
            ch.convert.macroInstrument.dynamicVoice.decay1level[3] = value & 0xF;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x80));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x88));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x84));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x8C));
        }
        return true;
    },
    0x52: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Release Rate (52" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        const op = opLUT[(value >> 4) & 0xF];
        if (op >= 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.releaserate[op] = value & 0xF;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x80 | (op << 2)));
        }
        else if ((value & 0xF0) === 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.releaserate[0] = value & 0xF;
            ch.convert.macroInstrument.dynamicVoice.releaserate[1] = value & 0xF;
            ch.convert.macroInstrument.dynamicVoice.releaserate[2] = value & 0xF;
            ch.convert.macroInstrument.dynamicVoice.releaserate[3] = value & 0xF;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x80));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x88));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x84));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x8C));
        }
        return true;
    },
    0x53: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Detune (53" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        ch.convert.instrument = -1;
        const op = opLUT[(value >> 4) & 0xF];
        const v = instruments_1.wtfDetune[value & 0x7];
        if (op >= 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.detune[op] = v;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x30 | (op << 2)));
        }
        else if ((value & 0xF0) === 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.detune[0] = v;
            ch.convert.macroInstrument.dynamicVoice.detune[1] = v;
            ch.convert.macroInstrument.dynamicVoice.detune[2] = v;
            ch.convert.macroInstrument.dynamicVoice.detune[3] = v;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x30));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x38));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x34));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x3C));
        }
        return true;
    },
    0x54: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "Rate Scale (54" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        const op = opLUT[(value >> 4) & 0xF];
        if (op >= 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.ratescale[op] = value & 3;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x50 | (op << 2)));
        }
        else if ((value & 0xF0) === 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.ratescale[0] = value & 3;
            ch.convert.macroInstrument.dynamicVoice.ratescale[1] = value & 3;
            ch.convert.macroInstrument.dynamicVoice.ratescale[2] = value & 3;
            ch.convert.macroInstrument.dynamicVoice.ratescale[3] = value & 3;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x50));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x58));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x54));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x5C));
        }
        return true;
    },
    0x55: (value, ch, c) => {
        var _a, _b;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
            c.helper.warn(c.getInfo(), "SSG-EG (55" + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded! in " +
                ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
            return true;
        }
        const op = opLUT[(value >> 4) & 0xF];
        let v = (value & 0x7) | 8;
        if ((value & 0x8) !== 0) {
            v = 0;
        }
        if (op >= 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.ssgeg[op] = v;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x90 | (op << 2)));
        }
        else if ((value & 0xF0) === 0) {
            ch.convert.instrument = -1;
            ch.convert.macroInstrument.dynamicVoice.ssgeg[0] = v;
            ch.convert.macroInstrument.dynamicVoice.ssgeg[1] = v;
            ch.convert.macroInstrument.dynamicVoice.ssgeg[2] = v;
            ch.convert.macroInstrument.dynamicVoice.ssgeg[3] = v;
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x90));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x98));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x94));
            ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x9C));
        }
        return true;
    },
    0x30: (value, ch, c) => {
        var _a;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!(0, library_1.isFM)(ch.type)) {
            c.helper.warn(c.getInfo(), "Hard Reset (30" + (0, lib_1.hex)(2, value) + ") can only be used on FM channels in " +
                ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + "! Ignoring...");
            return true;
        }
        ch.convert.hardResetOn = value !== 0;
        return true;
    },
    0x70: (value, ch) => timingSet(0, value, ch),
    0x71: (value, ch) => timingSet(1, value, ch),
    0x72: (value, ch) => timingSet(2, value, ch),
    0x73: (value, ch) => timingSet(3, value, ch),
    0x74: (value, ch) => timingSet(4, value, ch),
    0x75: (value, ch) => timingSet(5, value, ch),
    0x76: (value, ch) => timingSet(6, value, ch),
    0x77: (value, ch) => timingSet(7, value, ch),
    0x78: (value, ch) => timingAdd(0, value, ch),
    0x79: (value, ch) => timingAdd(1, value, ch),
    0x7A: (value, ch) => timingAdd(2, value, ch),
    0x7B: (value, ch) => timingAdd(3, value, ch),
    0x7C: (value, ch) => timingAdd(4, value, ch),
    0x7D: (value, ch) => timingAdd(5, value, ch),
    0x7E: (value, ch) => timingAdd(6, value, ch),
    0x7F: (value, ch) => timingAdd(7, value, ch),
    0x6A: (value, ch) => {
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        let flag = "";
        for (let b = 7; b >= 0; --b) {
            if (value & (1 << b)) {
                flag += "vf<<u<<<".charAt(b);
            }
        }
        ch.convert.routine.items.push(new commands_1.SongFlags(flag));
        return true;
    },
    0x6E: (value, ch, c) => {
        var _a;
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        if (!((_a = c.helper.options) === null || _a === void 0 ? void 0 : _a.queue) || typeof c.helper.options.queue[value] !== "string") {
            c.helper.warn(c.getInfo(), "Queue (6E" + (0, lib_1.hex)(2, value) + ") is not valid, because queue entry is not defined! Ignoring...");
            return true;
        }
        ch.convert.routine.items.push(new commands_1.SongQueue(c.helper.options.queue[value]));
        return true;
    },
    0x6C: (value, ch) => {
        if (typeof value !== "number" || !ch.convert.active) {
            return true;
        }
        ch.convert.routine.items.push(value ? new commands_1.SongSpinRev() : new commands_1.SongSpinReset());
        return true;
    },
};
const opLUT = [-1, 0, 2, 1, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,];
function attackRate(op, effect, value, ch, c) {
    var _a, _b;
    if (typeof value !== "number" || !ch.convert.active) {
        return true;
    }
    if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
        c.helper.warn(c.getInfo(), "Attack Rate (" + effect + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
            ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
        return true;
    }
    ch.convert.macroInstrument.dynamicVoice.attackrate[op] = value & 0x1F;
    ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x50 | (op << 2)));
    ch.convert.instrument = -1;
    return true;
}
function decay1Rate(op, effect, value, ch, c) {
    var _a, _b;
    if (typeof value !== "number" || !ch.convert.active) {
        return true;
    }
    if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
        c.helper.warn(c.getInfo(), "Decay 1 Rate (" + effect + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
            ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
        return true;
    }
    ch.convert.macroInstrument.dynamicVoice.decay1rate[op] = value & 0x1F;
    ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x60 | (op << 2)));
    ch.convert.instrument = -1;
    return true;
}
function decay2Rate(op, effect, value, ch, c) {
    var _a, _b;
    if (typeof value !== "number" || !ch.convert.active) {
        return true;
    }
    if (!((_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.dynamicVoice)) {
        c.helper.warn(c.getInfo(), "Decay 2 Rate (" + effect + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
            ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "! Ignoring...");
        return true;
    }
    ch.convert.macroInstrument.dynamicVoice.decay2rate[op] = value & 0x1F;
    ch.convert.routine.items.push(ch.convert.macroInstrument.dynamicVoice.getYmCommand(0x70 | (op << 2)));
    ch.convert.instrument = -1;
    return true;
}
function totalLevel(op, effect, value, ch, c) {
    var _a;
    if (typeof value !== "number" || !ch.convert.active) {
        return true;
    }
    if (!ch.convert.voice) {
        c.helper.warn(c.getInfo(), "Total level (" + effect + (0, lib_1.hex)(2, value) + ") can not be set when no voice is loaded in " +
            ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + "! Ignoring...");
        return true;
    }
    ch.convert.routine.items.push(new commands_1.SongSetTL(op, value));
    ch.convert.instrument = -1;
    return true;
}
function timingSet(id, value, ch) {
    if (typeof value !== "number" || !ch.convert.active) {
        return true;
    }
    ch.convert.routine.items.push(new commands_1.SongSetTiming(id, value));
    return true;
}
function timingAdd(id, value, ch) {
    if (typeof value !== "number" || !ch.convert.active) {
        return true;
    }
    ch.convert.routine.items.push(new commands_1.SongAddTiming(id, value));
    return true;
}
exports.postEffects = {
    0x6B: (value, ch, c, list, rd) => exports.postEffects[0x0B](value, ch, c, list, rd),
    0x6D: (value, ch, c, list, rd) => exports.postEffects[0x0B](value, ch, c, list, rd),
    0x6F: (value, ch, c, list, rd) => exports.postEffects[0x0B](value, ch, c, list, rd),
    0x0B: (value, ch, c) => {
        var _a;
        if (typeof value !== "number") {
            return true;
        }
        if (value >= c.channels[c.index][0].base.orders.length) {
            c.helper.error(c.getInfo(), "Jump to pattern " + (0, lib_1.hex)(2, value) + " failed because it is past the end of the module in " +
                ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + "!");
            return false;
        }
        if (isNaN(c.convert.breakPattern)) {
            c.convert.jumpPattern = value;
        }
        return true;
    },
    0x0D: (value, ch, c) => {
        if (isNaN(c.convert.jumpPattern) && isNaN(c.convert.breakPattern)) {
            c.convert.breakPattern = value !== null && value !== void 0 ? value : 0;
        }
        return true;
    },
    0xFF: (value, ch, c) => {
        c.convert.breakPattern = value === 0xFF ? -2 : -1;
        c.convert.jumpPattern = NaN;
        return true;
    },
};
