"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
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
exports.delayEqus = exports.processData = exports.assemblerSettings = exports.Assembler = exports.setFolders = exports.asmExtension = exports.songFolder = exports.resFolder = exports.incFolder = exports.generateSpecialIncludes = exports.filenames = exports.CancelReason = exports.MAX_ERRORS = exports.COMPILER_VERSION = exports.FSCACHE_VERSION = void 0;
const promises_1 = __importDefault(require("fs/promises"));
const fs_1 = __importDefault(require("fs"));
const lib_1 = require("./shared/lib");
const song_1 = require("./shared/song");
const cachedSong_1 = require("./shared/cachedSong");
const main_1 = require("./optimizer/main");
const samples_1 = require("./shared/samples");
const notes_1 = require("./shared/notes");
const path_1 = __importDefault(require("path"));
exports.FSCACHE_VERSION = "0.12b";
exports.COMPILER_VERSION = 0.11;
exports.MAX_ERRORS = 10;
const compilers = {};
function loadCompilers(data) {
    return Promise.all(data.compilers.map((cmp) => __awaiter(this, void 0, void 0, function* () {
        const file = yield Promise.resolve().then(() => __importStar(require(cmp.file)));
        if (typeof file === "object" && typeof file.version === "number") {
            if (file.version !== exports.COMPILER_VERSION) {
                console.error("Compiler", cmp.file, "is targeting an old or unknown version. Please update the compiler!");
                exitcode = 1;
                return;
            }
            if (compilers[cmp.file]) {
                console.error("Compiler", cmp.file, "was already defined. Overwriting...");
                exitcode = 1;
            }
            compilers[cmp.file] = { compiler: file, extensions: cmp.extensions, defaultpreset: cmp.defaultpreset, previewpreset: cmp.previewpreset, };
        }
        else {
            console.error("Attempted to load compiler", cmp.file, "but failed!");
            exitcode = 1;
        }
    })));
}
var CancelReason;
(function (CancelReason) {
    CancelReason[CancelReason["None"] = 0] = "None";
    CancelReason[CancelReason["TooManyErrors"] = 1] = "TooManyErrors";
})(CancelReason = exports.CancelReason || (exports.CancelReason = {}));
function getCompiler(file) {
    for (const cmp of Object.values(compilers)) {
        for (const ext of cmp.extensions) {
            if (file.endsWith(ext)) {
                return cmp;
            }
        }
    }
    return null;
}
function computeOptions(data, options, presets) {
    const presetTree = [];
    let object = {};
    const doPreset = (preset) => {
        if (!data.presets[preset]) {
            throw new Error("Can not compute presets! Preset " + preset + " not found!");
        }
        if (presetTree.includes(preset)) {
            throw new Error("Can not compute presets! Preset " + preset + " was already in preset tree, making this an infinite loop.");
        }
        presetTree.push(preset);
        if (data.presets[preset].preset) {
            for (const p of data.presets[preset].preset) {
                doPreset(p);
            }
        }
        object = (0, lib_1.mergeDeep)(object, data.presets[preset]);
        delete object.preset;
        presetTree.pop();
    };
    for (const preset of presets) {
        doPreset(preset);
    }
    if (options) {
        object = (0, lib_1.mergeDeep)(object, options);
        delete object.preset;
    }
    return object;
}
let sounds = [];
function compile(data, basedir, cache, defaultpreset) {
    return Promise.all(data.sounds.map((d) => __awaiter(this, void 0, void 0, function* () {
        var _a, _b, _c, _d, _e;
        if (typeof d.file !== "string") {
            const song = new song_1.CommandSong();
            for (const item of d.songs) {
                song.addSong(item.index, item.routine);
            }
            return song;
        }
        const cmp = getCompiler(d.file);
        if (!cmp) {
            throw new Error("Compiler for file " + d.file + " not found!");
        }
        const options = computeOptions(data, d.options, ((_b = (_a = d.preset) === null || _a === void 0 ? void 0 : _a.length) !== null && _b !== void 0 ? _b : 0) ? d.preset : cmp[defaultpreset]);
        const cf = d.file.replace("\\", "/").replace("/", "___") + ".fscache", nf = d.file;
        const infile = path_1.default.isAbsolute(nf) ? nf : basedir + nf;
        if (cache && fs_1.default.existsSync(basedir + ".cache/" + cf)) {
            if ((yield promises_1.default.stat(basedir + ".cache/" + cf)).ctime >= (yield promises_1.default.stat(infile)).ctime) {
                console.log("Cache " + cf);
                const line = new lib_1.SyncFileReader(fs_1.default.createReadStream(basedir + ".cache/" + cf));
                const ret = new cachedSong_1.CachedSong();
                if (yield ret.load(line, basedir + ".cache/" + cf, (_c = options.optimizer) !== null && _c !== void 0 ? _c : {}, d.songs)) {
                    line.close();
                    return ret;
                }
            }
        }
        console.log("Convert " + nf);
        const line = new lib_1.SyncFileReader(fs_1.default.createReadStream(infile));
        let ret = new song_1.CompiledSong();
        const helper = {
            error: (location, error, data) => { ret.errors++; compilerLog("error", nf, location, error, data); },
            warn: (location, error, data) => compilerLog("warn", nf, location, error, data),
            info: (location, error, data) => compilerLog("info", nf, location, error, data),
            canceled: () => {
                if (ret.errors > exports.MAX_ERRORS) {
                    return CancelReason.TooManyErrors;
                }
                return CancelReason.None;
            },
            config: d, options,
            shapes: data.shapes,
            sampleRate: data.samplerate,
            filename: d.file, basedir,
            subsongs: d.songs,
        };
        try {
            const nret = yield cmp.compiler.compile(line, ret, helper);
            if (nret === null) {
                ret.errors++;
                return null;
            }
            ret = (0, main_1.optimize)(nret, helper, (_d = options.optimizer) !== null && _d !== void 0 ? _d : {});
            ret.loadDelays();
            if (cache && ret.errors === 0) {
                yield (0, cachedSong_1.createCacheFile)(basedir + ".cache/" + cf, ret, (_e = options.optimizer) !== null && _e !== void 0 ? _e : {});
            }
        }
        catch (ex) {
            helper.error("uncaught", ex);
            return null;
        }
        line.close();
        return ret.errors > 0 ? null : ret;
    })));
}
function compilerLog(func, file, location, error, data) {
    var _a;
    if (typeof error === "string") {
        if (data) {
            console[func](file + " :: " + location + "\n\t" + func + "::" + error + "\n=> " + data + "\n");
        }
        else {
            console[func](file + " :: " + location + "\n\t" + func + "::" + error + "\n");
        }
    }
    else {
        let msg = (_a = error.stack) !== null && _a !== void 0 ? _a : error.message;
        if (msg === null || msg === void 0 ? void 0 : msg.startsWith("Error: ")) {
            msg = msg.substring(7);
        }
        if (data) {
            console[func](file + " :: " + location + "\n\t" + msg + "\n=> " + data + "\n");
        }
        else {
            console[func](file + " :: " + location + "\n\t" + func + "::" + msg + "\n");
        }
    }
}
function saveSongs(data, songs, file) {
    return __awaiter(this, void 0, void 0, function* () {
        const { write, close, } = (0, lib_1.quickWriteStream)(file);
        for (let i = 0; i < data.length; i++) {
            yield write("\t" + exports.assemblerSettings.even + "\n");
            yield songs[i].save(write);
        }
        close();
    });
}
exports.filenames = {
    endmarker: "EndMarker.dat",
    stopsample: "StopSample.dat",
    sampleinc: "Samples.",
    filterinc: "DACFilters.",
    filterptr: "DACFilterTable.",
    filterstr: "DACFilterStrings.",
    filterequ: "DACFilterEquates.",
    shapeinc: "Shapes.",
    shapeequ: "ShapeEquates.",
    shapestr: "ShapeStrings.",
    delaytbl: "DelayTable.",
    delayequ: "DelayEquates.",
    noteequ: "NoteEquates.",
    songequ: "SongEquates.",
    sndstr: "SongStrings.",
    snddat: "SongData.",
    sndptr: "SongTable.",
    sndlst: "SongLists.",
    songlab: "SongLabels.",
    strings: "Strings.",
    dacfreq: "DACFrequencies.",
    fmfreq: "FMFrequencies.",
    psgfreq: "PSGFrequencies.",
    tafreq: "TAFrequencies.",
};
let exitcode = 0;
function generateSpecialIncludes(macro) {
    return __awaiter(this, void 0, void 0, function* () {
        for (const f of Object.values(exports.filenames)) {
            const fn = exports.incFolder + f;
            yield promises_1.default.writeFile(fn, "\t_write_\t'\t" + macro + " \"" + fn + exports.asmExtension + "\"'");
        }
    });
}
exports.generateSpecialIncludes = generateSpecialIncludes;
exports.incFolder = "";
exports.resFolder = "";
exports.songFolder = "";
exports.asmExtension = "asm";
function setFolders(inc, res, song, asmext) {
    exports.incFolder = inc;
    exports.resFolder = res;
    exports.songFolder = song;
    exports.asmExtension = asmext;
    if (!exports.incFolder.endsWith("/")) {
        exports.incFolder += "/";
    }
    if (!exports.resFolder.endsWith("/")) {
        exports.resFolder += "/";
    }
    if (!exports.songFolder.endsWith("/")) {
        exports.songFolder += "/";
    }
}
exports.setFolders = setFolders;
var Assembler;
(function (Assembler) {
    Assembler[Assembler["ASM68K"] = 0] = "ASM68K";
    Assembler[Assembler["AS"] = 1] = "AS";
    Assembler[Assembler["GAS"] = 2] = "GAS";
})(Assembler = exports.Assembler || (exports.Assembler = {}));
function processData(data, defaultpreset, assembler, cache) {
    return __awaiter(this, void 0, void 0, function* () {
        switch (assembler) {
            case Assembler.ASM68K:
                exports.assemblerSettings = {
                    incbin: "incbin",
                    even: "even",
                    specialString: false,
                    stringData: "dc.b",
                    specialEqu: false,
                    equ: "equ",
                    badSampleFormat: false,
                    equatesAreH: false,
                    pcSymbol: "*",
                };
                break;
            case Assembler.AS:
                exports.assemblerSettings = {
                    incbin: "binclude",
                    even: "even",
                    specialString: false,
                    stringData: "dc.b",
                    specialEqu: false,
                    equ: "equ",
                    badSampleFormat: false,
                    equatesAreH: false,
                    pcSymbol: "*",
                };
                break;
            case Assembler.GAS:
                exports.assemblerSettings = {
                    incbin: ".incbin",
                    even: ".align\t2",
                    specialString: true,
                    stringData: ".ascii",
                    specialEqu: true,
                    equ: ".equ",
                    badSampleFormat: true,
                    equatesAreH: true,
                    pcSymbol: ".",
                };
                break;
        }
        if (exports.incFolder.length === 0 || exports.resFolder.length === 0) {
            throw new Error("You have not set your folders!!!");
        }
        if (!fs_1.default.existsSync(exports.incFolder)) {
            fs_1.default.mkdirSync(exports.incFolder, { recursive: true, });
        }
        if (!fs_1.default.existsSync(exports.resFolder + "Samples/.cache")) {
            fs_1.default.mkdirSync(exports.resFolder + "Samples/.cache", { recursive: true, });
        }
        if (!fs_1.default.existsSync(exports.resFolder + "Songs/.cache")) {
            fs_1.default.mkdirSync(exports.resFolder + "Songs/.cache", { recursive: true, });
        }
        yield makeFileByte(0x00, data.markersize, exports.incFolder + exports.filenames.endmarker);
        yield makeFileByte(0x80, data.stopsize, exports.incFolder + exports.filenames.stopsample);
        yield (0, samples_1.loadSampleCache)();
        yield (0, samples_1.loadSamples)(data);
        yield (0, notes_1.generateNotes)(exports.incFolder + exports.filenames.noteequ + exports.asmExtension);
        yield (0, notes_1.generateNoteTableDAC)(exports.incFolder + exports.filenames.dacfreq + exports.asmExtension);
        yield (0, notes_1.generateNoteTablePSG)(exports.incFolder + exports.filenames.psgfreq + exports.asmExtension);
        yield (0, notes_1.generateNoteTableFM)(exports.incFolder + exports.filenames.fmfreq + exports.asmExtension);
        yield (0, notes_1.generateNoteTableTA)(exports.incFolder + exports.filenames.tafreq + exports.asmExtension);
        yield makeFilters(data, exports.incFolder + exports.filenames.filterinc + exports.asmExtension);
        yield makeFilterTable(data, exports.incFolder + exports.filenames.filterptr + exports.asmExtension);
        yield makeGenericStrings(data.filters, exports.incFolder + exports.filenames.filterstr + exports.asmExtension, 0);
        yield makeFilterEqu(data, exports.incFolder + exports.filenames.filterequ + exports.asmExtension);
        yield makeShapes(data, exports.incFolder + exports.filenames.shapeinc + exports.asmExtension);
        yield makeShapeEqu(data, exports.incFolder + exports.filenames.shapeequ + exports.asmExtension);
        yield makeGenericStrings(data.shapes, exports.incFolder + exports.filenames.shapestr + exports.asmExtension, 8);
        yield loadCompilers(data);
        const _sounds = yield compile(data, exports.songFolder, cache, defaultpreset);
        if (_sounds.includes(null)) {
            console.error("One or multiple songs failed to be converted! Will not continue. Check the output above to see any errors!");
            return -1;
        }
        sounds = _sounds;
        const delays = getDelays(data.delaycount, sounds);
        yield makeDelayTable(data, exports.incFolder + exports.filenames.delaytbl + exports.asmExtension, delays);
        yield makeDelayEqu(data, exports.incFolder + exports.filenames.delayequ + exports.asmExtension, delays);
        yield saveSongs(data.sounds, sounds, exports.incFolder + exports.filenames.snddat + exports.asmExtension);
        yield makeSongEquates(data, exports.incFolder + exports.filenames.songequ + (exports.assemblerSettings.equatesAreH ? "h" : exports.asmExtension), "_FRACTAL_SONGS_H_");
        yield makeSoundStrings(data, exports.incFolder + exports.filenames.sndstr + exports.asmExtension);
        yield makeSongPointers(data.sounds, sounds, exports.incFolder + exports.filenames.sndptr + exports.asmExtension);
        yield makeSongTables(data.sounds, sounds, exports.incFolder + exports.filenames.sndlst + exports.asmExtension);
        yield makeSongLabelStrings(sounds, exports.incFolder + exports.filenames.songlab + exports.asmExtension);
        yield (0, samples_1.makeSamples)(exports.incFolder + exports.filenames.sampleinc + exports.asmExtension);
        yield (0, samples_1.saveSampleCache)();
        yield makeStrings(exports.incFolder + exports.filenames.strings + exports.asmExtension);
        return exitcode;
    });
}
exports.processData = processData;
const strings = [];
function addString(str) {
    let index = strings.indexOf(str);
    if (!strings.includes(str)) {
        index = strings.length;
        strings.push(str);
    }
    return index;
}
function makeFileByte(byte, size, file) {
    console.log("makeFileByte() -> " + file);
    return promises_1.default.writeFile(file, Buffer.alloc(size, byte));
}
function makeFilterEqu(data, file) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("makeFilterEqu() -> " + file);
        let str = (0, lib_1.makeEquate)("dfFirst", 32, "0x80"), id = 0x00;
        for (const s of data.filters) {
            str += (0, lib_1.makeEquate)("df" + s, 32, (0, lib_1.byte)(id));
            id += 4;
        }
        str += (0, lib_1.makeEquate)("dfLast", 32, (0, lib_1.byte)(id - 4));
        yield promises_1.default.writeFile(file, str);
    });
}
function makeFilterTable(data, file) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("makeFilterTable() -> " + file);
        let str = "";
        for (const s of data.filters) {
            str += "\t\tdc.l dflt_" + s + "\n";
        }
        yield promises_1.default.writeFile(file, str);
    });
}
function makeFilters(data, file) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("makeFilters() -> " + file);
        let str = "";
        for (const s of data.filters) {
            const file = exports.resFolder + "DAC Filters/" + s + ".dat";
            str += (0, lib_1.padTo)(32, "dflt_" + s + ":") + " " + exports.assemblerSettings.incbin + " \"" + file + "\"\n";
            if ((yield promises_1.default.stat(file)).size !== 0x8000) {
                console.error("DAC Filter", s, "is not 0x8000 bytes in size!");
                exitcode = 1;
            }
        }
        yield promises_1.default.writeFile(file, str);
    });
}
function makeDelayTable(data, file, delays) {
    console.log("makeDelays() -> " + file);
    let str = "\tdc.b ";
    for (let i = 0; i < delays.length; i++) {
        str += (i & 7) === 0 ? "" : ", ";
        str += (0, lib_1.byte)(delays[i] & 0xFF);
        if ((i & 7) === 7) {
            str += "\n\tdc.b ";
        }
    }
    return promises_1.default.writeFile(file, str);
}
exports.delayEqus = [];
function makeDelayEqu(data, file, delays) {
    console.log("makeDelayEqu() -> " + file);
    let str = (0, lib_1.makeEquate)("lext", 32, "0x80"), id = 0x81;
    str += (0, lib_1.makeEquate)("lFirst", 32, "0x81");
    for (const d of delays) {
        const dn = "l" + (0, lib_1.hex)(2, d);
        exports.delayEqus.push(dn);
        str += (0, lib_1.makeEquate)(dn, 32, (0, lib_1.byte)(id));
        id++;
    }
    str += (0, lib_1.makeEquate)("lLast", 32, (0, lib_1.byte)(id - 1));
    return promises_1.default.writeFile(file, str);
}
function getDelays(count, sounds) {
    const uses = new Array(0x100).fill(0);
    uses[0] = Infinity;
    for (const s of sounds) {
        for (let i = 0; i < s.delayUses.length; i++) {
            uses[i] += s.delayUses[i];
        }
    }
    return uses
        .map((v, i) => [i, v,])
        .sort((a, b) => b[1] - a[1])
        .slice(0, count)
        .map((v) => v[0] === 0 ? 0x100 : v[0]);
}
function makeShapes(data, file) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("makeShapes() -> " + file);
        let str = "";
        for (const s of data.shapes) {
            const file = exports.resFolder + "Vibrato Tables/" + s + ".dat";
            str += "\t\t" + exports.assemblerSettings.incbin + " \"" + file + "\"\n";
            if ((yield promises_1.default.stat(file)).size !== 0x200) {
                console.error("Vibrato Table", s, "is not 0x200 bytes in size!");
                exitcode = 1;
            }
        }
        yield promises_1.default.writeFile(file, str);
    });
}
function makeShapeEqu(data, file) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("makeShapeEqu() -> " + file);
        let str = (0, lib_1.makeEquate)("vsFirst", 32, "0x00"), id = 0x00;
        for (const s of data.shapes) {
            str += (0, lib_1.makeEquate)("vs" + s, 32, (0, lib_1.byte)(id));
            id++;
        }
        str += (0, lib_1.makeEquate)("vsLast", 32, (0, lib_1.byte)(id - 1));
        yield promises_1.default.writeFile(file, str);
    });
}
function makeGenericStrings(data, file, pad) {
    console.log("makeGenericStrings() -> " + file);
    let str = "";
    for (const s of data) {
        let ss = s;
        if (pad) {
            ss = ss.padEnd(pad, " ");
        }
        let index = strings.indexOf(ss);
        if (!strings.includes(ss)) {
            index = strings.length;
            strings.push(ss);
        }
        str += "\t\tdc.l dvStrDyn_" + index + "\n";
    }
    return promises_1.default.writeFile(file, str);
}
const SONG_LEN = 28;
function getSongName(name) {
    if (name.length > SONG_LEN) {
        return name.substring(0, SONG_LEN);
    }
    else {
        return name.padEnd(SONG_LEN, " ");
    }
}
function makeSongEquates(data, file, hequate) {
    console.log("makeSongEquates() -> " + file);
    let str = "", id = 0x0000;
    if (exports.assemblerSettings.equatesAreH) {
        str += "#if !defined(" + hequate + ")\n";
        str += "#define " + hequate + "\n";
        str += "#define snd_First 0x0004\n";
    }
    else {
        str += (0, lib_1.makeEquate)("snd_First", 32, "0x0004");
    }
    for (const song of data.sounds) {
        for (const s of song.songs) {
            str += exports.assemblerSettings.equatesAreH ? "#define " + s.id + " " + (0, lib_1.word)(id) + "\n" : (0, lib_1.makeEquate)(s.id, 32, (0, lib_1.word)(id));
            id += 4;
        }
    }
    if (exports.assemblerSettings.equatesAreH) {
        str += "#define snd_Last " + (0, lib_1.word)(id - 4) + "\n";
        str += "#endif // " + hequate + "\n";
    }
    else {
        str += (0, lib_1.makeEquate)("snd_Last", 32, (0, lib_1.word)(id - 4));
    }
    return promises_1.default.writeFile(file, str);
}
function makeSoundStrings(data, file) {
    console.log("makeSoundStrings() -> " + file);
    let str = "";
    for (const song of data.sounds) {
        for (const s of song.songs) {
            const name = getSongName(s.id);
            const index = addString(name);
            str += "\t\tdc.l dvStrDyn_" + index + "\n";
        }
    }
    return promises_1.default.writeFile(file, str);
}
function makeSongPointers(data, songs, file) {
    console.log("makeSongPointers() -> " + file);
    let str = "";
    for (let i = 0; i < data.length; i++) {
        const s = Object.entries(songs[i].songs);
        for (const x of data[i].songs) {
            const i = s.filter((d) => d[0] === x.index.toString())[0];
            str += "\t\tdc.l snddata_" + i[1].id + "\n";
        }
    }
    return promises_1.default.writeFile(file, str);
}
const tableInfo = [
    { prefix: "dvv", array: "fvc", },
    { prefix: "dvs", array: "smp", },
    { prefix: "dvb", array: "vib", },
    { prefix: "dve", array: "env", },
];
function makeSongTables(data, songs, file) {
    console.log("makeSongTables() -> " + file);
    let str = "";
    for (let i = 0; i < data.length; i++) {
        for (let x = 0; x < data[i].songs.length; x++) {
            str += "\t\tdc.l dvp" + songs[i].moduleId + "\n";
        }
    }
    for (let i = 0; i < data.length; i++) {
        str += "\n";
        str += "dvp" + songs[i].moduleId + ":\n";
        for (const d of tableInfo) {
            str += "\t\tdc.l " + d.prefix + songs[i].moduleId + "\n";
        }
    }
    for (let i = 0; i < data.length; i++) {
        const arr = {
            env: songs[i].getEnvelopeNames(),
            vib: songs[i].getVibratoNames(),
            fvc: songs[i].getVoiceNames(),
            smp: songs[i].getSampleNames(),
        };
        for (const d of tableInfo) {
            str += "\n";
            str += d.prefix + songs[i].moduleId + ":\n";
            const len = arr[d.array].length;
            if (len === 0) {
                str += "\t\tdc.l 0\n";
            }
            else {
                for (const s of arr[d.array]) {
                    let index = strings.indexOf(s);
                    if (!strings.includes(s)) {
                        index = strings.length;
                        strings.push(s);
                    }
                    str += "\t\tdc.l (" + (len - 1) + "<<24)+dvStrDyn_" + index + "\n";
                }
            }
        }
    }
    return promises_1.default.writeFile(file, str);
}
function makeSongLabelStrings(data, file) {
    let str = "", count = 1;
    let invalid = strings.indexOf("0");
    if (invalid < 0) {
        invalid = strings.length;
        strings.push("0");
    }
    for (const song of data) {
        for (const i of song.getLabels()) {
            let name = i;
            if (name.length > 20) {
                name = name.substring(name.length - 20);
            }
            let index = strings.indexOf(name);
            if (index < 0) {
                index = strings.length;
                strings.push(name);
            }
            str += "\t\tdc.l " + i + ",dvStrDyn_" + index + "\n";
            count++;
        }
    }
    const ivstr = "\n\t\tdc.l 0,dvStrDyn_" + invalid;
    return promises_1.default.writeFile(file, "\t\tdc.l 8*" + (count + (count & 1)) + ivstr + ivstr + "\n" + str + "\t\tdc.l -1,dvStrDyn_" + invalid);
}
function makeStrings(file) {
    console.log("makeStrings() -> " + file);
    let str = "";
    if (exports.assemblerSettings.specialString) {
        strings.forEach((s, i) => str += (0, lib_1.padTo)(16, "dvStrDyn_" + i + ":") + ".asciz \"" + s + "\"\n");
    }
    else {
        strings.forEach((s, i) => str += (0, lib_1.padTo)(16, "dvStrDyn_" + i + ":") + exports.assemblerSettings.stringData + " \"" + s + "\",0\n");
    }
    str += "\t\t" + exports.assemblerSettings.even;
    return promises_1.default.writeFile(file, str);
}
