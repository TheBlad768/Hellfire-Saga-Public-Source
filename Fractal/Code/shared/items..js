"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Voice = exports.Sample = exports.Vibrato = void 0;
const lib_1 = require("./lib");
class Vibrato {
    constructor(name) {
        this.name = name;
        this.delay = 0;
        this.start = 0;
        this.speed = 0x100;
        this.depth = 0;
        this.shape = "";
    }
    getEquate(s) {
        return "vib_" + s.id + "_" + this.name;
    }
    getLines() {
        return [
            "\tdc.w " + (0, lib_1.word)(this.speed) + ",vs" + this.shape + "<<8," + (0, lib_1.word)(this.depth * 2),
            "\tdc.b $" + (0, lib_1.hex)(2, this.delay) + ",$" + (0, lib_1.hex)(2, this.start),
        ];
    }
}
exports.Vibrato = Vibrato;
class Sample {
    constructor(name) {
        this.name = name;
        this.frequency = 0x100;
        this.start = ["null", "null",];
        this.loop = ["null", "null",];
        this.rest = ["null", "null",];
        this.restloop = ["null", "null",];
    }
    getEquate(s) {
        return "smp_" + s.id + "_" + this.name;
    }
    getLines() {
        return [
            "\tdc.w " + (0, lib_1.word)(this.frequency - 0x100),
            ...this.getPart(this.start),
            ...this.getPart(this.loop),
            ...this.getPart(this.rest),
            ...this.getPart(this.restloop),
            "\tdc.b \"SAMPLE\"",
        ];
    }
    getPart(data) {
        const str = [];
        if (data[0].toLowerCase() === "null") {
            str.push("\tdc.b 0,0,0");
        }
        else {
            str.push("\tdc.b (" + data[0] + ")&$FF,(((" + data[0] + ")>>8)&$7F)|$80,((" + data[0] + ")>>15)&$FF");
        }
        if (data[1].toLowerCase() === "null") {
            str.push("\tdc.b 0,0,0");
        }
        else {
            str.push("\tdc.b ((" + data[1] + ")-1)&$FF,((((" + data[1] + ")-1)>>8)&$7F)|$80,(((" + data[1] + ")-1)>>15)&$FF");
        }
        return str;
    }
}
exports.Sample = Sample;
class Voice {
    constructor(name) {
        this.convertLUT = [
            { fields: ["detune", "multiple",], shifts: [4, 0,], masks: [0x70, 0x0F,], },
            { fields: ["ratescale", "attackrate",], shifts: [6, 0,], masks: [0xC0, 0x1F,], },
            { fields: ["ampmod", "decay1rate",], shifts: [7, 0,], masks: [0x80, 0x1F,], },
            { fields: ["decay2rate",], shifts: [0,], masks: [0x1F,], },
            { fields: ["decay1level", "releaserate",], shifts: [4, 0,], masks: [0xF0, 0x0F,], },
            { fields: ["ssgeg",], shifts: [0,], masks: [0x0F,], },
            { fields: ["slot", "totallevel",], shifts: [7, 0,], masks: [0x80, 0x7F,], },
        ];
        this.name = name;
        this.algorithm = this.feedback = 0;
        this.detune = [0, 0, 0, 0,];
        this.multiple = [0, 0, 0, 0,];
        this.ratescale = [0, 0, 0, 0,];
        this.attackrate = [0, 0, 0, 0,];
        this.decay1rate = [0, 0, 0, 0,];
        this.decay2rate = [0, 0, 0, 0,];
        this.decay1level = [0, 0, 0, 0,];
        this.releaserate = [0, 0, 0, 0,];
        this.totallevel = [0, 0, 0, 0,];
        this.ssgeg = [0, 0, 0, 0,];
        this.ampmod = [0, 0, 0, 0,];
        this.slot = [false, false, false, true,];
    }
    getEquate(s) {
        return "fmv_" + s.id + "_" + this.name;
    }
    getLines() {
        const ret = ["\tdc.b \"VOI\",$" + (0, lib_1.hex)(2, ((this.feedback << 3) & 0x38) | (this.algorithm & 7)),];
        for (const c of this.convertLUT) {
            const vals = [0, 0, 0, 0,];
            for (let i = 0; i < 4; i++) {
                for (let x = 0; x < c.fields.length; x++) {
                    if (c.fields[x] === "slot") {
                        if (!this[c.fields[x]][i]) {
                            vals[i] |= 0x80;
                        }
                    }
                    else {
                        vals[i] |= (this[c.fields[x]][i] << c.shifts[x]) & c.masks[x];
                    }
                }
            }
            ret.push("\tdc.b " + vals.map((v) => "$" + (0, lib_1.hex)(2, v)).join(","));
        }
        return ret;
    }
}
exports.Voice = Voice;
