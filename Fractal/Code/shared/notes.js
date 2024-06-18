"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.calcFracForFreq = exports.calcRawFreq = exports.generateNoteTableFM = exports.maxNoteFM = exports.minNoteFM = exports.freqDistFM = exports.freqTableFM = exports.generateNoteTablePSG = exports.maxNotePSG = exports.minNotePSG = exports.freqDistPSG = exports.freqTablePSG = exports.generateNoteTableTA = exports.maxNoteTA = exports.minNoteTA = exports.freqDistTA = exports.freqTableTA = exports.generateNoteTableDAC = exports.maxNoteDAC = exports.minNoteDAC = exports.freqDistDAC = exports.freqTableDAC = exports.getFreq = exports.SongNote = exports.getNoteByID = exports.getNoteByName = exports.octaveNotes = exports.generateNotes = exports.firstRealNote = exports.allNotes = exports.noteSample = exports.noteHiHat = exports.noteKey = exports.noteRest = exports.noteCut = void 0;
const commands_1 = require("./commands");
const song_1 = require("./song");
const promises_1 = __importDefault(require("fs/promises"));
const lib_1 = require("./lib");
const includer_1 = require("../includer");
exports.allNotes = [];
exports.firstRealNote = 3;
function generateNotes(file) {
    console.log("generateNotes() -> " + file);
    exports.allNotes.push(exports.noteCut = { id: 0, name: "nCut", valid: song_1.channeListAll, isNoise: false, });
    exports.allNotes.push(exports.noteRest = { id: 1, name: "nRst", valid: song_1.channeListAll, isNoise: false, });
    exports.allNotes.push(exports.noteKey = { id: 2, name: "nKey", valid: song_1.channeListAll, isNoise: false, });
    for (let i = exports.firstRealNote, n = 0; i < 0x80; i++, n++) {
        exports.allNotes.push({ id: i, name: "n" + exports.octaveNotes[n % 0xC] + (Math.floor(n / 0xC)), valid: song_1.channeListAll, isNoise: false, });
    }
    const noiseNames = ["nPeri10", "nPeri20", "nPeri40", "nPeriPSG3", "nWhite10", "nWhite20", "nWhite40", "nWhitePSG3",];
    for (let i = exports.firstRealNote, n = 0; n < noiseNames.length; i++, n++) {
        exports.allNotes.push({ id: i, name: noiseNames[n], valid: [song_1.ChannelType.PSG4,], isNoise: true, });
    }
    exports.allNotes.push(exports.noteHiHat = { id: 0x5E + exports.firstRealNote, name: "nhihat", valid: [song_1.ChannelType.PSG3,], isNoise: false, });
    exports.allNotes.push(exports.noteSample = { id: 0x30 + exports.firstRealNote, name: "nsample", valid: song_1.channeListDAC, isNoise: false, });
    let str = "";
    str += (0, lib_1.makeEquate)("nFirstNote", 32, (0, lib_1.byte)(exports.firstRealNote));
    str += (0, lib_1.makeEquate)("nLastPSG4", 32, (0, lib_1.byte)(exports.firstRealNote + noiseNames.length));
    for (const n of exports.allNotes) {
        if (!isNaN(n.id)) {
            str += (0, lib_1.makeEquate)(n.name, 32, (0, lib_1.byte)(n.id));
        }
    }
    str += (0, lib_1.makeEquate)("minNotePSG", 32, (0, lib_1.byte)(exports.minNotePSG));
    str += (0, lib_1.makeEquate)("maxNotePSG", 32, (0, lib_1.byte)(exports.maxNotePSG - exports.minNotePSG));
    str += (0, lib_1.makeEquate)("minNoteDAC", 32, (0, lib_1.byte)(exports.minNoteDAC));
    str += (0, lib_1.makeEquate)("maxNoteDAC", 32, (0, lib_1.byte)(exports.maxNoteDAC - exports.minNoteDAC));
    str += (0, lib_1.makeEquate)("minNoteFM", 32, (0, lib_1.byte)(exports.minNoteFM));
    str += (0, lib_1.makeEquate)("maxNoteFM", 32, (0, lib_1.byte)(exports.maxNoteFM - exports.minNoteFM));
    str += (0, lib_1.makeEquate)("minNoteTA", 32, (0, lib_1.byte)(exports.minNoteTA));
    str += (0, lib_1.makeEquate)("maxNoteTA", 32, (0, lib_1.byte)(exports.maxNoteTA - exports.minNoteTA));
    return promises_1.default.writeFile(file, str);
}
exports.generateNotes = generateNotes;
exports.octaveNotes = ["C", "Cs", "D", "Ds", "E", "F", "Fs", "G", "Gs", "A", "As", "B",];
function getNoteByName(note) {
    const search = note.toLowerCase();
    return exports.allNotes.find((v) => v.name.toLowerCase() === search);
}
exports.getNoteByName = getNoteByName;
function getNoteByID(note) {
    return exports.allNotes.find((v) => v.id === note);
}
exports.getNoteByID = getNoteByID;
class SongNote {
    constructor(note, delay, tie) {
        this.isStop = false;
        this.subtype = commands_1.SongCommandSubtype.NotCommand;
        this.note = note;
        this.tie = tie !== null && tie !== void 0 ? tie : false;
        this.delay = delay;
    }
    clone() {
        return new SongNote(this.note, this.delay, this.tie);
    }
    equals(item, options) {
        if (!(item instanceof SongNote) || item.delay !== this.delay || item.tie !== this.tie) {
            return false;
        }
        if (!options.noteShift || this.note === null || item.note === null) {
            return item.note === this.note;
        }
        if (item.note.id < 2) {
            return item.note === this.note;
        }
        return item.note.id === this.note.id + options.noteShift;
    }
    getByteCount() {
        let ret = +this.tie + +(this.note !== null);
        if (this.delay) {
            ret += -1 + (2 * this.getDelay().length);
        }
        return ret;
    }
    getDelay() {
        if (this.delay === null) {
            return [];
        }
        else if (this.delay <= 0x100) {
            return [this.delay,];
        }
        let d = this.delay;
        const ret = [];
        while (d >= 0x100) {
            ret.push(0x100);
            d -= 0x100;
        }
        if (d > 0) {
            ret.push(d);
        }
        return ret;
    }
    getConnector() {
        var _a, _b;
        if (((_a = this.note) === null || _a === void 0 ? void 0 : _a.name) === "nrst") {
            return exports.noteRest;
        }
        else if (((_b = this.note) === null || _b === void 0 ? void 0 : _b.name) === "ncut") {
            return exports.noteCut;
        }
        return null;
    }
    getLines(song, iscache) {
        var _a, _b;
        const ret = [];
        let str = "\tdc.b ", items = 0;
        if (this.tie) {
            str += "sTie";
            items++;
        }
        if (this.note !== null) {
            if (items > 0) {
                str += ",";
            }
            str += this.note.name;
            items++;
        }
        const delay = this.getDelay();
        for (let i = 0; i < delay.length; i++) {
            if (items > 0) {
                str += ",";
            }
            if (i > 0) {
                str += ((_b = (_a = this.getConnector()) === null || _a === void 0 ? void 0 : _a.name) !== null && _b !== void 0 ? _b : "sTie") + ",";
            }
            const dh = (0, lib_1.hex)(2, delay[i]);
            items++;
            if (iscache) {
                str += "%!delay:" + dh;
            }
            else {
                str += includer_1.delayEqus.includes("l" + dh) ? "l" + dh : "lext,0x" + (dh === "100" ? "0" : dh);
            }
            if (items >= 5) {
                ret.push(str);
                items = 0;
                str = "\tdc.b ";
            }
        }
        if (items > 0) {
            ret.push(str);
        }
        return ret;
    }
}
exports.SongNote = SongNote;
function getFreq(note, octave) {
    return octaveHz[note] * [1 / 4096, 1 / 2048, 1 / 1024, 1 / 512, 1 / 256, 1 / 128, 1 / 64, 1 / 32, 1 / 16, 1 / 8, 1 / 4, 1 / 2, 1, 2, 4, 8, 16, 32, 64, 128, 256,][octave + 8];
}
exports.getFreq = getFreq;
const octaveHz = [
    261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88,
    523.25,
];
exports.freqTableDAC = [];
exports.freqDistDAC = [];
exports.minNoteDAC = -8 * 0xC;
exports.maxNoteDAC = 8 * 0xC;
const magicDAC = 0x100 / octaveHz[0];
function generateNoteTableDAC(file) {
    for (let n = 0; n < -exports.minNoteDAC; n++) {
        exports.freqTableDAC[-1 - n] = -Math.round(getFreq(n % 0xC, Math.floor(n / 0xC)) * magicDAC);
    }
    for (let n = 0; n < exports.maxNoteDAC; n++) {
        exports.freqTableDAC[n] = Math.round(getFreq(n % 0xC, Math.floor(n / 0xC)) * magicDAC);
    }
    makeNoteDiffs(exports.freqTableDAC, exports.freqDistDAC, 0xFFF, exports.minNoteDAC, exports.maxNoteDAC);
    return saveFreqTable(file, exports.freqTableDAC, exports.freqDistDAC);
}
exports.generateNoteTableDAC = generateNoteTableDAC;
exports.freqTableTA = [];
exports.freqDistTA = [];
exports.minNoteTA = 0;
exports.maxNoteTA = 0x7F;
function generateNoteTableTA(file) {
    let n = exports.minNoteTA;
    for (; n < exports.maxNoteTA - 1; n++) {
        exports.freqTableTA[n] = 0x3FF - Math.min(0x3FF, Math.floor(3579545 / (29.96 * getFreq(n % 0xC, 1 + Math.floor(n / 0xC)))));
    }
    exports.freqTableTA[exports.maxNoteTA - 1] = 0x3FF;
    makeNoteDiffs(exports.freqTableTA, exports.freqDistTA, 0x3FF, exports.minNoteTA, exports.maxNoteTA);
    return saveFreqTable(file, exports.freqTableTA, exports.freqDistTA);
}
exports.generateNoteTableTA = generateNoteTableTA;
exports.freqTablePSG = [];
exports.freqDistPSG = [];
exports.minNotePSG = 0;
exports.maxNotePSG = 0x7F;
function generateNoteTablePSG(file) {
    let n = exports.minNotePSG;
    for (; n < (0xC * 7) + 10; n++) {
        exports.freqTablePSG[n] = Math.min(0x3FF, Math.round(3579545 / (32 * getFreq(n % 0xC, 2 + Math.floor(n / 0xC)))));
    }
    for (; n < exports.maxNotePSG; n++) {
        exports.freqTablePSG[n] = 0;
    }
    makeNoteDiffs(exports.freqTablePSG, exports.freqDistPSG, 0, exports.minNotePSG, exports.maxNotePSG);
    return saveFreqTable(file, exports.freqTablePSG, exports.freqDistPSG);
}
exports.generateNoteTablePSG = generateNoteTablePSG;
exports.freqTableFM = [];
exports.freqDistFM = [];
exports.minNoteFM = -0xC * 5;
exports.maxNoteFM = 0x7F;
function generateNoteTableFM(file) {
    let n = exports.minNoteFM;
    for (; n < 0; n++) {
        exports.freqTableFM[n] = Math.round((144 * getFreq((n + 0xC0) % 0xC, 4 + Math.floor(n / 0xC)) * Math.pow(2, 20) / 7670454) / Math.pow(2, (4 - 1)));
    }
    for (; n < 0xC * 8; n++) {
        exports.freqTableFM[n] = (Math.floor(n / 0xC) * 0x800) | Math.round((144 * getFreq(n % 0xC, 4) * Math.pow(2, 20) / 7670454) / Math.pow(2, (4 - 1)));
    }
    for (; n < exports.maxNoteFM; n++) {
        exports.freqTableFM[n] = Math.min(0x3FFF, 0x3800 + Math.round((144 * getFreq(n % 0xC, -3 + Math.floor(n / 0xC)) * Math.pow(2, 20) / 7670454) / Math.pow(2, (4 - 1))));
    }
    const C1 = Math.round((144 * getFreq(12, 4) * Math.pow(2, 20) / 7670454) / Math.pow(2, (4 - 1)));
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x0000, 0xC * 0, 0xC * 1);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x0800, 0xC * 1, 0xC * 2);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x1000, 0xC * 2, 0xC * 3);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x1800, 0xC * 3, 0xC * 4);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x2000, 0xC * 4, 0xC * 5);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x2800, 0xC * 5, 0xC * 6);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x3000, 0xC * 6, 0xC * 7);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, C1 | 0x3800, 0xC * 7, 0xC * 8);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, exports.freqTableFM[0], exports.minNoteFM, 0);
    makeNoteDiffs(exports.freqTableFM, exports.freqDistFM, 0x3FFF, 0xC * 8, exports.maxNoteFM);
    return saveFreqTable(file, exports.freqTableFM, exports.freqDistFM);
}
exports.generateNoteTableFM = generateNoteTableFM;
function makeNoteDiffs(freq, diff, lastfreq, start, end) {
    for (let k = start; k < end; k++) {
        diff[k] = (k + 1 === end ? lastfreq : freq[k + 1]) - freq[k];
    }
}
function saveFreqTable(file, freq, diff) {
    let str = "";
    for (const key of Object.keys(freq).map((k) => parseInt(k, 10)).sort((a, b) => a - b)) {
        str += "\tdc.w " + (0, lib_1.word)(Math.abs(diff[key]) << 8) + "," + (0, lib_1.word)(freq[key]) + "\n";
    }
    return promises_1.default.writeFile(file, str);
}
function calcRawFreq(frac, type) {
    switch (true) {
        case song_1.channeListDAC.includes(type): {
            const rf = frac;
            return exports.freqTableDAC[rf >> 8] + Math.floor((exports.freqDistDAC[rf >> 8] * (rf & 0xFF) / 256));
        }
        case song_1.channeListFMAll.includes(type): {
            const rf = frac;
            return exports.freqTableFM[rf >> 8] + Math.floor((exports.freqDistFM[rf >> 8] * (rf & 0xFF) / 256));
        }
        case song_1.channeListPSG.includes(type): {
            const rf = frac;
            return exports.freqTablePSG[rf >> 8] - Math.floor((-exports.freqDistPSG[rf >> 8] * (rf & 0xFF) / 256));
        }
        case type === song_1.ChannelType.TA: {
            const rf = frac;
            return exports.freqTableTA[rf >> 8] - Math.floor((-exports.freqDistTA[rf >> 8] * (rf & 0xFF) / 256));
        }
    }
    return NaN;
}
exports.calcRawFreq = calcRawFreq;
function calcFracForFreq(freq, type) {
    switch (true) {
        case song_1.channeListPSG.includes(type): {
            if (freq <= 0) {
                return 0x5E00;
            }
            if (freq >= 0x3FF) {
                return 0x0800;
            }
            for (let n = 0x5D; n >= 8; --n) {
                if (exports.freqTablePSG[n] >= freq) {
                    return n << 8 | Math.ceil(256 * ((exports.freqTablePSG[n] - freq) / -exports.freqDistPSG[n]));
                }
            }
            break;
        }
        case type === song_1.ChannelType.TA: {
            if (freq <= 0) {
                return exports.maxNoteTA << 8;
            }
            if (freq >= 0x3FF) {
                return exports.minNoteTA << 8;
            }
            for (let n = exports.maxNoteTA; n >= exports.minNoteTA; --n) {
                if (exports.freqTableTA[n] <= freq) {
                    return n << 8 | Math.ceil(256 * ((exports.freqTableTA[n] - freq) / -exports.freqDistTA[n]));
                }
            }
            break;
        }
        case song_1.channeListFMAll.includes(type): {
            if (freq <= exports.freqTableFM[exports.minNoteFM]) {
                return exports.minNoteFM << 8;
            }
            if (freq >= exports.freqTableFM[exports.maxNoteFM]) {
                return exports.maxNoteFM << 8;
            }
            for (let n = exports.maxNoteFM; n >= exports.minNoteFM; --n) {
                if (exports.freqTableFM[n] <= freq) {
                    return n << 8 | Math.ceil(256 * ((exports.freqTableFM[n] - freq) / -exports.freqDistFM[n]));
                }
            }
            break;
        }
    }
    return NaN;
}
exports.calcFracForFreq = calcFracForFreq;
