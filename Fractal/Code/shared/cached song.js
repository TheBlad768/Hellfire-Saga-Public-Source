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
exports.createCacheFile = exports.CachedSong = void 0;
const includer_1 = require("../includer");
const main_1 = require("../optimizer/main");
const lib_1 = require("./lib");
const samples_1 = require("./samples");
const song_1 = require("./song");
class CachedSong {
    constructor() {
        this.cacheRegex = /^:([A-Z]+)\s*(.*)$/i;
        this.moduleId = "";
        this.envelopes = [];
        this.voices = [];
        this.vibrato = [];
        this.samples = [];
        this.header = [];
        this.labels = [];
        this.data = "";
        this.songs = {};
    }
    load(line, file, options) {
        var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18;
        return __awaiter(this, void 0, void 0, function* () {
            const ident = (_a = yield line.readLine()) !== null && _a !== void 0 ? _a : "-";
            if (!ident.startsWith("FSCACHE") || !ident.includes("VERSION=" + includer_1.FSCACHE_VERSION)) {
                line.close();
                console.error("Cache failed: invalid FSCACHE in " + file);
                return false;
            }
            let loop = true;
            while (loop) {
                const l = yield line.readLine();
                if (l === null) {
                    line.close();
                    console.error("Cache failed: EOF before :DATA " + file);
                    return false;
                }
                const match = this.cacheRegex.exec(l);
                if (match === null) {
                    line.close();
                    console.error("Cache failed: line not in correct format " + file);
                    return false;
                }
                let index = NaN;
                switch (match[1]) {
                    case "INDEX":
                        index = parseInt((_c = (_b = match[2]) === null || _b === void 0 ? void 0 : _b.trim()) !== null && _c !== void 0 ? _c : "0", 16);
                        if (!this.songs[index]) {
                            this.songs[index] = {
                                id: "", sfx: false, priority: 0x80,
                                tempo: 0, flags: "", palFlag: false,
                                channels: [],
                            };
                        }
                        break;
                    case "ID":
                        this.songs[index].id = (_e = (_d = match[2]) === null || _d === void 0 ? void 0 : _d.trim()) !== null && _e !== void 0 ? _e : "b0rk";
                        break;
                    case "OPT":
                        if ((0, main_1.getOptimizerString)(options) !== ((_f = match[2]) === null || _f === void 0 ? void 0 : _f.trim())) {
                            return false;
                        }
                        break;
                    case "FLAGS":
                        this.songs[index].flags = (_h = (_g = match[2]) === null || _g === void 0 ? void 0 : _g.trim()) !== null && _h !== void 0 ? _h : "0";
                        break;
                    case "PAL":
                        this.songs[index].palFlag = true;
                        break;
                    case "SFX":
                        this.songs[index].sfx = true;
                        break;
                    case "MUSIC":
                        this.songs[index].sfx = false;
                        break;
                    case "PRIORITY":
                        this.songs[index].priority = parseInt((_k = (_j = match[2]) === null || _j === void 0 ? void 0 : _j.trim()) !== null && _k !== void 0 ? _k : "0", 10);
                        break;
                    case "TEMPO":
                        this.songs[index].tempo = parseInt((_m = (_l = match[2]) === null || _l === void 0 ? void 0 : _l.trim()) !== null && _m !== void 0 ? _m : "NaN", 10);
                        break;
                    case "CHANNEL":
                        this.songs[index].channels.push((_p = (_o = match[2]) === null || _o === void 0 ? void 0 : _o.trim().split(",")) !== null && _p !== void 0 ? _p : []);
                        break;
                    case "HEADER":
                        this.header = (_r = (_q = match[2]) === null || _q === void 0 ? void 0 : _q.trim().split(",")) !== null && _r !== void 0 ? _r : [];
                        break;
                    case "ENV":
                        if (((_u = (_t = (_s = match[2]) === null || _s === void 0 ? void 0 : _s.trim()) === null || _t === void 0 ? void 0 : _t.length) !== null && _u !== void 0 ? _u : 0) > 0) {
                            this.envelopes = (_v = match[2].trim().split(",")) !== null && _v !== void 0 ? _v : [];
                        }
                        break;
                    case "VIB":
                        if (((_y = (_x = (_w = match[2]) === null || _w === void 0 ? void 0 : _w.trim()) === null || _x === void 0 ? void 0 : _x.length) !== null && _y !== void 0 ? _y : 0) > 0) {
                            this.vibrato = (_z = match[2].trim().split(",")) !== null && _z !== void 0 ? _z : [];
                        }
                        break;
                    case "SMP":
                        if (((_2 = (_1 = (_0 = match[2]) === null || _0 === void 0 ? void 0 : _0.trim()) === null || _1 === void 0 ? void 0 : _1.length) !== null && _2 !== void 0 ? _2 : 0) > 0) {
                            this.samples = (_3 = match[2].trim().split(",")) !== null && _3 !== void 0 ? _3 : [];
                        }
                        break;
                    case "FMV":
                        if (((_6 = (_5 = (_4 = match[2]) === null || _4 === void 0 ? void 0 : _4.trim()) === null || _5 === void 0 ? void 0 : _5.length) !== null && _6 !== void 0 ? _6 : 0) > 0) {
                            this.voices = (_7 = match[2].trim().split(",")) !== null && _7 !== void 0 ? _7 : [];
                        }
                        break;
                    case "LABEL":
                        this.labels.push((_9 = (_8 = match[2]) === null || _8 === void 0 ? void 0 : _8.trim()) !== null && _9 !== void 0 ? _9 : "");
                        break;
                    case "SMPINC":
                        if (((_12 = (_11 = (_10 = match[2]) === null || _10 === void 0 ? void 0 : _10.trim()) === null || _11 === void 0 ? void 0 : _11.length) !== null && _12 !== void 0 ? _12 : 0) > 0) {
                            const [start, end, file,] = (_14 = (_13 = match[2]) === null || _13 === void 0 ? void 0 : _13.trim().split(" ")) !== null && _14 !== void 0 ? _14 : ["", "", "",];
                            const fns = file.replace("\\", "/").split("/");
                            const hash = (_16 = (_15 = fns[fns.length - 1]) === null || _15 === void 0 ? void 0 : _15.split(".")[0]) !== null && _16 !== void 0 ? _16 : "";
                            const starts = start.split(","), ends = end.split(",");
                            if (!(0, samples_1.addExistingCacheSample)(hash, starts, ends)) {
                                samples_1.allSamples.push({ hash, file, size: 0, labelStart: starts, labelEnd: ends, });
                            }
                            if (!samples_1.newCachedSamples.includes(hash)) {
                                samples_1.newCachedSamples.push(hash);
                            }
                        }
                        break;
                    case "MODULE":
                        this.moduleId = (_18 = (_17 = match[2]) === null || _17 === void 0 ? void 0 : _17.trim()) !== null && _18 !== void 0 ? _18 : "b0rk";
                        break;
                    case "DATA":
                        loop = false;
                        break;
                }
            }
            while (true) {
                const l = yield line.readLine();
                if (l === null) {
                    break;
                }
                this.data += l + "\n";
            }
            line.close();
            return true;
        });
    }
    getVoiceNames() {
        return this.voices;
    }
    getSampleNames() {
        return this.samples;
    }
    getVibratoNames() {
        return this.vibrato;
    }
    getEnvelopeNames() {
        return this.envelopes;
    }
    getLabels() {
        return this.labels;
    }
    save(write) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.voices.length > 0) {
                yield write(this.voices.map((v, i) => (0, lib_1.padTo)(32, "fmv_" + this.moduleId + "_" + v) + " EQU $" + (0, lib_1.hex)(2, i)).join("\n") + "\n");
            }
            if (this.samples.length > 0) {
                yield write(this.samples.map((v, i) => (0, lib_1.padTo)(32, "smp_" + this.moduleId + "_" + v) + " EQU $" + (0, lib_1.hex)(2, i)).join("\n") + "\n");
            }
            if (this.vibrato.length > 0) {
                yield write(this.vibrato.map((v, i) => (0, lib_1.padTo)(32, "vib_" + this.moduleId + "_" + v) + " EQU $" + (0, lib_1.hex)(2, i)).join("\n") + "\n");
            }
            if (this.envelopes.length > 0) {
                yield write(this.envelopes.map((v, i) => (0, lib_1.padTo)(32, "env_" + this.moduleId + "_" + v) + " EQU $" + (0, lib_1.hex)(2, i * 2)).join("\n") + "\n");
            }
            for (const song of Object.entries(this.songs)) {
                yield write("\tdc.l (" + (+song[1].sfx) + ")<<24|" + this.header[0] + "\n");
                yield write("\tdc.l ($" + (0, lib_1.hex)(2, isNaN(song[1].priority) ? 0 : song[1].priority) + ")<<24|" + this.header[1] + "\n");
                yield write("\tdc.l (" + song[1].flags + ")<<24|" + this.header[2] + "\n");
                yield write("\tdc.l ($00)<<24|" + this.header[3] + "\n");
                if (!song[1].sfx) {
                    yield write("\tdc.w $10*$" + (0, lib_1.hex)(4, song[1].tempo) + ",$10*$" + (0, lib_1.hex)(4, song[1].palFlag ? song[1].tempo : Math.round(song[1].tempo / 50 * 60)) + "\n");
                }
                for (const ch of song[1].channels) {
                    yield write("\tdc.l (clt" + ch[0] + ")<<24|" + ch[1] + "\n");
                }
                yield write("\tdc.b $FF\n");
            }
            yield write(this.data);
        });
    }
}
exports.CachedSong = CachedSong;
function createCacheFile(file, song, options) {
    var _a, _b, _c, _d;
    return __awaiter(this, void 0, void 0, function* () {
        const { write, close, } = (0, lib_1.quickWriteStream)(file);
        yield write("FSCACHE VERSION=" + includer_1.FSCACHE_VERSION);
        yield write("\n:MODULE " + song.moduleId);
        yield write("\n:OPT " + (0, main_1.getOptimizerString)(options));
        yield write("\n:ENV " + song.envelopes.map((e) => e.name).join(","));
        yield write("\n:VIB " + song.vibrato.map((e) => e.name).join(","));
        yield write("\n:SMP " + song.samples.map((e) => e.name).join(","));
        yield write("\n:FMV " + song.voices.map((e) => e.name).join(","));
        for (const str of song.getLabels()) {
            yield write("\n:LABEL " + str);
        }
        for (const s of song.sampleIncludes) {
            yield write("\n:SMPINC " + s.start.join(",") + " " + s.end.join(",") + " " + s.file);
        }
        for (const s of Object.entries(song.songs)) {
            yield write("\n:INDEX " + (0, lib_1.hex)(2, parseInt(s[0], 10)));
            yield write("\n:ID " + s[1].id);
            yield write("\n:SFX " + s[1].sfx);
            yield write("\n:FLAGS " + song.getFlags(parseInt(s[0], 10)));
            if (s[1].sfx) {
                yield write("\n:PRIORITY " + s[1].priority);
            }
            else {
                yield write("\n:TEMPO " + s[1].tempo);
            }
            if (s[1].flags.PAL) {
                yield write("\n:PAL");
            }
            yield write("\n:HEADER " + ((_a = song.voiceRoutine) === null || _a === void 0 ? void 0 : _a.label.name) + "," + ((_b = song.sampleRoutine) === null || _b === void 0 ? void 0 : _b.label.name) + "," + ((_c = song.vibratoRoutine) === null || _c === void 0 ? void 0 : _c.label.name) + "," + ((_d = song.envelopeRoutine) === null || _d === void 0 ? void 0 : _d.label.name));
            for (const c of s[1].channels) {
                yield write("\n:CHANNEL " + song_1.ChannelType[c.type] + "," + c.routine.label.name);
            }
        }
        yield write("\n:DATA");
        for (const d of song.routines) {
            const lines = d.getLines(song);
            if (lines.length) {
                yield write("\n" + lines.join("\n"));
            }
        }
        close();
    });
}
exports.createCacheFile = createCacheFile;
