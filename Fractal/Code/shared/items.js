"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.slotLUT = exports.Voice = exports.Sample = exports.Vibrato = void 0;
const includer_1 = require("../includer");
const commands_1 = require("./commands");
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
    clone() {
        throw new Error("Can not clone vibrato!");
    }
    getEquate(s) {
        return "vib_" + s.moduleId + "_" + this.name;
    }
    getLines() {
        return [
            "\tdc.w " + (0, lib_1.word)(this.speed) + ",vs" + this.shape + "<<8," + (0, lib_1.word)(this.depth * 2),
            "\tdc.b " + (0, lib_1.byte)(this.delay) + "," + (0, lib_1.byte)(this.start),
        ];
    }
    getByteCount() {
        return 8;
    }
    equals() {
        return false;
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
    clone() {
        throw new Error("Can not clone samples!");
    }
    getEquate(s) {
        return "smp_" + s.moduleId + "_" + this.name;
    }
    getByteCount() {
        return 32;
    }
    getLines() {
        const fq = this.frequency - 0x100;
        if (includer_1.assemblerSettings.badSampleFormat) {
            return [
                "\tdc.l (" + (0, lib_1.byte)(fq >> 8) + "<<24)+" + this.getPartAlt(this.start[0]),
                "\tdc.l (" + (0, lib_1.byte)(fq & 0xFF) + "<<24)+" + this.getPartAlt(this.start[1]),
                "\tdc.l " + this.getPartAlt(this.loop[0]),
                "\tdc.l " + this.getPartAlt(this.loop[1]),
                "\tdc.l " + this.getPartAlt(this.rest[0]),
                "\tdc.l " + this.getPartAlt(this.rest[1]),
                "\tdc.l " + this.getPartAlt(this.restloop[0]),
                "\tdc.l " + this.getPartAlt(this.restloop[1]),
            ];
        }
        return [
            "\tdc.w " + (0, lib_1.word)(fq),
            ...this.getPart(this.start),
            ...this.getPart(this.loop),
            ...this.getPart(this.rest),
            ...this.getPart(this.restloop),
            "\t" + includer_1.assemblerSettings.stringData + " \"SAMPLE\"",
        ];
    }
    getPartAlt(data) {
        return data.toLowerCase() === "null" ? "0" : data;
    }
    getPart(data) {
        const str = [];
        if (data[0].toLowerCase() === "null") {
            str.push("\tdc.b 0,0,0");
        }
        else {
            str.push("\tdc.b (" + data[0] + ")&0xFF,(((" + data[0] + ")>>8)&0x7F)|0x80,((" + data[0] + ")>>15)&0xFF");
        }
        if (data[1].toLowerCase() === "null") {
            str.push("\tdc.b 0,0,0");
        }
        else {
            str.push("\tdc.b ((" + data[1] + ")-1)&0xFF,((((" + data[1] + ")-1)>>8)&0x7F)|0x80,(((" + data[1] + ")-1)>>15)&0xFF");
        }
        return str;
    }
    equals() {
        return false;
    }
}
exports.Sample = Sample;
class Voice {
    constructor(name) {
        this.name = name;
        this.algorithm = this.feedback = 0;
        this.ams = this.fms = 0;
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
    clone() {
        const clone = new Voice(this.name);
        clone.algorithm = this.algorithm;
        clone.feedback = this.feedback;
        clone.ampmod = [...this.ampmod,];
        clone.attackrate = [...this.attackrate,];
        clone.decay1level = [...this.decay1level,];
        clone.decay1rate = [...this.decay1rate,];
        clone.decay2rate = [...this.decay2rate,];
        clone.detune = [...this.detune,];
        clone.multiple = [...this.multiple,];
        clone.ratescale = [...this.ratescale,];
        clone.releaserate = [...this.releaserate,];
        clone.slot = [...this.slot,];
        clone.ssgeg = [...this.ssgeg,];
        clone.totallevel = [...this.totallevel,];
        return clone;
    }
    getEquate(s) {
        return "fmv_" + s.moduleId + "_" + this.name;
    }
    getByteCount() {
        return 32;
    }
    equals() {
        return false;
    }
    getLines() {
        const ret = ["\t" + includer_1.assemblerSettings.stringData + " \"VO\"",];
        for (const c of registers) {
            const vals = c.map((c) => this.getRegister(c));
            ret.push("\tdc.b " + vals.map(lib_1.byte).join(","));
        }
        return ret;
    }
    getYmCommand(reg) {
        return new commands_1.SongYMCommand(reg, this.getRegister(reg));
    }
    getRegister(reg) {
        switch (reg) {
            case 0xB0:
                return ((this.feedback << 3) & 0x38) | (this.algorithm & 7);
            case 0xB4:
                return ((this.ams << 4) & 0x30) | (this.fms & 7);
        }
        const op = (reg & 0xC) >> 2;
        const rr = reg & 0xF0;
        switch (rr) {
            case 0x30: return this.getRegisterValue(op, ["detune", "multiple",], [4, 0,], [0x70, 0x0F,]);
            case 0x50: return this.getRegisterValue(op, ["ratescale", "attackrate",], [6, 0,], [0xC0, 0x1F,]);
            case 0x60: return this.getRegisterValue(op, ["ampmod", "decay1rate",], [7, 0,], [0x80, 0x1F,]);
            case 0x70: return this.getRegisterValue(op, ["decay2rate",], [0,], [0x1F,]);
            case 0x80: return this.getRegisterValue(op, ["decay1level", "releaserate",], [4, 0,], [0xF0, 0x0F,]);
            case 0x90: return this.getRegisterValue(op, ["ssgeg",], [0,], [0x0F,]);
            case 0x40: return this.getRegisterValue(op, ["slot", "totallevel",], [7, 0,], [0x80, 0x7F,]);
        }
        return 0xFF;
    }
    getRegisterValue(op, params, shifts, masks) {
        let value = 0;
        for (let x = 0; x < params.length; x++) {
            if (params[x] === "slot") {
                if (!this[params[x]][op]) {
                    value |= 0x80;
                }
            }
            else {
                value |= (this[params[x]][op] << shifts[x]) & masks[x];
            }
        }
        return value;
    }
}
exports.Voice = Voice;
const registers = [
    [0xB4, 0xB0,],
    [0x30, 0x34, 0x38, 0x3C,],
    [0x50, 0x54, 0x58, 0x5C,],
    [0x60, 0x64, 0x68, 0x6C,],
    [0x70, 0x74, 0x78, 0x7C,],
    [0x80, 0x84, 0x88, 0x8C,],
    [0x90, 0x94, 0x98, 0x9C,],
    [0x40, 0x44, 0x48, 0x4C,],
];
exports.slotLUT = [
    [false, false, false, true,],
    [false, false, false, true,],
    [false, false, false, true,],
    [false, false, false, true,],
    [false, false, true, true,],
    [false, true, true, true,],
    [false, true, true, true,],
    [true, true, true, true,],
];
