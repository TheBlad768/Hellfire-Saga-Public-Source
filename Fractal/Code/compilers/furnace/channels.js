"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.loadPatterns = exports.getDefaultInfo = exports.loadChannels = exports.SmokerPattern = void 0;
const furnace_module_interface_1 = require("../../shared/furnace-module-interface");
const lib_1 = require("../../shared/lib");
const notes_1 = require("../../shared/notes");
const routines_1 = require("../../shared/routines");
const song_1 = require("../../shared/song");
const library_1 = require("./library");
class SmokerPattern {
    constructor(name) {
        this.rows = [];
        this.name = name;
    }
}
exports.SmokerPattern = SmokerPattern;
function loadChannels(c) {
    c.file.info.systems.forEach((s) => {
        s.chips.forEach((chip) => {
            if (chip instanceof furnace_module_interface_1.FurnaceChipYM2612Extended || chip instanceof furnace_module_interface_1.FurnaceChipYM2612ExtendedWithDualPCM) {
                c.song.getSong(c.index + 1).flags.FM3SM = true;
            }
        });
    });
    let ret = true;
    c.channels[c.index] = [];
    const makeChannel = (ch, index) => {
        var _a;
        if (ch.hidden) {
            return null;
        }
        const type = getChannelType(ch);
        if (type === null) {
            return null;
        }
        if (!ch.hidden && c.channels[c.index].find((cc) => cc.type === type)) {
            c.helper.error(c.getInfo(), "Channel " + song_1.ChannelType[type] + " is used multiple times.");
            ret = false;
            return null;
        }
        const unsafePan = !c.linkFM6 ? false : type === song_1.ChannelType.FM6 || (0, library_1.isDAC)(type);
        const rt = (0, library_1.createRoutine)(c, song_1.ChannelType[type], routines_1.RoutineType.SongTrack, { unsafePan, });
        if (!rt) {
            c.helper.error(c.getInfo(), "Unable to create channel routine " + song_1.ChannelType[type] + "!");
            ret = false;
            return null;
        }
        const channel = new song_1.Channel(type, rt);
        (_a = c.song.getSong(c.index + 1)) === null || _a === void 0 ? void 0 : _a.channels.push(channel);
        return {
            patterns: [], base: ch, type, index,
            operator: getOperator(type),
            channel, convert: getDefaultInfo(c, channel),
        };
    };
    c.channels[c.index] = c.targetSong.getChannels(c.file.info).map(makeChannel).filter((c) => c !== null);
    if (c.linkFM6 !== null) {
        const pdac = c.channels[c.index].find((ch) => ch.type === c.linkFM6);
        if (!pdac) {
            c.helper.error(c.getInfo(), "Unable to find FM6 link channel " + song_1.ChannelType[c.linkFM6] + "!");
            return false;
        }
        const base = pdac.base.makePartialCopy();
        base.longname = "FM6";
        const newch = makeChannel(base, pdac.index);
        if (newch) {
            c.channels[c.index].push(newch);
        }
    }
    return ret;
}
exports.loadChannels = loadChannels;
const getOperator = (type) => type === song_1.ChannelType.FM3o2 ? 1 : type === song_1.ChannelType.FM3o3 ? 2 : type === song_1.ChannelType.FM3o4 ? 3 : 0;
function getChannelType(channel) {
    const getType = (str) => {
        let match = /^(FM 6\/)?(D(AC)?|P(CM)?)\s*#?(\d)\s*([:\-+=(<>|._*?].*)?$/i.exec(str);
        if (match) {
            return [
                song_1.ChannelType.DAC1, song_1.ChannelType.DAC2,
            ][parseInt(match[5], 10) - 1];
        }
        match = /^(CSM|TA|(CSM)?\s*Timer\s*A?)?\s*([:\-+=(<>|._*?].*)?$/i.exec(str);
        if (match) {
            return song_1.ChannelType.TA;
        }
        match = /^F(M)?\s*#?3\s*o(p)?\s*#?(\d)\s*([:\-+=(<>|._*?].*)?$/i.exec(str);
        if (match) {
            return [
                song_1.ChannelType.FM3o1, song_1.ChannelType.FM3o3, song_1.ChannelType.FM3o2, song_1.ChannelType.FM3o4,
            ][parseInt(match[3], 10) - 1];
        }
        match = /^F(M)?\s*#?(\d)\s*([:\-+=(<>|._*?].*)?$/i.exec(str);
        if (match) {
            return [
                song_1.ChannelType.FM1, song_1.ChannelType.FM2, song_1.ChannelType.FM3o1, song_1.ChannelType.FM4, song_1.ChannelType.FM5, song_1.ChannelType.FM6,
            ][parseInt(match[2], 10) - 1];
        }
        match = /^(Square|P(SG)?)\s*#?(\d)\s*([:\-+=(<>|._*?].*)?$/i.exec(str);
        if (match) {
            return [
                song_1.ChannelType.PSG1, song_1.ChannelType.PSG2, song_1.ChannelType.PSG3, song_1.ChannelType.PSG4,
            ][parseInt(match[3], 10) - 1];
        }
        match = /^N(S|O|OISE)?\s*([:\-+=(<>|._*?].*)?$/i.exec(str);
        if (match) {
            return song_1.ChannelType.PSG4;
        }
        return null;
    };
    let type;
    if (channel.longname) {
        type = getType(channel.longname);
        if (type !== null) {
            return type;
        }
    }
    if (channel.shortname) {
        type = getType(channel.shortname);
        if (type !== null) {
            return type;
        }
    }
    return getType(channel.defaultLongname);
}
function getDefaultInfo(c, channel) {
    return {
        instrument: -1, sample: -1, sampleBank: 0, macroFrac: 0, noteFrac: 0, frac: 0, row: 0, tick: 0, detune: 0, noiseModeId: 0,
        lastVolume: 0, lastVolumeStored: 0, patVolume: 0, volumeSlide: 0, volumeSlideTick: Infinity, volumeIsTL: false, hardResetOn: false,
        arpNote: NaN, patFrac: NaN, patNoteReal: NaN, tickDelay: 0, cutDelay: NaN, retrigger: NaN,
        active: true, setActive: true, cut: true, updateVolume: false, updateFrac: false, legato: false,
        resetMacro: false, softNote: false, resetNoteFrac: false, is17: false, pitchedSample: false, volumeSlideSingleTick: false,
        dutyNote: notes_1.noteCut, realNote: notes_1.noteCut, note: notes_1.noteCut,
        extern: {
            note: NaN, tick: NaN,
            arpeggio: undefined, duty: undefined, isPSG3: false,
        },
        speed1: c.targetSong.speed1, speed2: c.targetSong.speed2, setSpeed1: NaN, setSpeed2: NaN,
        noiseMode: 3,
        routine: channel.routine,
        vibrato: {
            mode: 0,
            extDepth: 0x100,
            depth: 0,
            speed: 0,
            update: false,
            enabled: false,
        },
        arpeggio: {
            current: undefined, set: undefined,
            inhibit: false,
            tick: 0,
            phase: 0,
            frac: 0,
        },
        portamento: {
            noteSetsTarget: false, trackMode: false, finished: true, empty: true, update: false, resetSpeed: false,
            isSlide: false, resetOnNextNote: true,
            root: 0, rootFreq: 0,
            target: 0, targetFreq: 0,
            speed: 0, speedFreq: 0,
            frac: 0,
        },
    };
}
exports.getDefaultInfo = getDefaultInfo;
function loadPatterns(c, ch) {
    var _a, _b, _c, _d, _e, _f, _g, _h;
    for (let ix = 0; ix < ch.base.patterns.length; ix++) {
        if (ch.base.patterns[ix]) {
            const pat = ch.base.patterns[ix];
            ch.patterns[ix] = new SmokerPattern((0, lib_1.hex)(4, ix));
            for (let r = 0; r < pat.rows.length; r++) {
                let nid = undefined;
                switch ((_a = pat.rows[r].note) === null || _a === void 0 ? void 0 : _a.note) {
                    case 100:
                        nid = 0x4001;
                        break;
                    case 101:
                        nid = 0x4002;
                        break;
                    case 102:
                        nid = 0x4000;
                        break;
                    case 0:
                    case null:
                    case undefined:
                        nid = undefined;
                        break;
                    default:
                        nid = (((_c = (_b = pat.rows[r].note) === null || _b === void 0 ? void 0 : _b.octave) !== null && _c !== void 0 ? _c : 0) * 0xC) + ((_e = (_d = pat.rows[r].note) === null || _d === void 0 ? void 0 : _d.note) !== null && _e !== void 0 ? _e : 0);
                        break;
                }
                const effects = [];
                for (const e of pat.rows[r].effects) {
                    if (typeof e.id === "number") {
                        effects.push({ id: e.id, value: (_f = e.value) !== null && _f !== void 0 ? _f : undefined, });
                    }
                }
                let volume = (_g = pat.rows[r].volume) !== null && _g !== void 0 ? _g : undefined;
                const instrument = (_h = pat.rows[r].instrument) !== null && _h !== void 0 ? _h : undefined;
                const type = ch.type;
                if (typeof volume === "number") {
                    if ((0, library_1.isPSG)(type) && volume !== 0) {
                        volume = (0xF - volume) * 8;
                    }
                    else {
                        volume = 0x7F - volume;
                    }
                }
                if (effects.length > 0 || typeof nid === "number" || typeof volume === "number" || typeof instrument === "number") {
                    ch.patterns[ix].rows.push({ row: r, note: nid, instrument, volume, effects, });
                }
            }
        }
    }
    return true;
}
exports.loadPatterns = loadPatterns;
