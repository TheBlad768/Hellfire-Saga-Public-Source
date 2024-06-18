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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SampleRIFFFormat = exports.SamplePCMFormat = exports.makeSamples = exports.loadSamples = exports.allSamples = exports.addExistingCacheSample = exports.createSample = exports.createSampleFromFile = exports.saveSampleCache = exports.newCachedSamples = exports.loadSampleCache = void 0;
const includer_1 = require("../includer");
const promises_1 = __importDefault(require("fs/promises"));
const fs_1 = __importDefault(require("fs"));
const crypto_1 = __importDefault(require("crypto"));
const lib_1 = require("./lib");
const cacheRegex = /^:([A-Z]+)\s*(.*)$/i;
const sampleCacheFile = "Samples/.cache/.list.fscache";
function loadSampleCache() {
    var _a, _b;
    return __awaiter(this, void 0, void 0, function* () {
        console.log("loadSampleCache()");
        try {
            const file = includer_1.resFolder + sampleCacheFile;
            yield promises_1.default.access(file);
            const line = new lib_1.SyncFileReader(fs_1.default.createReadStream(file));
            const ident = (_a = yield line.readLine()) !== null && _a !== void 0 ? _a : "-";
            if (!ident.startsWith("FSCACHE") || !ident.endsWith("SAMPLES") || !ident.includes("VERSION=" + includer_1.FSCACHE_VERSION)) {
                console.error("Cache failed: invalid FSCACHE in " + file);
                line.close();
                return false;
            }
            while (true) {
                const l = yield line.readLine();
                if (l === null) {
                    break;
                }
                const match = cacheRegex.exec(l);
                if (match === null) {
                    line.close();
                    console.error("Cache failed: line not in correct format " + file);
                    return false;
                }
                switch (match[1]) {
                    case "ID": {
                        const name = (_b = match[2]) === null || _b === void 0 ? void 0 : _b.trim();
                        if (fs_1.default.existsSync(includer_1.resFolder + "Samples/.cache/" + name + ".pcm")) {
                            oldCachedSamples.push(name);
                        }
                        break;
                    }
                }
            }
        }
        catch (ex) {
        }
        return false;
    });
}
exports.loadSampleCache = loadSampleCache;
const oldCachedSamples = [];
exports.newCachedSamples = [];
function saveSampleCache() {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("saveSampleCache()");
        const { write, close, } = (0, lib_1.quickWriteStream)(includer_1.resFolder + sampleCacheFile);
        yield write("FSCACHE VERSION=" + includer_1.FSCACHE_VERSION + " SAMPLES");
        for (const name of exports.newCachedSamples) {
            yield write("\n:ID " + name);
        }
        close();
    });
}
exports.saveSampleCache = saveSampleCache;
function createSampleFromFile(labelStart, labelEnd, filename, rate) {
    var _a;
    return __awaiter(this, void 0, void 0, function* () {
        const dots = filename.split(".");
        let format;
        switch ((_a = dots[dots.length - 1]) === null || _a === void 0 ? void 0 : _a.toLowerCase()) {
            case "wav":
            case "aiff":
                format = new SampleRIFFFormat();
                break;
            default:
                format = new SamplePCMFormat(rate);
                break;
        }
        const slash = filename.replace(/\\/, "/").split("/");
        return createSample(labelStart, labelEnd, yield promises_1.default.readFile(filename), 0, undefined, rate, format, slash[slash.length - 1].replace(/\.[^/.]+$/, ""));
    });
}
exports.createSampleFromFile = createSampleFromFile;
function createSample(labelStart, labelEnd, data, start, length, rate, format, ref) {
    return __awaiter(this, void 0, void 0, function* () {
        const subbuf = data.subarray(start, typeof length === "number" ? start + length : undefined);
        const file = convertSample(subbuf, rate, format, ref);
        if (!file) {
            return null;
        }
        const hash = ref
        const cache = includer_1.resFolder + "Samples/.cache/" + hash + ".pcm";
        yield promises_1.default.writeFile(cache, file);
        exports.newCachedSamples.push(hash);
        if (addExistingCacheSample(ref, [labelStart,], [labelEnd,])) {
            return includer_1.resFolder + "Samples/.cache/" + hash + ".pcm";
        }
        exports.allSamples.push({ labelStart: [labelStart,], labelEnd: [labelEnd,], hash, size: subbuf.length, file: cache, });
        return cache;
    });
}
exports.createSample = createSample;
function addExistingCacheSample(hash, labelStart, labelEnd) {
    const samp = exports.allSamples.find((s) => s.hash === hash);
    if (!samp) {
        return false;
    }
    for (const sl of labelStart) {
        if (samp.labelStart.findIndex((str) => str.toLowerCase() === sl.toLowerCase()) < 0) {
            samp.labelStart.push(sl);
        }
    }
    for (const se of labelEnd) {
        if (samp.labelEnd.findIndex((str) => str.toLowerCase() === se.toLowerCase()) < 0) {
            samp.labelEnd.push(se);
        }
    }
    return true;
}
exports.addExistingCacheSample = addExistingCacheSample;
exports.allSamples = [];
function loadSamples(data) {
    console.log("loadSamples()");
    exports.allSamples.push({ labelStart: ["dsStop",], labelEnd: ["deStop",], size: data.stopsize, file: includer_1.incFolder + includer_1.filenames.stopsample, hash: ":)", });
    return Promise.all(data.samples.map((s) => createSampleFromFile("ds" + s.name, "de" + s.name, s.file, data.samplerate)));
}
exports.loadSamples = loadSamples;
function makeSamples(file) {
    console.log("makeSamples() -> " + file);
    let str = "";
    const endmarker = includer_1.incFolder + includer_1.filenames.endmarker;
    const addFile = (file) => {
        str += "\t\t" + includer_1.assemblerSettings.incbin + " \"" + file + "\"\n";
    };
    addFile(endmarker);
    for (const d of exports.allSamples) {
        for (const s of d.labelStart) {
            str += s + ":\n";
        }
        addFile(d.file);
        for (const s of d.labelEnd) {
            str += s + ":\n";
        }
        addFile(endmarker);
    }
    return promises_1.default.writeFile(file, str);
}
exports.makeSamples = makeSamples;
function convertSample(data, rate, format, ref) {
    const ret = format.parse(ref, data);
    if (!ret) {
        return null;
    }
    const s1 = loadBufferData[ret.channels + "ch" + ret.bits + "b"](ret, data);
    const diff = ret.rate - rate;
    const s2 = rateConvert[diff === 0 ? 0 : diff > 0 ? 1 : 2](s1.left, s1.right, ret.rate, rate);
    return convertToSigned8(s2.left, s2.right);
}
function convertToSigned8(left, right) {
    const buf = new Uint8Array(left.length);
    for (let i = 0; i < buf.length; i++) {
        let sample = (left[i] + right[i]) >> 1;
        if (sample < 0 && (sample & 0xFF) !== 0) {
            sample += 0x100;
        }
        sample = (sample >> 8) & 0xFF;
        sample += 0x80;
        if (((sample + 0x100) & 0xFF) === 0) {
            sample++;
        }
        buf[i] = sample;
    }
    return buf;
}
function convert8To16(v1, signed) {
    if (signed) {
        return v1 << 8;
    }
    else {
        return (0x80 + v1) << 8;
    }
}
const loadBufferData = {
    "1ch8b": (info, buf) => {
        const samples = info.sampleLen / 1 / 1;
        const left = new Int16Array(samples), right = new Int16Array(samples);
        for (let index = 0; index < samples; index++) {
            left[index] = right[index] = convert8To16(buf.readInt8(info.sampleStart + index), info.signed);
        }
        return { left, right, };
    },
    "1ch16b": (info, buf) => {
        const samples = info.sampleLen / 2 / 1;
        const left = new Int16Array(samples), right = new Int16Array(samples);
        for (let index = 0; index < samples; index++) {
            const value = buf.readInt16LE(info.sampleStart + (index * 2));
            left[index] = right[index] = value;
        }
        return { left, right, };
    },
    "2ch8b": (info, buf) => {
        const samples = info.sampleLen / 1 / 2;
        const left = new Int16Array(samples), right = new Int16Array(samples);
        for (let index = 0; index < samples; index++) {
            left[index] = convert8To16(buf.readInt8(info.sampleStart + (index * 2)), info.signed);
            right[index] = convert8To16(buf.readInt8(info.sampleStart + (index * 2) + 1), info.signed);
        }
        return { left, right, };
    },
    "2ch16b": (info, buf) => {
        const samples = info.sampleLen / 2 / 2;
        const left = new Int16Array(samples), right = new Int16Array(samples);
        for (let index = 0; index < samples; index++) {
            left[index] = buf.readInt16LE(info.sampleStart + (index * 4));
            right[index] = buf.readInt16LE(info.sampleStart + (index * 4) + 2);
        }
        return { left, right, };
    },
};
const rateConvert = [
    (lbuf, rbuf) => {
        return { left: lbuf, right: rbuf, };
    },
    (lbuf, rbuf, oldrate, newrate) => {
        const advanceRate = oldrate / newrate;
        const doChannel = (input) => {
            const data = [];
            let inpos = 0, advanceCur = 0, targetPos = 0;
            data.push(input[inpos]);
            while (inpos < input.length) {
                advanceCur += advanceRate;
                targetPos += Math.floor(advanceCur);
                advanceCur = advanceCur % 1;
                data.push(input[inpos]);
                inpos = targetPos;
            }
            return new Int16Array(data);
        };
        return { left: doChannel(lbuf), right: doChannel(rbuf), };
    },
    (lbuf, rbuf, oldrate, newrate) => {
        const advanceRate = newrate / oldrate;
        const doChannel = (input) => {
            const data = [];
            let inpos = 0, advanceCur = 0, targetPos = 0;
            while (inpos < input.length) {
                advanceCur += advanceRate;
                targetPos += Math.floor(advanceCur);
                advanceCur = advanceCur % 1;
                const sample = input[++inpos];
                while (data.length < targetPos) {
                    data.push(sample);
                }
            }
            return new Int16Array(data);
        };
        return { left: doChannel(lbuf), right: doChannel(rbuf), };
    },
];
class SamplePCMFormat {
    constructor(rate, bits, channels, signed) {
        this.bits = bits !== null && bits !== void 0 ? bits : 8;
        this.channels = channels !== null && channels !== void 0 ? channels : 1;
        this.rate = rate;
        this.signed = signed !== null && signed !== void 0 ? signed : false;
    }
    parse(ref, data) {
        return {
            bits: this.bits,
            channels: this.channels,
            rate: this.rate,
            sampleStart: 0,
            sampleLen: data.length,
            signed: this.signed,
        };
    }
}
exports.SamplePCMFormat = SamplePCMFormat;
class SampleRIFFFormat {
    parse(ref, data) {
        const getString = (pos, len) => {
            if (pos + len > data.length) {
                throw new RangeError("Can not read string from RIFF file in" + ref);
            }
            return data.toString("ascii", pos, pos + len);
        };
        if (getString(0, 4) !== "RIFF") {
            throw new RangeError("Input data not in RIFF format in " + ref);
        }
        if (data.readInt32LE(4) + 8 > data.length) {
            throw new RangeError("Input data is smaller than RIFF file size in " + ref + ". File may be corrupt.");
        }
        if (getString(8, 4) !== "WAVE") {
            throw new RangeError("Input data typs is not WAVE in " + ref);
        }
        const findString = (start, text) => {
            for (let pos = start; pos < data.length - text.length; pos++) {
                if (data[pos] === text.charCodeAt(0)) {
                    let found = true;
                    for (let c = 1; c < text.length; c++) {
                        if (data[pos + c] !== text.charCodeAt(c)) {
                            found = false;
                            break;
                        }
                    }
                    if (found) {
                        return pos;
                    }
                }
            }
            throw new RangeError("Unable to find " + text + " RIFF string in " + ref);
        };
        const fmtpos = findString(12, "fmt ");
        if (data.readInt16LE(fmtpos + 8) !== 1) {
            throw new Error("Unable to parse RIFF PCM data, because format is not raw PCM in " + ref);
        }
        const channels = data.readInt16LE(fmtpos + 10);
        if (channels < 0 || channels > 2) {
            throw new Error("Unable to parse RIFF PCM data, because it uses too many channels in " + ref);
        }
        const rate = data.readInt32LE(fmtpos + 12);
        const bits = data.readInt16LE(fmtpos + 22);
        if (bits !== 8 && bits !== 16) {
            throw new Error("Unable to parse RIFF PCM data, because its bit depth is " + bits + " in " + ref);
        }
        const datapos = findString(12, "data");
        const sampleLen = data.readInt32LE(datapos + 4);
        const sampleStart = datapos + 8;
        return { sampleLen, sampleStart, rate, bits, channels, signed: false, };
    }
}
exports.SampleRIFFFormat = SampleRIFFFormat;
