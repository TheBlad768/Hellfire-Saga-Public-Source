"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.optimizeNotes = exports.combineTies = exports.mergeCommands = void 0;
const commands_1 = require("../shared/commands");
const hints_1 = require("../shared/hints");
const notes_1 = require("../shared/notes");
const routines_1 = require("../shared/routines");
const main_1 = require("./main");
function mergeCommands(info) {
    if (!info.opt.mergeCommands) {
        return;
    }
    for (const routine of info.song.routines) {
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        const helper = {
            fracVib: { on: undefined, },
            volVib: { on: undefined, },
            pan: NaN,
            amsfms: NaN,
            opmask: NaN,
            porta: {
                speed: NaN,
                target: NaN,
            },
            dirtyVoice: false,
            dirtyVol: false,
            ymw: {},
        };
        const resetItems = () => {
            let off = 0;
            if (helper.lastVol) {
                if (helper.lastVol.value === 0 && !helper.dirtyVol) {
                    (0, main_1.removeItem)(routine, helper.lastVol);
                    --off;
                }
                helper.lastVol = undefined;
                helper.dirtyVol = false;
            }
            if (helper.lastFrac) {
                if (helper.lastFrac.value === 0) {
                    (0, main_1.removeItem)(routine, helper.lastFrac);
                    --off;
                }
                helper.lastFrac = undefined;
            }
            return off;
        };
        for (let i = 0; i < routine.items.length; i++) {
            const item = routine.items[i];
            if (item instanceof notes_1.SongNote) {
                if (item.note !== notes_1.noteCut) {
                    i += resetItems();
                }
            }
            else if (item.subtype === commands_1.SongCommandSubtype.TargetCommand) {
                if (item instanceof commands_1.SongCall) {
                    helper.fracVib = { on: undefined, };
                    helper.volVib = { on: undefined, };
                    helper.fracEnv = undefined;
                    helper.volEnv = undefined;
                    helper.porta = { speed: NaN, target: NaN, };
                    helper.pan = NaN;
                    helper.opmask = NaN;
                    helper.amsfms = NaN;
                    helper.sample = undefined;
                    helper.voice = undefined;
                    helper.ymw[0x4C] = helper.ymw[0x48] = helper.ymw[0x44] = helper.ymw[0x40] = -1;
                    i += resetItems();
                }
                else if (item instanceof commands_1.SongJump || item instanceof commands_1.SongCont || item instanceof commands_1.SongCall ||
                    item instanceof commands_1.SongCondJump || item instanceof commands_1.SongBitJump) {
                    i += resetItems();
                }
            }
            else if (item.subtype === commands_1.SongCommandSubtype.Hint) {
                if (item instanceof hints_1.SongHintFracReset) {
                    helper.fracEnv = undefined;
                }
            }
            else if (item.subtype === commands_1.SongCommandSubtype.NormalCommand) {
                if (item instanceof commands_1.SongAddVolume) {
                    if (!helper.lastVol) {
                        helper.lastVol = item;
                        helper.ymw[0x4C] = helper.ymw[0x48] = helper.ymw[0x44] = helper.ymw[0x40] = -1;
                    }
                    else {
                        helper.lastVol.value += item.value;
                        routine.items.splice(i, 1);
                        --i;
                    }
                }
                else if (item instanceof commands_1.SongAddFraction) {
                    if (!helper.lastFrac) {
                        helper.lastFrac = item;
                    }
                    else {
                        helper.lastFrac.value += item.value;
                        routine.items.splice(i, 1);
                        --i;
                    }
                }
                else if (item instanceof commands_1.SongSetFractionEnvelope) {
                    if (item.envelope !== helper.fracEnv) {
                        helper.fracEnv = item.envelope;
                    }
                    else {
                        routine.items.splice(i, 1);
                        --i;
                    }
                }
                else if (item instanceof commands_1.SongSetVolumeEnvelope) {
                    if (item.envelope !== helper.volEnv) {
                        helper.volEnv = item.envelope;
                    }
                    else {
                        routine.items.splice(i, 1);
                        --i;
                    }
                }
                else if (item instanceof commands_1.SongSetTremolo) {
                    if (item.vibrato !== helper.volVib.vib) {
                        helper.volVib.vib = item.vibrato;
                        helper.volVib.on = true;
                    }
                    else if (helper.volVib.on) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.volVib.on = true;
                        routine.items[i] = new commands_1.SongEnableTremolo();
                    }
                }
                else if (item instanceof commands_1.SongEnableTremolo) {
                    if (helper.volVib.on) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.volVib.on = true;
                    }
                }
                else if (item instanceof commands_1.SongDisableTremolo) {
                    if (helper.fracVib.on === false) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.volVib.on = false;
                    }
                }
                else if (item instanceof commands_1.SongSetVibrato) {
                    if (item.vibrato !== helper.fracVib.vib) {
                        helper.fracVib.vib = item.vibrato;
                        helper.fracVib.on = true;
                    }
                    else if (helper.fracVib.on) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.fracVib.on = true;
                        routine.items[i] = new commands_1.SongEnableVibrato();
                    }
                }
                else if (item instanceof commands_1.SongEnableVibrato) {
                    if (helper.fracVib.on) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.fracVib.on = true;
                    }
                }
                else if (item instanceof commands_1.SongDisableVibrato) {
                    if (helper.fracVib.on === false) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.fracVib.on = false;
                    }
                }
                else if (item instanceof commands_1.SongSetSample) {
                    if (helper.sample === item.sample) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.sample = item.sample;
                    }
                }
                else if (item instanceof commands_1.SongSetVoice) {
                    if (!helper.dirtyVoice && helper.voice === item.voice) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.voice = item.voice;
                        helper.dirtyVoice = false;
                        helper.dirtyVol = false;
                        helper.amsfms = NaN;
                        helper.ymw = {};
                    }
                }
                else if (item instanceof commands_1.SongPortaSpeed) {
                    if (helper.porta.speed === item.value) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.porta.speed = item.value;
                    }
                }
                else if (item instanceof commands_1.SongPortaTarget) {
                    if (helper.porta.target === item.fraction) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.porta.target = item.fraction;
                    }
                }
                else if (item instanceof commands_1.SongPan) {
                    if (helper.pan === item.value && !routine.flags.unsafePan) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.pan = item.value;
                    }
                }
                else if (item instanceof commands_1.SongSetAMSFMS) {
                    if (helper.amsfms === item.value) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.amsfms = item.value;
                    }
                }
                else if (item instanceof commands_1.SongSetOperatorMask) {
                    if (helper.opmask === item.value) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.opmask = item.value;
                    }
                }
                else if (item instanceof commands_1.SongSetTL) {
                    const reg = item.getRegister();
                    if (helper.ymw[reg] === item.value) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.ymw[reg] = item.value;
                        helper.dirtyVoice = true;
                        helper.dirtyVol = true;
                    }
                }
                else if (item instanceof commands_1.SongYMCommand) {
                    if (helper.ymw[item.reg] === item.value) {
                        routine.items.splice(i, 1);
                        --i;
                    }
                    else {
                        helper.ymw[item.reg] = item.value;
                        helper.dirtyVoice = true;
                        helper.dirtyVol = helper.dirtyVol || (item.reg & 0xF0) === 0x40;
                    }
                }
            }
        }
    }
}
exports.mergeCommands = mergeCommands;
function combineTies(info) {
    var _a;
    if (!info.opt.combineTies) {
        return;
    }
    const canCombine = (root, note) => {
        var _a, _b;
        if (note.tie && !note.note) {
            return true;
        }
        return note.note === root.note && (((_a = root.note) === null || _a === void 0 ? void 0 : _a.name) === "nrst" || ((_b = root.note) === null || _b === void 0 ? void 0 : _b.name) === "ncut");
    };
    for (const routine of info.song.routines) {
        let root;
        for (let i = 0; i < routine.items.length; i++) {
            const item = routine.items[i];
            if (!(item instanceof notes_1.SongNote)) {
                root = undefined;
            }
            else if (!root) {
                root = item;
            }
            else if (typeof item.delay !== "number" || !canCombine(root, item)) {
                root = item;
            }
            else {
                root.delay = ((_a = root.delay) !== null && _a !== void 0 ? _a : 0) + item.delay;
                routine.items.splice(i, 1);
                --i;
            }
        }
    }
}
exports.combineTies = combineTies;
function optimizeNotes(info) {
    if (!info.opt.optimizeNotes) {
        return;
    }
    for (const routine of info.song.routines) {
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        const mode = { portamento: false, };
        let note = null, delay = 0, evilNote = false, dirtyNote = false, porta = 0;
        for (const item of routine.items) {
            if (item instanceof notes_1.SongNote) {
                if (item.delay === delay && delay > 0 && item.note !== null) {
                    item.delay = null;
                    evilNote = true;
                    dirtyNote = porta !== 0;
                    if (item.note && !item.note.isNoise) {
                        note = item.note;
                    }
                }
                else if (note === item.note && note !== null && item.note !== notes_1.noteKey && item.delay !== null && !mode.portamento && !evilNote && !dirtyNote) {
                    item.note = null;
                    if (item.delay) {
                        delay = (item.delay & 0xFF) || 0x100;
                    }
                }
                else {
                    evilNote = false;
                    if (item.note && !item.note.isNoise) {
                        note = item.note;
                        dirtyNote = porta !== 0;
                    }
                    if (item.delay) {
                        delay = (item.delay & 0xFF) || 0x100;
                    }
                }
            }
            else if (item instanceof commands_1.SongCall) {
                note = null;
                delay = 0;
                evilNote = false;
            }
            else if (item instanceof commands_1.SongPortaSpeed) {
                porta = item.value;
                dirtyNote = dirtyNote || porta !== 0;
                evilNote = false;
                mode.portamento = item.value !== 0;
            }
            else if (item instanceof hints_1.SongHintPortamentoMode) {
                mode[item.property] = item.value;
            }
            else {
                evilNote = false;
            }
        }
    }
}
exports.optimizeNotes = optimizeNotes;
