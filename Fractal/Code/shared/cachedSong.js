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
        this.delayUses = [];
    }
    load(line, file, options, subsongs) {
        var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21;
        return __awaiter(this, void 0, void 0, function* () {
            const ident = (_a = yield line.readLine()) !== null && _a !== void 0 ? _a : "-";
            if (!ident.startsWith("FSCACHE") || !ident.includes("VERSION=" + includer_1.FSCACHE_VERSION)) {
                line.close();
                console.error("Cache failed: invalid FSCACHE in " + file);
                return false;
            }
            let loop = true;
            let index = NaN;
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
                switch (match[1]) {
                    case "INDICES":
                        if (((_b = match[2]) === null || _b === void 0 ? void 0 : _b.trim()) !== subsongs.map((s) => s.index).sort((a, b) => a - b).join(",")) {
                            return false;
                        }
                        break;
                    case "DELAYS":
                        this.delayUses = ((_d = (_c = match[2]) === null || _c === void 0 ? void 0 : _c.trim()) !== null && _d !== void 0 ? _d : "").split(",").map((n) => parseInt(n, 10));
                        break;
                    case "INDEX":
                        index = parseInt((_f = (_e = match[2]) === null || _e === void 0 ? void 0 : _e.trim()) !== null && _f !== void 0 ? _f : "0", 16);
                        if (!this.songs[index]) {
                            this.songs[index] = {
                                id: "", sfx: false, priority: 0x80,
                                tempo: 0, flags: "", palFlag: false,
                                channels: [],
                            };
                        }
                        break;
                    case "ID":
                        this.songs[index].id = (_h = (_g = match[2]) === null || _g === void 0 ? void 0 : _g.trim()) !== null && _h !== void 0 ? _h : "b0rk";
                        break;
                    case "OPT":
                        if ((0, main_1.getOptimizerString)(options) !== ((_j = match[2]) === null || _j === void 0 ? void 0 : _j.trim())) {
                            return false;
                        }
                        break;
                    case "FLAGS":
                        this.songs[index].flags = (_l = (_k = match[2]) === null || _k === void 0 ? void 0 : _k.trim()) !== null && _l !== void 0 ? _l : "0";
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
                        this.songs[index].priority = parseInt((_o = (_m = match[2]) === null || _m === void 0 ? void 0 : _m.trim()) !== null && _o !== void 0 ? _o : "0", 10);
                        break;
                    case "TEMPO":
                        this.songs[index].tempo = parseInt((_q = (_p = match[2]) === null || _p === void 0 ? void 0 : _p.trim()) !== null && _q !== void 0 ? _q : "NaN", 10);
                        break;
                    case "CHANNEL":
                        this.songs[index].channels.push((_s = (_r = match[2]) === null || _r === void 0 ? void 0 : _r.trim().split(",")) !== null && _s !== void 0 ? _s : []);
                        break;
                    case "HEADER":
                        this.header = (_u = (_t = match[2]) === null || _t === void 0 ? void 0 : _t.trim().split(",")) !== null && _u !== void 0 ? _u : [];
                        break;
                    case "ENV":
                        if (((_x = (_w = (_v = match[2]) === null || _v === void 0 ? void 0 : _v.trim()) === null || _w === void 0 ? void 0 : _w.length) !== null && _x !== void 0 ? _x : 0) > 0) {
                            this.envelopes = (_y = match[2].trim().split(",")) !== null && _y !== void 0 ? _y : [];
                        }
                        break;
                    case "VIB":
                        if (((_1 = (_0 = (_z = match[2]) === null || _z === void 0 ? void 0 : _z.trim()) === null || _0 === void 0 ? void 0 : _0.length) !== null && _1 !== void 0 ? _1 : 0) > 0) {
                            this.vibrato = (_2 = match[2].trim().split(",")) !== null && _2 !== void 0 ? _2 : [];
                        }
                        break;
                    case "SMP":
                        if (((_5 = (_4 = (_3 = match[2]) === null || _3 === void 0 ? void 0 : _3.trim()) === null || _4 === void 0 ? void 0 : _4.length) !== null && _5 !== void 0 ? _5 : 0) > 0) {
                            this.samples = (_6 = match[2].trim().split(",")) !== null && _6 !== void 0 ? _6 : [];
                        }
                        break;
                    case "FMV":
                        if (((_9 = (_8 = (_7 = match[2]) === null || _7 === void 0 ? void 0 : _7.trim()) === null || _8 === void 0 ? void 0 : _8.length) !== null && _9 !== void 0 ? _9 : 0) > 0) {
                            this.voices = (_10 = match[2].trim().split(",")) !== null && _10 !== void 0 ? _10 : [];
                        }
                        break;
                    case "LABEL":
                        this.labels.push((_12 = (_11 = match[2]) === null || _11 === void 0 ? void 0 : _11.trim()) !== null && _12 !== void 0 ? _12 : "");
                        break;
                    case "SMPINC":
                        if (((_15 = (_14 = (_13 = match[2]) === null || _13 === void 0 ? void 0 : _13.trim()) === null || _14 === void 0 ? void 0 : _14.length) !== null && _15 !== void 0 ? _15 : 0) > 0) {
                            const [start, end, file,] = (_17 = (_16 = match[2]) === null || _16 === void 0 ? void 0 : _16.trim().split(" ")) !== null && _17 !== void 0 ? _17 : ["", "", "",];
                            const fns = file.replace("\\", "/").split("/");
                            const hash = (_19 = (_18 = fns[fns.length - 1]) === null || _18 === void 0 ? void 0 : _18.split(".")[0]) !== null && _19 !== void 0 ? _19 : "";
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
                        this.moduleId = (_21 = (_20 = match[2]) === null || _20 === void 0 ? void 0 : _20.trim()) !== null && _21 !== void 0 ? _21 : "b0rk";
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
                yield write(this.voices.map((v, i) => (0, lib_1.makeEquate)("fmv_" + this.moduleId + "_" + v, 32, (0, lib_1.byte)(i))).join(""));
            }
            if (this.samples.length > 0) {
                yield write(this.samples.map((v, i) => (0, lib_1.makeEquate)("smp_" + this.moduleId + "_" + v, 32, (0, lib_1.byte)(i))).join(""));
            }
            if (this.vibrato.length > 0) {
                yield write(this.vibrato.map((v, i) => (0, lib_1.makeEquate)("vib_" + this.moduleId + "_" + v, 32, (0, lib_1.byte)(i))).join(""));
            }
            if (this.envelopes.length > 0) {
                yield write(this.envelopes.map((v, i) => (0, lib_1.makeEquate)("env_" + this.moduleId + "_" + v, 32, (0, lib_1.byte)(i * 2))).join(""));
            }
            for (const song of Object.entries(this.songs)) {
                yield write("\t" + includer_1.assemblerSettings.even + "\n");
                yield write("snddata_" + song[1].id + ":\n");
                yield write("\tdc.l (" + (+song[1].sfx) + ")<<24+" + this.header[0] + "\n");
                yield write("\tdc.l (0x" + (0, lib_1.hex)(2, isNaN(song[1].priority) ? 0 : song[1].priority) + ")<<24+" + this.header[1] + "\n");
                yield write("\tdc.l (" + song[1].flags + ")<<24+" + this.header[2] + "\n");
                yield write("\tdc.l (0x00)<<24+" + this.header[3] + "\n");
                if (!song[1].sfx) {
                    yield write("\tdc.w 0x10*0x" + (0, lib_1.hex)(4, song[1].tempo) + ",0x10*0x" + (0, lib_1.hex)(4, song[1].palFlag ? song[1].tempo : Math.round(song[1].tempo / 50 * 60)) + "\n");
                }
                for (const ch of song[1].channels) {
                    yield write("\tdc.l (clt" + ch[0] + ")<<24+" + ch[1] + "\n");
                }
                yield write("\tdc.b 0xFF\n");
            }
            for (let i = 0; i < 0x100; i++) {
                const dh0 = (0, lib_1.hex)(2, i);
                const dh = i === 0 ? "100" : dh0;
                const str = includer_1.delayEqus.includes("l" + dh) ? "l" + dh : "lext,0x" + dh0;
                this.data = this.data.replace(new RegExp("%!delay:" + dh, "gi"), str);
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
        yield write("\n:INDICES " + Object.keys(song.songs).map((s) => parseInt(s, 10)).sort((a, b) => a - b).join(","));
        yield write("\n:DELAYS " + song.delayUses.map((d) => d.toString(10)).join(","));
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
            if (s[1].sfx) {
                yield write("\n:SFX");
                yield write("\n:PRIORITY " + s[1].priority);
            }
            else {
                yield write("\n:MUSIC");
                yield write("\n:TEMPO " + s[1].tempo);
            }
            if (s[1].flags.PAL) {
                yield write("\n:PAL");
            }
            yield write("\n:FLAGS " + song.getFlags(parseInt(s[0], 10)));
            yield write("\n:HEADER " + ((_a = song.voiceRoutine) === null || _a === void 0 ? void 0 : _a.label.name) + "," + ((_b = song.sampleRoutine) === null || _b === void 0 ? void 0 : _b.label.name) + "," + ((_c = song.vibratoRoutine) === null || _c === void 0 ? void 0 : _c.label.name) + "," + ((_d = song.envelopeRoutine) === null || _d === void 0 ? void 0 : _d.label.name));
            for (const c of s[1].channels) {
                yield write("\n:CHANNEL " + song_1.ChannelType[c.type] + "," + c.routine.label.name);
            }
        }
        yield write("\n:DATA");
        for (const d of song.routines) {
            const lines = d.getLines(song, true);
            if (lines.length) {
                yield write("\n" + lines.join("\n"));
            }
        }
        close();
    });
}
exports.createCacheFile = createCacheFile;
