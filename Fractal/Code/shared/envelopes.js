"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EnvelopeHold = exports.EnvelopeMute = exports.EnvelopeJump = exports.EnvelopeDelay = exports.EnvelopeValue = exports.Envelope = void 0;
const includer_1 = require("../includer");
const lib_1 = require("./lib");
class Envelope {
    constructor(name, routine) {
        this.name = name;
        this.routine = routine;
    }
    clone() {
        throw new Error("Can not clone envelopes!");
    }
    getEquate(s) {
        return "env_" + s.moduleId + "_" + this.name;
    }
    getLines() {
        return [
            "\tdc.l " + this.routine.label.name,
        ];
    }
    getByteCount() {
        return 4;
    }
    equals(item) {
        return item instanceof Envelope && (item.routine === this.routine);
    }
}
exports.Envelope = Envelope;
class EnvelopeValue {
    constructor(value) {
        this.isStop = false;
        this.value = value;
    }
    clone() {
        return new EnvelopeValue(this.value);
    }
    getDetails() {
        if (this.value > -0x40 && this.value < 0x40) {
            return { bytes: 1, lines: [(0, lib_1.padTo)(64, "\tdc.b " + (0, lib_1.byte)(this.value + 0x3F)),], };
        }
        if ((this.value & 0xFF) === 0 && this.value > -0x2F00 && this.value < 0x2F00) {
            return { bytes: 1, lines: [(0, lib_1.padTo)(64, "\tdc.b " + (0, lib_1.byte)((this.value >> 8) + 0x2E + 0xA0)),], };
        }
        if ((this.value & 0xFF) === 0 && this.value > -0x8100 && this.value < 0x8000) {
            return { bytes: 2, lines: [(0, lib_1.padTo)(64, "\tdc.b evcom_ReadUpper," + (0, lib_1.byte)(this.value >> 8)),], };
        }
        if (this.value >= 0x40 && this.value < 0xC0) {
            return { bytes: 2, lines: [(0, lib_1.padTo)(64, "\tdc.b evcom_ReadLower," + (0, lib_1.byte)(this.value - 0x40)),], };
        }
        if (this.value <= -0x40 && this.value > -0xC0) {
            return { bytes: 2, lines: [(0, lib_1.padTo)(64, "\tdc.b evcom_ReadLower," + (0, lib_1.byte)(this.value + 0x3F)),], };
        }
        return { bytes: 3, lines: [
                "\tdc.b evcom_ReadFull",
                (0, lib_1.padTo)(64, "\tdc.w " + (0, lib_1.word)(this.value)),
            ], };
    }
    getLines() {
        return this.getDetails().lines;
    }
    getByteCount() {
        return this.getLines.length;
    }
    equals(item) {
        return item instanceof EnvelopeValue && (item.value === this.value);
    }
}
exports.EnvelopeValue = EnvelopeValue;
class EnvelopeDelay {
    constructor(value) {
        this.isStop = false;
        this.value = value;
        if (value >= 0x100) {
            throw new Error("Delay value " + (0, lib_1.byte)(value) + " is out of range.");
        }
    }
    clone() {
        return new EnvelopeDelay(this.value);
    }
    getLines() {
        return ["\tdc.b evcom_Delay," + (0, lib_1.byte)(this.value - 1),];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof EnvelopeDelay && (item.value === this.value);
    }
}
exports.EnvelopeDelay = EnvelopeDelay;
class EnvelopeJump {
    constructor(target) {
        this.isStop = true;
        this.target = target;
    }
    clone() {
        return new EnvelopeJump(this.target);
    }
    getLines() {
        return [
            "\tdc.b evcom_Jump",
            "\tdc.w (" + this.target.label.name + ")-" + includer_1.assemblerSettings.pcSymbol,
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof EnvelopeJump && (item.target === this.target);
    }
}
exports.EnvelopeJump = EnvelopeJump;
class EnvelopeMute {
    constructor() {
        this.isStop = true;
    }
    clone() {
        return new EnvelopeMute();
    }
    getLines() {
        return ["\tdc.b evcom_Mute,evcom_Exit",];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof EnvelopeMute;
    }
}
exports.EnvelopeMute = EnvelopeMute;
class EnvelopeHold {
    constructor() {
        this.isStop = true;
    }
    clone() {
        return new EnvelopeHold();
    }
    getLines() {
        return ["\tdc.b evcom_Hold",];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof EnvelopeHold;
    }
}
exports.EnvelopeHold = EnvelopeHold;
