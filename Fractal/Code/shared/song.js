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
exports.Channel = exports.SongLabel = exports.convertMainFlags = exports.GetRoutineReturnType = exports.CompiledSong = exports.CommandSong = exports.channeListAll = exports.channeListFMAll = exports.channeListFMSpecial = exports.channeListFMNormal = exports.channeListDAC = exports.channeListPSG = exports.ChannelType = void 0;
const includer_1 = require("../includer");
const envelopes_1 = require("./envelopes");
const lib_1 = require("./lib");
const notes_1 = require("./notes");
const routines_1 = require("./routines");
const samples_1 = require("./samples");
var ChannelType;
(function (ChannelType) {
    ChannelType[ChannelType["FM1"] = 0] = "FM1";
    ChannelType[ChannelType["FM2"] = 1] = "FM2";
    ChannelType[ChannelType["FM4"] = 2] = "FM4";
    ChannelType[ChannelType["FM5"] = 3] = "FM5";
    ChannelType[ChannelType["FM6"] = 4] = "FM6";
    ChannelType[ChannelType["FM3o1"] = 5] = "FM3o1";
    ChannelType[ChannelType["FM3o2"] = 6] = "FM3o2";
    ChannelType[ChannelType["FM3o3"] = 7] = "FM3o3";
    ChannelType[ChannelType["FM3o4"] = 8] = "FM3o4";
    ChannelType[ChannelType["TA"] = 9] = "TA";
    ChannelType[ChannelType["PSG1"] = 10] = "PSG1";
    ChannelType[ChannelType["PSG2"] = 11] = "PSG2";
    ChannelType[ChannelType["PSG3"] = 12] = "PSG3";
    ChannelType[ChannelType["PSG4"] = 13] = "PSG4";
    ChannelType[ChannelType["DAC1"] = 14] = "DAC1";
    ChannelType[ChannelType["DAC2"] = 15] = "DAC2";
})(ChannelType = exports.ChannelType || (exports.ChannelType = {}));
exports.channeListPSG = [ChannelType.PSG1, ChannelType.PSG2, ChannelType.PSG3, ChannelType.PSG4,];
exports.channeListDAC = [ChannelType.DAC1, ChannelType.DAC2,];
exports.channeListFMNormal = [ChannelType.FM1, ChannelType.FM2, ChannelType.FM4, ChannelType.FM5, ChannelType.FM6,];
exports.channeListFMSpecial = [ChannelType.FM3o1, ChannelType.FM3o2, ChannelType.FM3o3, ChannelType.FM3o4,];
exports.channeListFMAll = [...exports.channeListFMNormal, ...exports.channeListFMSpecial,];
exports.channeListAll = [...exports.channeListFMAll, ChannelType.TA, ...exports.channeListDAC, ...exports.channeListPSG,];
class CommandSong {
    constructor() {
        this.sfx = false;
        this.songs = {};
        this.moduleId = (0, lib_1.generateID)();
        this.delayUses = [];
    }
    addSong(index, routine) {
        if (this.songs[index]) {
            throw new Error("Song with index " + (0, lib_1.word)(index) + " already defined!");
        }
        this.songs[index] = {
            sfx: false, id: (0, lib_1.generateID)(), routine,
        };
        return index;
    }
    getVoiceNames() {
        return [];
    }
    getSampleNames() {
        return [];
    }
    getVibratoNames() {
        return [];
    }
    getEnvelopeNames() {
        return [];
    }
    getLabels() {
        return [];
    }
    save(write) {
        return __awaiter(this, void 0, void 0, function* () {
            for (const item of Object.values(this.songs)) {
                yield write("snddata_" + item.id + ":\n");
                yield write("\tdc.l (0xFF)<<24+" + item.routine + "\n");
            }
        });
    }
}
exports.CommandSong = CommandSong;
class CompiledSong {
    constructor() {
        this.errors = 0;
        this.songs = {};
        this.moduleId = (0, lib_1.generateID)();
        this.delayUses = new Array(0x100).fill(0);
        this.voiceRoutine = null;
        this.sampleRoutine = null;
        this.vibratoRoutine = null;
        this.envelopeRoutine = null;
        this.vibrato = [];
        this.samples = [];
        this.voices = [];
        this.envelopes = [new envelopes_1.Envelope("Null", new routines_1.SongEnvelopeTrackRoutine(new SongLabel(""), true, {})),];
        this.labels = [];
        this.routines = [];
        this.sampleIncludes = [];
    }
    addSong(index, sfx, tempo, priority) {
        if (this.songs[index]) {
            throw new Error("Song with index " + (0, lib_1.word)(index) + " already defined!");
        }
        this.songs[index] = {
            sfx, priority, tempo,
            id: (0, lib_1.generateID)(),
            channels: [],
            flags: {
                BlockUW: false,
                PAL: false,
                FM3SM: false,
                NoMasterFrac: false,
                NoMasterVol: false,
                Continuous: false,
                Backup: false,
            },
        };
        return index;
    }
    getSong(index) {
        const res = Object.entries(this.songs).filter((s) => parseInt(s[0], 10) === index)[0];
        return res ? res[1] : undefined;
    }
    getSongLabels() {
        return Object.values(this.songs).map((v) => "snddat_" + v.id);
    }
    getVoiceNames() {
        return this.voices.map((v) => v.name);
    }
    getSampleNames() {
        return this.samples.map((v) => v.name);
    }
    getVibratoNames() {
        return this.vibrato.map((v) => v.name);
    }
    getEnvelopeNames() {
        return this.envelopes.map((v) => v.name);
    }
    getLabels() {
        return this.labels.map((v) => v.name);
    }
    fixLabels() {
        const len = this.labels.length;
        this.labels = [];
        for (const rt of this.routines) {
            this.labels.push(rt.label);
        }
        if (len !== this.labels.length) {
            throw new Error("Failed to reorder labels: Missing some labels!!! :(");
        }
    }
    setFlags(flags, index) {
        for (let i = 0; i < flags.length; i++) {
            switch (flags[i]) {
                case "3":
                    this.songs[index].flags.FM3SM = true;
                    break;
                case "u":
                case "U":
                    this.songs[index].flags.BlockUW = true;
                    break;
                case "5":
                    this.songs[index].flags.PAL = true;
                    break;
                case "c":
                    this.songs[index].flags.Continuous = true;
                    break;
                case "f":
                    this.songs[index].flags.NoMasterFrac = true;
                    break;
                case "v":
                    this.songs[index].flags.NoMasterVol = true;
                    break;
                case "b":
                    this.songs[index].flags.Backup = true;
                    break;
                default:
                    throw new Error("Invalid flag " + flags[i] + "!");
            }
        }
    }
    save(write) {
        var _a, _b, _c, _d;
        return __awaiter(this, void 0, void 0, function* () {
            if (this.voices.length > 0) {
                yield write(this.voices.map((v, i) => (0, lib_1.makeEquate)(v.getEquate(this), 32, (0, lib_1.byte)(i))).join(""));
            }
            if (this.samples.length > 0) {
                yield write(this.samples.map((v, i) => (0, lib_1.makeEquate)(v.getEquate(this), 32, (0, lib_1.byte)(i))).join(""));
            }
            if (this.vibrato.length > 0) {
                yield write(this.vibrato.map((v, i) => (0, lib_1.makeEquate)(v.getEquate(this), 32, (0, lib_1.byte)(i))).join(""));
            }
            if (this.envelopes.length > 0) {
                yield write(this.envelopes.map((v, i) => (0, lib_1.makeEquate)(v.getEquate(this), 32, (0, lib_1.byte)(i * 2))).join(""));
            }
            for (const song of Object.entries(this.songs)) {
                yield write("\t" + includer_1.assemblerSettings.even + "\n");
                yield write("snddata_" + song[1].id + ":\n");
                yield write("\tdc.l (" + (+song[1].sfx) + ")<<24+" + ((_a = this.voiceRoutine) === null || _a === void 0 ? void 0 : _a.label.name) + "\n");
                yield write("\tdc.l (0x" + (0, lib_1.hex)(2, isNaN(song[1].priority) ? 0 : song[1].priority) + ")<<24+" + ((_b = this.sampleRoutine) === null || _b === void 0 ? void 0 : _b.label.name) + "\n");
                yield write("\tdc.l (" + this.getFlags(parseInt(song[0], 10)) + ")<<24+" + ((_c = this.vibratoRoutine) === null || _c === void 0 ? void 0 : _c.label.name) + "\n");
                yield write("\tdc.l (0x00)<<24+" + ((_d = this.envelopeRoutine) === null || _d === void 0 ? void 0 : _d.label.name) + "\n");
                if (!song[1].sfx) {
                    yield write("\tdc.w 0x10*0x" + (0, lib_1.hex)(4, song[1].tempo) + ",0x10*0x" + (0, lib_1.hex)(4, song[1].flags.PAL ? song[1].tempo : Math.round(song[1].tempo / 50 * 60)) + "\n");
                }
                for (const ch of song[1].channels) {
                    yield write("\tdc.l (clt" + ChannelType[ch.type] + ")<<24+" + ch.routine.label.name + "\n");
                }
                yield write("\tdc.b 0xFF\n");
            }
            for (const d of this.routines) {
                const lines = d.getLines(this, false);
                if (lines.length) {
                    yield write(lines.join("\n") + "\n");
                }
            }
        });
    }
    getFlags(index) {
        const f = [];
        if (this.songs[index].flags.BlockUW) {
            f.push("1<<stfNoUW");
        }
        if (this.songs[index].flags.NoMasterFrac) {
            f.push("1<<stfNoMasterFreq");
        }
        if (this.songs[index].flags.NoMasterVol) {
            f.push("1<<stfNoMasterVol");
        }
        if (this.songs[index].flags.FM3SM) {
            f.push("1<<stfFM3");
        }
        if (this.songs[index].flags.Continuous) {
            f.push("1<<stfCont");
        }
        if (this.songs[index].flags.Backup) {
            f.push("1<<stfBackup");
        }
        return f.join("|") || "0";
    }
    getOrMakeLabel(name) {
        const match = CompiledSong.checkLabel.exec(name);
        if (!match) {
            return null;
        }
        const lab = this.labels.find((label) => { var _a; return label.name.toLowerCase() === ((_a = match[1]) === null || _a === void 0 ? void 0 : _a.toLowerCase()); });
        if (lab) {
            return lab;
        }
        const newlab = new SongLabel(name);
        this.labels.push(newlab);
        return newlab;
    }
    getOrMakeRoutine(name, type, external, flags) {
        let routine = this.routines.find((rt) => rt.label.name.toLowerCase() === name.toLowerCase());
        if (routine) {
            if (routine.type === type) {
                return { type: GetRoutineReturnType.Success, routine, };
            }
            return { type: GetRoutineReturnType.WrongType, };
        }
        const newlab = this.getOrMakeLabel(name);
        if (!newlab) {
            return { type: GetRoutineReturnType.InvalidLabel, };
        }
        switch (type) {
            case routines_1.RoutineType.EnvelopeTrack:
                routine = new routines_1.SongEnvelopeTrackRoutine(newlab, external, flags);
                break;
            case routines_1.RoutineType.Envelope:
                routine = new routines_1.SongEnvelopeRoutine(newlab, external, flags);
                break;
            case routines_1.RoutineType.SongTrack:
                routine = new routines_1.SongTrackRoutine(newlab, external, flags);
                break;
            case routines_1.RoutineType.Vibrato:
                routine = new routines_1.SongVibratoRoutine(newlab, external, flags);
                break;
            case routines_1.RoutineType.Voice:
                routine = new routines_1.SongVoiceRoutine(newlab, external, flags);
                break;
            case routines_1.RoutineType.Sample:
                routine = new routines_1.SongSampleRoutine(newlab, external, flags);
                break;
        }
        if (!routine) {
            return { type: GetRoutineReturnType.UnknownType, };
        }
        this.routines.push(routine);
        return { type: GetRoutineReturnType.Success, routine, };
    }
    getRoutine(name) {
        return this.routines.find((rt) => rt.label.name.toLowerCase() === name.toLowerCase());
    }
    addSample(labelStart, labelEnd, buffer, start, length, sampleRate, format, id) {
        return __awaiter(this, void 0, void 0, function* () {
            const file = yield (0, samples_1.createSample)(labelStart, labelEnd, buffer, start, length, sampleRate, format, id);
            if (!file) {
                return null;
            }
            const inc = this.sampleIncludes.find((s) => s.file === file);
            if (!inc) {
                this.sampleIncludes.push({ file, start: [labelStart,], end: [labelEnd,], });
            }
            else {
                if (!inc.start.includes(labelStart)) {
                    inc.start.push(labelStart);
                }
                if (!inc.end.includes(labelEnd)) {
                    inc.end.push(labelEnd);
                }
            }
            return file;
        });
    }
    loadDelays() {
        this.delayUses = new Array(0x100).fill(0);
        for (const r of this.routines) {
            for (const i of r.items) {
                if (i instanceof notes_1.SongNote && i.delay) {
                    this.delayUses[i.delay & 0xFF]++;
                }
            }
        }
    }
}
exports.CompiledSong = CompiledSong;
CompiledSong.checkLabel = /^([A-Z_][0-9A-Z_-]*)/i;
var GetRoutineReturnType;
(function (GetRoutineReturnType) {
    GetRoutineReturnType[GetRoutineReturnType["Success"] = 0] = "Success";
    GetRoutineReturnType[GetRoutineReturnType["WrongType"] = 1] = "WrongType";
    GetRoutineReturnType[GetRoutineReturnType["UnknownType"] = 2] = "UnknownType";
    GetRoutineReturnType[GetRoutineReturnType["InvalidLabel"] = 3] = "InvalidLabel";
})(GetRoutineReturnType = exports.GetRoutineReturnType || (exports.GetRoutineReturnType = {}));
function convertMainFlags(data) {
    const f = [];
    if (data.BlockUW) {
        f.push("1<<stfNoUW");
    }
    if (data.NoMasterFrac) {
        f.push("1<<stfNoMasterFreq");
    }
    if (data.NoMasterFrac) {
        f.push("1<<stfNoMasterVol");
    }
    return f.join("|") || "0";
}
exports.convertMainFlags = convertMainFlags;
class SongLabel {
    constructor(name) {
        this.name = name;
    }
    clone() {
        throw new Error("Can not clone labels!");
    }
    getLines() {
        return [this.name + ":",];
    }
    getByteCount() {
        return 0;
    }
    equals() {
        return false;
    }
}
exports.SongLabel = SongLabel;
class Channel {
    constructor(type, routine) {
        this.type = type;
        this.routine = routine;
    }
}
exports.Channel = Channel;
