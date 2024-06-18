"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateFrac = exports.calculateFrac = exports.convertPatterns = void 0;
const furnace_module_interface_1 = require("../../shared/furnace-module-interface");
const commands_1 = require("../../shared/commands");
const hints_1 = require("../../shared/hints");
const items_1 = require("../../shared/items");
const lib_1 = require("../../shared/lib");
const notes_1 = require("../../shared/notes");
const routines_1 = require("../../shared/routines");
const song_1 = require("../../shared/song");
const effects_1 = require("./effects");
const library_1 = require("./library");
const tickConvert_1 = require("./tickConvert");
function normalizeChannel(ch) {
    if (ch.convert.frac !== 0) {
        ch.convert.routine.items.push(new commands_1.SongAddFraction(-ch.convert.frac));
        ch.convert.frac = 0;
        ch.convert.updateFrac = true;
    }
    if (ch.convert.volumeIsTL) {
        if (ch.convert.lastVolumeStored !== 0) {
            ch.convert.routine.items.push(new commands_1.SongAddVolume(-ch.convert.lastVolumeStored));
            ch.convert.lastVolumeStored = 0;
            ch.convert.updateVolume = true;
        }
    }
    else if (ch.convert.lastVolume !== 0) {
        ch.convert.routine.items.push(new commands_1.SongAddVolume(-ch.convert.lastVolume));
        ch.convert.lastVolume = 0;
        ch.convert.updateVolume = true;
    }
}
function convertPatterns(c) {
    return __awaiter(this, void 0, void 0, function* () {
        const list = {
            fm1: null, fm2: null, fm4: null, fm5: null, fm6: null,
            fm3o1: null, fm3o2: null, fm3o3: null, fm3o4: null, ta: null,
            dac1: null, dac2: null,
            psg1: null, psg2: null, psg4: null, psg3: null,
        };
        for (const ch of c.channels[c.index]) {
            if (ch.base.hidden) {
                continue;
            }
            switch (ch.type) {
                case song_1.ChannelType.FM1:
                    list.fm1 = ch;
                    break;
                case song_1.ChannelType.FM2:
                    list.fm2 = ch;
                    break;
                case song_1.ChannelType.FM4:
                    list.fm4 = ch;
                    break;
                case song_1.ChannelType.FM5:
                    list.fm5 = ch;
                    break;
                case song_1.ChannelType.FM6:
                    list.fm6 = ch;
                    break;
                case song_1.ChannelType.DAC1:
                    list.dac1 = ch;
                    break;
                case song_1.ChannelType.DAC2:
                    list.dac2 = ch;
                    break;
                case song_1.ChannelType.FM3o1:
                    list.fm3o1 = ch;
                    break;
                case song_1.ChannelType.FM3o2:
                    list.fm3o2 = ch;
                    break;
                case song_1.ChannelType.FM3o3:
                    list.fm3o3 = ch;
                    break;
                case song_1.ChannelType.FM3o4:
                    list.fm3o4 = ch;
                    break;
                case song_1.ChannelType.TA:
                    list.ta = ch;
                    break;
                case song_1.ChannelType.PSG1:
                    list.psg1 = ch;
                    break;
                case song_1.ChannelType.PSG2:
                    list.psg2 = ch;
                    break;
                case song_1.ChannelType.PSG3:
                    list.psg3 = ch;
                    break;
                case song_1.ChannelType.PSG4:
                    list.psg4 = ch;
                    break;
            }
        }
        const stoprt = (0, library_1.createRoutine)(c, "StopJump", routines_1.RoutineType.SongTrack, {});
        if (!stoprt) {
            c.helper.error(c.getInfo(), "Internal error: Song routine StopJump could not be created!");
            return false;
        }
        stoprt.items.push(new commands_1.SongStop());
        const bkrt = (0, library_1.createRoutine)(c, "BackupJump", routines_1.RoutineType.SongTrack, {});
        if (!bkrt) {
            c.helper.error(c.getInfo(), "Internal error: Song routine BackupJump could not be created!");
            return false;
        }
        bkrt.items.push(new commands_1.SongBackup());
        for (let i = 0; i < c.channels[c.index][0].base.orders.length; i++) {
            const firstRow = isNaN(c.convert.breakPattern) ? 0 : c.convert.breakPattern;
            c.convert.breakPattern = NaN;
            c.convert.orderNumber;
            for (const ch of Object.values(list)) {
                if (!ch || ch.base.hidden) {
                    continue;
                }
                normalizeChannel(ch);
                ch.convert.sample = ch.convert.instrument = -1;
                ch.convert.row = firstRow;
                ch.convert.arpNote = NaN;
                const newrt = (0, library_1.createRoutine)(c, song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, i), routines_1.RoutineType.SongTrack, {
                    unsafePan: (0, library_1.checkUnsafePan)(ch.type, list),
                });
                if (!newrt) {
                    c.helper.error(c.getInfo(), "Internal error: Song routine " + song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, i) + " could not be created!");
                    return false;
                }
                ch.convert.routine.items.push(new commands_1.SongJump(newrt));
                ch.convert.routine = newrt;
                ch.convert.pattern = ch.patterns[ch.base.orders[i]];
                if (!ch.convert.pattern) {
                    c.helper.error(c.getInfo(), "Internal error: Song pattern " + ch.base.activeLongname + " " + (0, lib_1.hex)(2, i) + " could not be found!");
                    return false;
                }
            }
            const splits = c.convert.splitNextPattern;
            c.convert.splitNextPattern = [];
            if (!(yield convertOrder(c, list, splits))) {
                return false;
            }
            if (c.convert.breakPattern < 0) {
                break;
            }
            if (!isNaN(c.convert.jumpPattern)) {
                for (const ch of Object.values(list)) {
                    if (!ch) {
                        continue;
                    }
                    normalizeChannel(ch);
                    const rt = (0, library_1.createRoutine)(c, song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.jumpPattern), routines_1.RoutineType.SongTrack, {
                        unsafePan: (0, library_1.checkUnsafePan)(ch.type, list),
                    });
                    if (!rt) {
                        c.helper.error(c.getInfo(), "Internal error: Song routine " + song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.jumpPattern) + " could not be created!");
                        return false;
                    }
                    ch.convert.routine.items.push(new commands_1.SongJump(rt));
                }
                c.convert.jumpPattern = NaN;
            }
        }
        for (const ch of Object.values(list)) {
            if (!ch || ch.base.hidden) {
                continue;
            }
            if (c.convert.breakPattern === -2) {
                ch.convert.routine.items.push(new commands_1.SongBackup());
                return true;
            }
            ch.convert.routine.items.push(new commands_1.SongStop());
        }
        return true;
    });
}
exports.convertPatterns = convertPatterns;
function convertOrder(c, chlist, splits) {
    var _a;
    return __awaiter(this, void 0, void 0, function* () {
        for (let r = 0; r < c.targetSong.rows; r++) {
            scanGlobalPreEffects(c, chlist, r);
            for (const ch of Object.values(chlist)) {
                if (!ch) {
                    continue;
                }
                const flags = {
                    changeNote: false,
                    changeVol: ch.convert.updateVolume,
                    loadNote: false,
                };
                if (splits.includes(r)) {
                    normalizeChannel(ch);
                    const rt = (0, library_1.createRoutine)(c, song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.jumpPattern) + "_Row" + (0, lib_1.hex)(2, r), routines_1.RoutineType.SongTrack, {
                        unsafePan: ch.convert.routine.flags.unsafePan,
                    });
                    if (!rt) {
                        c.helper.error(c.getInfo(), "Internal error: Song routine " +
                            song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.jumpPattern) + "_Row" + (0, lib_1.hex)(2, r) + " could not be created!");
                        return false;
                    }
                    ch.convert.routine.items.push(new commands_1.SongJump(rt));
                    ch.convert.routine = rt;
                }
                const rd = (_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.rows.find((rx) => rx.row === r);
                if (rd) {
                    (0, tickConvert_1.delayToRow)(c, ch, r, 0, false);
                    ch.convert.active = ch.convert.setActive;
                    flags.loadNote = typeof rd.note === "number";
                    updateSpeedRow(ch);
                    scanPreEffects(c, ch, chlist, rd);
                    processTickDelay(c, ch, r, flags);
                    scanPortaEffects(c, ch, chlist, rd);
                    updateNote(c, ch, rd, flags);
                    updatePortamentoValues(ch);
                    yield updateInstrument(c, ch, chlist, rd, flags);
                    updateVolume(ch, rd, flags);
                    resetInstrumentMacros(c, ch);
                    scanMainEffects(c, ch, chlist, rd);
                    updateVibrato(c, ch);
                    updateArpeggio(c, ch, chlist);
                    resetInstrumentMacros(c, ch);
                }
                else if (!isNaN(ch.convert.setSpeed1) || !isNaN(ch.convert.setSpeed2)) {
                    (0, tickConvert_1.delayToRow)(c, ch, r, 0, false);
                    updateSpeedRow(ch);
                }
                yield processNoteChange(c, ch, chlist, r, flags);
                processTargetFrac(ch);
                processVolumeChange(ch, flags);
                if (!isNaN(ch.convert.extern.tick) && ch.convert.extern.tick >= ch.convert.tickDelay) {
                    checkExternCommands(c, ch, r, flags);
                }
                ch.convert.tickDelay = 0;
                ch.convert.extern.tick = NaN;
                scanPostEffects(c, ch, chlist, rd);
                resetInstrumentMacros(c, ch);
                processCutDelay(c, ch, r);
            }
            if (processPatternBreak(c, r)) {
                return true;
            }
        }
        processPatternEnd(c, c.targetSong.rows);
        return true;
    });
}
function updateSpeedRow(ch) {
    if (!isNaN(ch.convert.setSpeed1)) {
        ch.convert.speed1 = ch.convert.setSpeed1;
        ch.convert.setSpeed1 = NaN;
    }
    if (!isNaN(ch.convert.setSpeed2)) {
        ch.convert.speed2 = ch.convert.setSpeed2;
        ch.convert.setSpeed2 = NaN;
    }
}
function updateSpeedBreak(c, row) {
    for (const ch of c.channels[c.index]) {
        if (!ch || ch.base.hidden) {
            continue;
        }
        if (!isNaN(ch.convert.setSpeed1)) {
            (0, tickConvert_1.delayToRow)(c, ch, row, 0, false);
            ch.convert.speed1 = ch.convert.setSpeed1;
            ch.convert.setSpeed1 = NaN;
        }
        if (!isNaN(ch.convert.setSpeed2)) {
            (0, tickConvert_1.delayToRow)(c, ch, row, 0, false);
            ch.convert.speed2 = ch.convert.setSpeed2;
            ch.convert.setSpeed2 = NaN;
        }
    }
}
function updateVibrato(c, ch) {
    var _a;
    if (!ch.convert.vibrato.update || !ch.convert.active) {
        return false;
    }
    ch.convert.vibrato.update = false;
    if (!ch.convert.vibrato.enabled) {
        ch.convert.routine.items.push(new commands_1.SongDisableVibrato());
        return;
    }
    const depth = Math.round(ch.convert.vibrato.depth / 0xF * ch.convert.vibrato.extDepth);
    const speed = Math.round(ch.convert.vibrato.speed / 0x10 * 0x4000);
    const name = (0, lib_1.hex)(4, depth) + "_" + (0, lib_1.hex)(4, speed);
    let vib = c.song.vibrato.find((v) => v.name === name);
    if (!vib) {
        vib = new items_1.Vibrato(name);
        vib.delay = 0;
        vib.start = 0;
        vib.shape = "Sine";
        vib.depth = depth;
        vib.speed = speed;
        c.song.vibrato.push(vib);
        (_a = c.song.vibratoRoutine) === null || _a === void 0 ? void 0 : _a.items.push(vib);
    }
    ch.convert.vibrato.vibrato = vib;
    ch.convert.routine.items.push(new commands_1.SongSetVibrato(vib));
}
function updateArpeggio(c, ch, chlist) {
    var _a;
    if (!ch.convert.arpeggio.set) {
        return;
    }
    if ((0, library_1.isNoise)(ch.type)) {
        if (!chlist.psg3) {
            c.helper.warn(c.getInfo(), "PSG3 channel does not exist, but it's needed for arpeggio effect in " + ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + "!");
        }
        else {
            chlist.psg3.convert.arpeggio.set = ch.convert.arpeggio.set;
            ch.convert.arpeggio.set = undefined;
        }
        return;
    }
    if (!ch.convert.arpeggio.set.enabled) {
        ch.convert.arpeggio.set = undefined;
        ch.convert.arpeggio.current = undefined;
        ch.convert.arpeggio.frac = 0;
        ch.convert.updateFrac = true;
        return;
    }
    ch.convert.arpeggio.current = {
        speed: ch.convert.arpeggio.set.speed,
        frac1: ch.convert.arpeggio.set.frac1,
        frac2: ch.convert.arpeggio.set.frac2,
    };
    if (ch.convert.arpeggio.set.reset) {
        ch.convert.arpeggio.phase = -1;
        ch.convert.arpeggio.frac = 0;
        ch.convert.arpeggio.tick = ch.convert.arpeggio.current.speed;
    }
    ch.convert.arpeggio.set = undefined;
}
function scanGlobalPreEffects(c, chlist, row) {
    var _a;
    for (const ch of Object.values(chlist)) {
        const rd = (_a = ch === null || ch === void 0 ? void 0 : ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.rows.find((rx) => rx.row === row);
        if (rd) {
            for (const fx of rd.effects) {
                if (fx.id in effects_1.globalPreEffects && !effects_1.globalPreEffects[fx.id](fx.value, ch, c, chlist, rd)) {
                    return false;
                }
            }
        }
    }
    return true;
}
function scanPreEffects(c, ch, chlist, rd) {
    for (const fx of rd.effects) {
        if (fx.id in effects_1.preEffects && !effects_1.preEffects[fx.id](fx.value, ch, c, chlist, rd)) {
            return false;
        }
    }
}
function scanPortaEffects(c, ch, chlist, rd) {
    if (typeof rd.note === "number" && rd.note < 0x4000 && ch.convert.portamento.resetOnNextNote) {
        ch.convert.portamento.resetOnNextNote = false;
        ch.convert.portamento.finished = true;
        if (!ch.convert.portamento.trackMode) {
            ch.convert.routine.items.push(new commands_1.SongPortaSpeed(0));
        }
    }
    for (const fx of rd.effects) {
        if (fx.id in effects_1.portaEffects && !effects_1.portaEffects[fx.id](fx.value, ch, c, chlist, rd)) {
            return false;
        }
    }
}
function scanMainEffects(c, ch, chlist, rd) {
    for (const fx of rd.effects) {
        if (fx.id in effects_1.mainEffects && !effects_1.mainEffects[fx.id](fx.value, ch, c, chlist, rd)) {
            return false;
        }
    }
}
function scanPostEffects(c, ch, chlist, rd) {
    var _a;
    for (const fx of (_a = rd === null || rd === void 0 ? void 0 : rd.effects) !== null && _a !== void 0 ? _a : []) {
        if (fx.id in effects_1.postEffects && !effects_1.postEffects[fx.id](fx.value, ch, c, chlist, rd)) {
            return false;
        }
    }
}
function processTickDelay(c, ch, row, flags) {
    if (ch.convert.tickDelay !== 0) {
        const max = [ch.convert.speed1, ch.convert.speed2,][row & 1];
        if (ch.convert.tickDelay < max) {
            if (!isNaN(ch.convert.extern.tick) && ch.convert.extern.tick < ch.convert.tickDelay) {
                checkExternCommands(c, ch, row, flags);
            }
            (0, tickConvert_1.delayToRow)(c, ch, row, ch.convert.tickDelay, false);
        }
    }
}
function checkExternCommands(c, ch, row, flags) {
    var _a, _b, _c, _d;
    (0, tickConvert_1.delayToRow)(c, ch, row, ch.convert.extern.tick, false);
    const sametick = flags.loadNote && ch.convert.extern.tick === ch.convert.tickDelay;
    if (ch.convert.extern.arpeggio && c.helper.options.inaccurateArpeggios === true) {
        const p3null = ((_c = (_b = (_a = ch.convert.macroInstrument) === null || _a === void 0 ? void 0 : _a.getArpeggioMacro(c, ch)) === null || _b === void 0 ? void 0 : _b.envelope.name) !== null && _c !== void 0 ? _c : "Null") === "Null";
        const p4null = ch.convert.extern.arpeggio.envelope.name === "Null";
        if (!ch.convert.cut && !p4null) {
            ch.convert.routine.items.push(new hints_1.SongHintFracReset(), ch.convert.extern.arpeggio);
        }
        else if (!ch.convert.cut && sametick && !p3null) {
            ch.convert.routine.items.push(new hints_1.SongHintFracReset(), (_d = ch.convert.macroInstrument) === null || _d === void 0 ? void 0 : _d.getArpeggioMacro(c, ch));
        }
        else {
            ch.convert.routine.items.push(ch.convert.extern.arpeggio);
        }
        ch.convert.extern.arpeggio = undefined;
    }
    if (!isNaN(ch.convert.extern.note) && ch.convert.portamento.finished) {
        const targetNote = (isNaN(ch.convert.arpNote) || ch.convert.patNoteReal >= 0x4000) ? ch.convert.patNoteReal : ch.convert.arpNote;
        const { frac, note, } = getNote(c, ch, ch.convert.extern.note, ch.convert.noteFrac);
        ch.convert.softNote = !flags.changeNote;
        ch.convert.realNote = ch.convert.note = note;
        ch.convert.noteFrac = frac;
        ch.convert.updateFrac = true;
        ch.convert.resetMacro = true;
        ch.convert.cut = isNaN(targetNote) || targetNote >= 0x4001;
        if (targetNote >= 0x4000) {
            handleNoteOff(c, ch);
        }
        ch.convert.extern.note = NaN;
        flags.changeVol = true;
        processVolumeChange(ch, flags);
    }
}
function updateInstrument(c, ch, chlist, rd, flags) {
    var _a, _b, _c, _d, _e, _f, _g, _h;
    return __awaiter(this, void 0, void 0, function* () {
        if (typeof rd.instrument !== "number" || typeof rd.note !== "number") {
            return;
        }
        const ins = c.instruments[rd.instrument];
        if (!ins) {
            c.helper.warn(c.getInfo(), "Invalid instrument " + (0, lib_1.byte)(rd.instrument) + " was used at " + ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + "!");
        }
        if (ins.type === furnace_module_interface_1.FurnaceInstrumentTypeEnum.Amiga && (0, library_1.isDAC)(ch.type)) {
            ch.convert.setActive = ch.convert.active = true;
            ch.convert.pitchedSample = true;
            if (c.linkFM6 === ch.type && chlist.fm6) {
                chlist.fm6.convert.setActive = chlist.fm6.convert.active = false;
            }
        }
        else if ((0, library_1.isDAC)(ch.type)) {
            ch.convert.pitchedSample = false;
            if (!ch.convert.is17) {
                ch.convert.setActive = ch.convert.active = false;
                if (c.linkFM6 === ch.type && chlist.fm6) {
                    chlist.fm6.convert.setActive = chlist.fm6.convert.active = true;
                }
            }
        }
        if (!ch.convert.active || rd.instrument === ch.convert.instrument) {
            return;
        }
        ch.convert.instrument = rd.instrument;
        {
            const mac = ins.getVolumeMacro(c, ch);
            if (!mac) {
                return false;
            }
            ch.convert.routine.items.push(mac);
        }
        {
            const mac = ins.getArpeggioMacro(c, ch);
            if (!mac) {
                return false;
            }
            if (!(0, library_1.isNoise)(ch.type)) {
                ch.convert.routine.items.push(mac);
            }
            else if (!chlist.psg3) {
                c.helper.warn(c.getInfo(), "PSG3 channel does not exist, but it's needed for an arpeggio macro in " +
                    ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "!");
            }
            else {
                const mac4 = ins.getArpeggioMacroPSG4(c);
                if (!mac4) {
                    return false;
                }
                ch.convert.routine.items.push(mac4);
                chlist.psg3.convert.extern.arpeggio = mac;
            }
        }
        if ((0, library_1.isFM)(ch.type)) {
            const voice = ins.getVoice();
            ch.convert.routine.items.push(voice);
            ch.convert.voice = voice.voice;
            if ((0, library_1.isExtFM)(ch.type)) {
                updateOpVolumeModes(c, chlist, voice.voice);
            }
        }
        else if (ch.convert.pitchedSample && (0, library_1.isDAC)(ch.type)) {
            const sample = ins.sampleRef === null ? null : c.samples[ins.sampleRef];
            if (!sample) {
                c.helper.warn(c.getInfo(), "Amiga sample #" + ((_c = ins.sampleRef) !== null && _c !== void 0 ? _c : "null") + " was requested in " +
                    ch.base.activeLongname + " pattern " + ((_d = ch.convert.pattern) === null || _d === void 0 ? void 0 : _d.name) + ", but not found.");
                return;
            }
            const cvsmp = yield sample.getPitchedSample(c);
            if (!cvsmp) {
                c.helper.error(c.getInfo(), "Amiga sample #" + ((_e = ins.sampleRef) !== null && _e !== void 0 ? _e : "null") + " was requested in " + ch.base.activeLongname + " pattern " + ((_f = ch.convert.pattern) === null || _f === void 0 ? void 0 : _f.name) +
                    ", but could not be converted.");
                return;
            }
            ch.convert.routine.items.push(new commands_1.SongSetSample(cvsmp));
            ch.convert.sample = ins.sampleRef;
        }
        const an = (_h = (_g = ins.macros.arpeggio) === null || _g === void 0 ? void 0 : _g.rootNote) !== null && _h !== void 0 ? _h : NaN;
        if (isNaN(ch.convert.arpNote) !== isNaN(an)) {
            flags.changeNote = true;
        }
        ch.convert.arpNote = an;
        ch.convert.resetMacro = true;
    });
}
function resetInstrumentMacros(c, ch) {
    var _a, _b, _c, _d;
    if (!ch.convert.resetMacro) {
        return;
    }
    ch.convert.resetMacro = false;
    const ins = c.instruments[ch.convert.instrument];
    ch.convert.macroInstrument = ins;
    if (ch.convert.macroInstrument) {
        ch.convert.macroInstrument.dynamicVoice = ins === null || ins === void 0 ? void 0 : ins.makeDynamicVoice();
    }
    (_a = ins === null || ins === void 0 ? void 0 : ins.macros.pan) === null || _a === void 0 ? void 0 : _a.resetMacro();
    (_b = ins === null || ins === void 0 ? void 0 : ins.macros.duty) === null || _b === void 0 ? void 0 : _b.resetMacro();
    (_c = ins === null || ins === void 0 ? void 0 : ins.macros.pitch) === null || _c === void 0 ? void 0 : _c.resetMacro();
    (_d = ins === null || ins === void 0 ? void 0 : ins.macros.arpeggio) === null || _d === void 0 ? void 0 : _d.resetMacro();
    ins === null || ins === void 0 ? void 0 : ins.macros.ops.forEach((o) => o.resetMacro());
    ch.convert.macroFrac = 0;
}
function updateOpVolumeModes(c, chlist, voice) {
    var _a;
    if (((_a = c.song.getSong(c.index + 1)) === null || _a === void 0 ? void 0 : _a.flags.FM3SM) !== true) {
        return;
    }
    for (let i = 0; i < 4; i++) {
        const ch = [chlist.fm3o1, chlist.fm3o2, chlist.fm3o3, chlist.fm3o4,][i];
        if (!ch) {
            continue;
        }
        if (ch.convert.volumeIsTL === voice.slot[i]) {
            ch.convert.volumeIsTL = !voice.slot[i];
            if (ch.convert.volumeIsTL) {
                ch.convert.lastVolumeStored = ch.convert.lastVolume;
                ch.convert.lastVolume = -1;
            }
            else {
                ch.convert.lastVolume = ch.convert.lastVolumeStored;
            }
            ch.convert.updateVolume = true;
        }
        if (ch.convert.volumeIsTL) {
            ch.convert.updateVolume = true;
        }
    }
}
function updateVolume(ch, rd, flags) {
    if (!ch.convert.active || typeof rd.volume !== "number") {
        return;
    }
    flags.changeVol = true;
    ch.convert.patVolume = rd.volume;
    processVolumeChange(ch, flags);
}
function processVolumeChange(ch, flags) {
    var _a, _b;
    if (!flags.changeVol) {
        return;
    }
    if (ch.convert.volumeIsTL && ch.convert.cut) {
        return;
    }
    const vol = ch.convert.cut ? 0x7F : ch.convert.patVolume;
    const off = vol - ch.convert.lastVolume;
    ch.convert.updateVolume = false;
    flags.changeVol = false;
    if (off !== 0) {
        ch.convert.lastVolume = vol;
        ch.convert.routine.items.push(ch.convert.volumeIsTL ? new commands_1.SongSetTL(ch.operator, vol + ((_b = (_a = ch.convert.voice) === null || _a === void 0 ? void 0 : _a.totallevel[ch.operator]) !== null && _b !== void 0 ? _b : 0)) : new commands_1.SongAddVolume(off));
    }
}
function updatePortamentoValues(ch) {
    if (!ch.convert.portamento.update || ch.convert.portamento.empty) {
        ch.convert.portamento.update = false;
        return;
    }
    ch.convert.portamento.update = false;
    const target = (0, tickConvert_1.computePortaTarget)(ch);
    const spd = (ch.convert.portamento.targetFreq < ch.convert.portamento.rootFreq ? -1 : 1) * ch.convert.portamento.speed;
    ch.convert.routine.items.push(new commands_1.SongPortaSpeed(Math.max(-0x7FFF, Math.min(0x7FFF, spd))));
    ch.convert.routine.items.push(new commands_1.SongPortaTarget(target - (ch.convert.resetNoteFrac ? 0 : ch.convert.noteFrac)));
}
function updateNote(c, ch, rd, flags) {
    if (typeof rd.note !== "number") {
        return;
    }
    const checkEmpty = () => {
        if (ch.convert.portamento.finished && !ch.convert.portamento.empty && !ch.convert.portamento.trackMode) {
            ch.convert.portamento.empty = true;
            ch.convert.routine.items.push(new commands_1.SongPortaSpeed(0));
        }
    };
    const updateRoot = () => {
        var _a;
        ch.convert.portamento.root = ch.convert.patNoteReal = (_a = rd.note) !== null && _a !== void 0 ? _a : 0;
        ch.convert.patFrac = ch.convert.patNoteReal << 8;
        ch.convert.portamento.rootFreq = (0, tickConvert_1.convertFrequencySpace)(ch, (0, notes_1.calcRawFreq)(ch.convert.patFrac - (ch.convert.resetNoteFrac ? 0 : ch.convert.noteFrac), ch.type));
        flags.changeNote = true;
        const target = (0, tickConvert_1.computePortaTarget)(ch);
        ch.convert.portamento.targetFreq = (0, tickConvert_1.convertFrequencySpace)(ch, (0, notes_1.calcRawFreq)(target, ch.type));
        ch.convert.portamento.update = !ch.convert.portamento.trackMode;
    };
    const wasRest = isNaN(ch.convert.patNoteReal) || ch.convert.patNoteReal >= 0x4000;
    if (!ch.convert.portamento.finished && ch.convert.portamento.noteSetsTarget && rd.note < 0x4000) {
        ch.convert.portamento.target = rd.note << 8;
        ch.convert.portamento.targetFreq = (0, tickConvert_1.convertFrequencySpace)(ch, (0, notes_1.calcRawFreq)((rd.note << 8) - (ch.convert.resetNoteFrac ? 0 : ch.convert.noteFrac), ch.type));
        ch.convert.arpeggio.inhibit = true;
        ch.convert.updateFrac = false;
        ch.convert.portamento.update = !ch.convert.portamento.trackMode;
        if (wasRest) {
            ch.convert.patFrac = rd.note << 8;
            ch.convert.patNoteReal = rd.note;
            flags.changeNote = true;
        }
    }
    else if (!ch.convert.portamento.finished) {
        if (rd.note >= 0x4000) {
            if (!ch.convert.portamento.isSlide) {
                if (c.file.info.flags.noteOffResetsSlides === true) {
                    if (c.file.info.flags.targetResetsSlides === true) {
                        ch.convert.portamento.resetOnNextNote = true;
                    }
                    else {
                        if (!ch.convert.portamento.trackMode) {
                            ch.convert.routine.items.push(new commands_1.SongPortaSpeed(0));
                        }
                        ch.convert.portamento.finished = true;
                    }
                }
            }
            flags.changeNote = true;
            ch.convert.patNoteReal = rd.note;
        }
        else {
            updateRoot();
            if (wasRest) {
                ch.convert.patFrac = ch.convert.patNoteReal << 8;
                flags.changeNote = true;
            }
        }
    }
    else if (!ch.convert.portamento.empty && ch.convert.portamento.isSlide) {
        checkEmpty();
        updateRoot();
        if (wasRest) {
            ch.convert.patFrac = ch.convert.patNoteReal << 8;
            flags.changeNote = true;
        }
    }
    else {
        flags.changeNote = true;
        ch.convert.patNoteReal = rd.note;
        if (rd.note < 0x4000) {
            ch.convert.patFrac = rd.note << 8;
        }
        checkEmpty();
    }
    if (ch.convert.cut) {
        flags.changeVol = true;
    }
}
function updatePSG3Macros(c, ch, chlist) {
    var _a, _b;
    const arp = (_a = c.instruments[ch.convert.instrument]) === null || _a === void 0 ? void 0 : _a.getArpeggioMacro(c, ch);
    if (chlist.psg3 && arp) {
        chlist.psg3.convert.extern.arpeggio = arp;
    }
    const duty = (_b = c.instruments[ch.convert.instrument]) === null || _b === void 0 ? void 0 : _b.macros.duty;
    if (chlist.psg3 && duty) {
        chlist.psg3.convert.extern.duty = duty;
    }
}
function processNoteChange(c, ch, chlist, row, flags) {
    var _a, _b, _c, _d;
    return __awaiter(this, void 0, void 0, function* () {
        if (!ch.convert.active) {
            return;
        }
        if (flags.changeNote) {
            const targetNote = (isNaN(ch.convert.arpNote) || ch.convert.patNoteReal >= 0x4000) ? ch.convert.patNoteReal : ch.convert.arpNote;
            if (!ch.convert.pitchedSample && targetNote < 0x4000 && (0, library_1.isDAC)(ch.type)) {
                ch.convert.realNote = ch.convert.note = notes_1.noteSample;
                const targetSample = (ch.convert.sampleBank * 0xC) + ((targetNote + 0xC0) % 0xC);
                const sample = yield c.samples[targetSample].getSample(c);
                if (!sample) {
                    c.helper.warn(c.getInfo(), "DAC1 channel attempted to play sample " + fetchNote(c, targetNote).name + " (bank " + ch.convert.sampleBank + ") in " +
                        ch.base.activeLongname + " pattern " + ((_a = ch.convert.pattern) === null || _a === void 0 ? void 0 : _a.name) + ", but it doesn't exist! Ignoring...");
                }
                else if (targetSample !== ch.convert.sample) {
                    ch.convert.routine.items.push(new commands_1.SongSetSample(sample));
                    ch.convert.sample = targetSample;
                }
                ch.convert.cut = false;
                flags.changeVol = true;
                ch.convert.resetMacro = true;
                ch.convert.softNote = false;
            }
            else if (targetNote < 0x4000 && (0, library_1.isNoise)(ch.type)) {
                if ((ch.convert.noiseMode & 1) !== 0) {
                    if (!chlist.psg3) {
                        c.helper.warn(c.getInfo(), "PSG3 channel does not exist, but it's needed for notes in " + ch.base.activeLongname + " pattern " + ((_b = ch.convert.pattern) === null || _b === void 0 ? void 0 : _b.name) + "!");
                    }
                    else {
                        (0, tickConvert_1.delayToRow)(c, chlist.psg3, row, 0, false);
                        chlist.psg3.convert.extern.note = ch.convert.patNoteReal;
                        chlist.psg3.convert.extern.tick = ch.convert.tickDelay;
                        ch.convert.realNote = ch.convert.dutyNote = ch.convert.note = (_c = (0, notes_1.getNoteByName)(ch.convert.noiseMode & 2 ? "nWhitePSG3" : "nPeriPSG3")) !== null && _c !== void 0 ? _c : notes_1.noteCut;
                        ch.convert.noteFrac = 0;
                        updatePSG3Macros(c, ch, chlist);
                    }
                }
                else {
                    const lut = ch.convert.noiseMode & 2 ? ["nWhite40", "nWhite20", "nWhite10",] : ["nPeri40", "nPeri20", "nPeri10",];
                    if (lut[targetNote % 0xC]) {
                        ch.convert.realNote = ch.convert.dutyNote = ch.convert.note = (_d = (0, notes_1.getNoteByName)(lut[targetNote % 0xC])) !== null && _d !== void 0 ? _d : notes_1.noteCut;
                        if (ch.convert.note !== notes_1.noteCut) {
                            ch.convert.noiseModeId = targetNote % 0xC;
                        }
                    }
                    else {
                        ch.convert.realNote = ch.convert.dutyNote = ch.convert.note = notes_1.noteCut;
                    }
                    ch.convert.noteFrac = 0;
                }
                if (c.helper.options.inaccurateArpeggios !== false) {
                    updatePSG3Macros(c, ch, chlist);
                }
                ch.convert.cut = false;
                flags.changeVol = true;
                ch.convert.updateFrac = true;
                ch.convert.resetMacro = true;
                ch.convert.softNote = false;
            }
            else {
                const { frac, note, } = getNote(c, ch, targetNote, ch.convert.noteFrac);
                ch.convert.realNote = ch.convert.note = note;
                ch.convert.noteFrac = frac;
                ch.convert.updateFrac = true;
                ch.convert.softNote = false;
                ch.convert.cut = targetNote >= (((0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA) ? 0x4001 : 0x4002);
                flags.changeVol = true;
                if (targetNote >= 0x4000) {
                    ch.convert.resetMacro = true;
                    handleNoteOff(c, ch);
                }
            }
        }
    });
}
function getNote(c, ch, note, frac) {
    switch (note) {
        case 0x4000: return { frac: frac, note: notes_1.noteRest, };
        case 0x4001: return { frac: frac, note: ((0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA) ? notes_1.noteCut : notes_1.noteRest, };
        case 0x4002: return { frac: frac, note: notes_1.noteCut, };
    }
    let nn = note;
    switch (ch.type) {
        case song_1.ChannelType.FM1:
        case song_1.ChannelType.FM2:
        case song_1.ChannelType.FM4:
        case song_1.ChannelType.FM5:
        case song_1.ChannelType.FM6:
        case song_1.ChannelType.FM3o1:
        case song_1.ChannelType.FM3o2:
        case song_1.ChannelType.FM3o3:
        case song_1.ChannelType.FM3o4:
            if (note < -0x3C || note > 0x6C) {
                c.helper.error(c.getInfo(), "Invalid FM note " + (0, lib_1.word)(note) + " was encountered.");
                return { frac: frac, note: notes_1.noteCut, };
            }
            if (note > 0x60) {
                nn = 0x60;
            }
            break;
        case song_1.ChannelType.DAC1:
        case song_1.ChannelType.DAC2:
            if (note < -0x61 || note > 0x6C) {
                c.helper.error(c.getInfo(), "Invalid DAC note " + (0, lib_1.word)(note) + " was encountered.");
                return { frac: frac, note: notes_1.noteCut, };
            }
            if (note > 0x60) {
                nn = 0x60;
            }
            break;
        case song_1.ChannelType.PSG1:
        case song_1.ChannelType.PSG2:
        case song_1.ChannelType.PSG3:
        case song_1.ChannelType.PSG4:
            if (note < 0) {
                c.helper.error(c.getInfo(), "Invalid PSG note " + (0, lib_1.word)(note) + " was encountered.");
                return { frac: frac, note: notes_1.noteCut, };
            }
            if (note > 0x5E) {
                nn = 0x5E;
            }
            break;
        case song_1.ChannelType.TA:
            if (note < 0) {
                c.helper.error(c.getInfo(), "Invalid TA note " + (0, lib_1.word)(note) + " was encountered.");
                return { frac: frac, note: notes_1.noteCut, };
            }
            if (note >= notes_1.maxNoteTA) {
                nn = notes_1.maxNoteTA - 1;
            }
            break;
        default:
            return { frac: frac, note: notes_1.noteCut, };
    }
    let ff = (ch.convert.resetNoteFrac ? 0 : frac);
    let offs = nn - (ff >> 8);
    ch.convert.resetNoteFrac = false;
    while (offs < 0 || offs > 0x80 - notes_1.firstRealNote) {
        if (offs > 0) {
            ff += (0xC * 2) << 8;
        }
        else {
            ff -= (0xC * 2) << 8;
        }
        offs = nn - (ff >> 8);
    }
    return { frac: ff, note: fetchNote(c, offs), };
}
function fetchNote(c, note) {
    var _a;
    if (note < 0 || note > 0x7F) {
        c.helper.error(c.getInfo(), "Unknown error: Invalid note getNoteString(" + (0, lib_1.word)(note) + ")!");
        return notes_1.noteCut;
    }
    return (_a = (0, notes_1.getNoteByID)(note + notes_1.firstRealNote)) !== null && _a !== void 0 ? _a : notes_1.noteCut;
}
function handleNoteOff(c, ch) {
}
function processTargetFrac(ch) {
    if (!ch.convert.updateFrac) {
        return;
    }
    ch.convert.updateFrac = false;
    updateFrac(ch);
}
function calculateFrac(ch) {
    const _arp = ch.convert.arpeggio.inhibit ? 0 : ch.convert.arpeggio.frac;
    const _porta = ch.convert.portamento.empty ? 0 : ch.convert.portamento.frac;
    return ch.convert.noteFrac + ch.convert.detune + ch.convert.macroFrac + _arp + _porta;
}
exports.calculateFrac = calculateFrac;
function updateFrac(ch) {
    const targetFrac = calculateFrac(ch);
    const diff = targetFrac - ch.convert.frac;
    if (diff === 0) {
        return false;
    }
    ch.convert.frac = targetFrac;
    ch.convert.routine.items.push(new commands_1.SongAddFraction(diff));
    return true;
}
exports.updateFrac = updateFrac;
function processCutDelay(c, ch, r) {
    if (isNaN(ch.convert.cutDelay)) {
        return;
    }
    if (ch.convert.cutDelay < [ch.convert.speed1, ch.convert.speed2,][r & 1]) {
        (0, tickConvert_1.delayToRow)(c, ch, r, ch.convert.cutDelay + ch.convert.tick, false);
        ch.convert.note = ((0, library_1.isPSG)(ch.type) || ch.type === song_1.ChannelType.TA) ? notes_1.noteCut : notes_1.noteRest;
    }
    ch.convert.cutDelay = NaN;
}
function processPatternBreak(c, row) {
    if (isNaN(c.convert.breakPattern) && isNaN(c.convert.jumpPattern)) {
        return false;
    }
    for (const ch of c.channels[c.index]) {
        if (!ch || ch.base.hidden) {
            continue;
        }
        (0, tickConvert_1.delayToRow)(c, ch, row + 1, 0, false);
        if (c.convert.jumpMode === 0) {
            if (!ch.convert.portamento.empty && !ch.convert.portamento.trackMode) {
                ch.convert.portamento.empty = true;
                ch.convert.routine.items.push(new commands_1.SongPortaSpeed(0));
            }
        }
        else {
            processSpecialJumps(c, ch);
        }
    }
    if (c.convert.jumpMode === 0) {
        return true;
    }
    else {
        c.convert.breakPattern = NaN;
        c.convert.jumpPattern = NaN;
        c.convert.jumpMode = 0;
    }
    return false;
}
function processPatternEnd(c, row) {
    for (const ch of c.channels[c.index]) {
        if (!ch || ch.base.hidden) {
            continue;
        }
        (0, tickConvert_1.delayToRow)(c, ch, row, 0, false);
    }
}
function processSpecialJumps(c, ch) {
    let target;
    if (c.convert.breakPattern === -1) {
        target = "StopJump";
    }
    else if (c.convert.breakPattern === -2) {
        target = "BackupJump";
    }
    else if (!isNaN(c.convert.breakPattern)) {
        if (c.convert.breakPattern > 0) {
            c.convert.splitNextPattern.push(c.convert.breakPattern);
            target = song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.orderNumber + 1) + "_Row" + (0, lib_1.hex)(2, c.convert.breakPattern);
        }
        else {
            target = song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.orderNumber + 1);
        }
    }
    else if (!isNaN(c.convert.jumpPattern)) {
        target = song_1.ChannelType[ch.type] + "_" + (0, lib_1.hex)(2, c.convert.jumpPattern);
    }
    else {
        c.helper.error(c.getInfo(), "Internal error: Could not generate a jump target for special jump.");
        return false;
    }
    normalizeChannel(ch);
    const rt = (0, library_1.createRoutine)(c, target, routines_1.RoutineType.SongTrack, { unsafePan: false, });
    if (!rt) {
        c.helper.error(c.getInfo(), "Internal error: Song routine " + target + " could not be created!");
        return false;
    }
    switch (c.convert.jumpMode) {
        case 0x10:
            ch.convert.routine.items.push(new hints_1.SongHintNoOptimize(), new commands_1.SongCont(rt), new hints_1.SongHintNoOptimize());
            break;
        case 0x20:
            ch.convert.routine.items.push(new hints_1.SongHintNoOptimize(), new commands_1.SongCondJump(rt, c.convert.timingIndex, c.convert.timingValue), new hints_1.SongHintNoOptimize());
            break;
        case 0x30:
            ch.convert.routine.items.push(new hints_1.SongHintNoOptimize(), new commands_1.SongBitJump(rt, c.convert.timingValue & 7, c.convert.timingIndex), new hints_1.SongHintNoOptimize());
            break;
    }
    return true;
}
