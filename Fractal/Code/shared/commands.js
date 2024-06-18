"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SongBitJump = exports.SongCondJump = exports.SongCont = exports.SongCall = exports.SongJump = exports.SongSetOperatorMask = exports.SongSetAMSFMS = exports.SongSetLFO = exports.parseFMS = exports.parseAMS = exports.parseLFOFrequency = exports.SongTempo = exports.SongPortaTarget = exports.SongPortaSpeed = exports.SongQueue = exports.SongPan = exports.SongSetTL = exports.SongYMCommand = exports.SongAddTiming = exports.SongSetTiming = exports.SongBackup = exports.SongSpinReset = exports.SongSpinRev = exports.SongReturn = exports.SongStop = exports.SongAddFraction = exports.SongAddVolume = exports.SongFastCut = exports.SongSetSample = exports.SongSetVoice = exports.SongSetVolumeEnvelope = exports.SongSetFractionEnvelope = exports.SongDisableVibrato = exports.SongEnableVibrato = exports.SongDisableTremolo = exports.SongEnableTremolo = exports.SongSetVibrato = exports.SongSetTremolo = exports.SongFlags = exports.SongCommandSubtype = void 0;
const lib_1 = require("./lib");
const song_1 = require("./song");
var SongCommandSubtype;
(function (SongCommandSubtype) {
    SongCommandSubtype[SongCommandSubtype["NotCommand"] = 0] = "NotCommand";
    SongCommandSubtype[SongCommandSubtype["NormalCommand"] = 1] = "NormalCommand";
    SongCommandSubtype[SongCommandSubtype["TargetCommand"] = 2] = "TargetCommand";
    SongCommandSubtype[SongCommandSubtype["Hint"] = 3] = "Hint";
})(SongCommandSubtype = exports.SongCommandSubtype || (exports.SongCommandSubtype = {}));
class SongFlags {
    constructor(flags) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Flags";
        this.isStop = false;
        this.flags = {
            BlockUW: flags.includes("u") || flags.includes("U"),
            NoMasterFrac: flags.includes("f") || flags.includes("F"),
            NoMasterVol: flags.includes("v") || flags.includes("V"),
        };
    }
    clone() {
        const ret = new SongFlags("");
        ret.flags = Object.assign({}, this.flags);
        return ret;
    }
    getLines() {
        const fg = (0, song_1.convertMainFlags)(this.flags);
        const ex = this.flags.BlockUW ? "1<<cfVolume" : "";
        return [
            "\tdc.b " + this.commandName + "," + (fg.length > 0 ? fg + (ex.length > 0 ? "|" : "") : "") + ex,
        ];
    }
    getByteCount() {
        return 2;
    }
    equals() {
        return false;
    }
}
exports.SongFlags = SongFlags;
class SongSetTremolo {
    constructor(vibrato) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_VolVibSet";
        this.isStop = false;
        this.vibrato = vibrato;
    }
    clone() {
        return new SongSetTremolo(this.vibrato);
    }
    getLines(s) {
        return [
            "\tdc.b " + this.commandName + "," + this.vibrato.getEquate(s),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetTremolo && (item.vibrato === this.vibrato);
    }
}
exports.SongSetTremolo = SongSetTremolo;
class SongSetVibrato {
    constructor(vibrato) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_FreqVibSet";
        this.isStop = false;
        this.vibrato = vibrato;
    }
    clone() {
        return new SongSetVibrato(this.vibrato);
    }
    getLines(s) {
        return [
            "\tdc.b " + this.commandName + "," + this.vibrato.getEquate(s),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetVibrato && (item.vibrato === this.vibrato);
    }
}
exports.SongSetVibrato = SongSetVibrato;
class SongEnableTremolo {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_VolVibOn";
        this.isStop = false;
    }
    clone() {
        return new SongEnableTremolo();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongEnableTremolo;
    }
}
exports.SongEnableTremolo = SongEnableTremolo;
class SongDisableTremolo {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_VolVibOff";
        this.isStop = false;
    }
    clone() {
        return new SongDisableTremolo();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongDisableTremolo;
    }
}
exports.SongDisableTremolo = SongDisableTremolo;
class SongEnableVibrato {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_FreqVibOn";
        this.isStop = false;
    }
    clone() {
        return new SongEnableVibrato();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongEnableVibrato;
    }
}
exports.SongEnableVibrato = SongEnableVibrato;
class SongDisableVibrato {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_FreqVibOff";
        this.isStop = false;
    }
    clone() {
        return new SongDisableVibrato();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongDisableVibrato;
    }
}
exports.SongDisableVibrato = SongDisableVibrato;
class SongSetFractionEnvelope {
    constructor(envelope) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_FreqEnv";
        this.isStop = false;
        this.envelope = envelope;
    }
    clone() {
        return new SongSetFractionEnvelope(this.envelope);
    }
    getLines(s) {
        return [
            "\tdc.b " + this.commandName + "," + this.envelope.getEquate(s),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetFractionEnvelope && (item.envelope === this.envelope);
    }
}
exports.SongSetFractionEnvelope = SongSetFractionEnvelope;
class SongSetVolumeEnvelope {
    constructor(envelope) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_VolEnv";
        this.isStop = false;
        this.envelope = envelope;
    }
    clone() {
        return new SongSetVolumeEnvelope(this.envelope);
    }
    getLines(s) {
        return [
            "\tdc.b " + this.commandName + "," + this.envelope.getEquate(s),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetVolumeEnvelope && (item.envelope === this.envelope);
    }
}
exports.SongSetVolumeEnvelope = SongSetVolumeEnvelope;
class SongSetVoice {
    constructor(voice) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Voice";
        this.isStop = false;
        this.voice = voice;
    }
    clone() {
        return new SongSetVoice(this.voice);
    }
    getLines(s) {
        return [
            "\tdc.b " + this.commandName + "," + this.voice.getEquate(s),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetVoice && (item.voice === this.voice);
    }
}
exports.SongSetVoice = SongSetVoice;
class SongSetSample {
    constructor(sample) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Voice";
        this.isStop = false;
        this.sample = sample;
    }
    clone() {
        return new SongSetSample(this.sample);
    }
    getLines(s) {
        return [
            "\tdc.b " + this.commandName + "," + this.sample.getEquate(s),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetSample && (item.sample === this.sample);
    }
}
exports.SongSetSample = SongSetSample;
class SongFastCut {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_FastCut";
        this.isStop = false;
    }
    clone() {
        return new SongFastCut();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongFastCut;
    }
}
exports.SongFastCut = SongFastCut;
class SongAddVolume {
    constructor(value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Vol";
        this.isStop = false;
        if (value >= 0x80) {
            this.value = -(0x100 - value);
        }
        else {
            this.value = value;
        }
    }
    clone() {
        return new SongAddVolume(this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongAddVolume && (item.value === this.value);
    }
}
exports.SongAddVolume = SongAddVolume;
class SongAddFraction {
    constructor(value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Frac";
        this.isStop = false;
        if (value >= 0x8000) {
            this.value = -(0x10000 - value);
        }
        else {
            this.value = value;
        }
    }
    clone() {
        return new SongAddFraction(this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.w " + (0, lib_1.word)(this.value),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongAddFraction && (item.value === this.value);
    }
}
exports.SongAddFraction = SongAddFraction;
class SongStop {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Stop";
        this.isStop = true;
    }
    clone() {
        return new SongStop();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongStop;
    }
}
exports.SongStop = SongStop;
class SongReturn {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Ret";
        this.isStop = true;
    }
    clone() {
        return new SongReturn();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongReturn;
    }
}
exports.SongReturn = SongReturn;
class SongSpinRev {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_SpinRev";
        this.isStop = false;
    }
    clone() {
        return new SongSpinRev();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongSpinRev;
    }
}
exports.SongSpinRev = SongSpinRev;
class SongSpinReset {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_SpinReset";
        this.isStop = false;
    }
    clone() {
        return new SongSpinReset();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongSpinReset;
    }
}
exports.SongSpinReset = SongSpinReset;
class SongBackup {
    constructor() {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Backup";
        this.isStop = true;
    }
    clone() {
        return new SongBackup();
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
        ];
    }
    getByteCount() {
        return 1;
    }
    equals(item) {
        return item instanceof SongBackup;
    }
}
exports.SongBackup = SongBackup;
class SongSetTiming {
    constructor(byte, value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_CommSet";
        this.isStop = false;
        this.byte = byte;
        this.value = value;
    }
    clone() {
        return new SongSetTiming(this.byte, this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.byte) + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongSetTiming && (item.value === this.value && item.byte === this.byte);
    }
}
exports.SongSetTiming = SongSetTiming;
class SongAddTiming {
    constructor(byte, value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_CommAdd";
        this.isStop = false;
        this.byte = byte;
        this.value = value;
    }
    clone() {
        return new SongAddTiming(this.byte, this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.byte) + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongAddTiming && (item.value === this.value && item.byte === this.byte);
    }
}
exports.SongAddTiming = SongAddTiming;
class SongYMCommand {
    constructor(reg, value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_YMW";
        this.isStop = false;
        this.reg = reg;
        this.value = value;
    }
    clone() {
        return new SongYMCommand(this.reg, this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.reg) + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongYMCommand && (item.value === this.value && item.reg === this.reg);
    }
}
exports.SongYMCommand = SongYMCommand;
class SongSetTL {
    constructor(op, value) {
        this.op = op;
        this.value = value;
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_SetTL";
        this.isStop = false;
        this.value &= 0x7F;
    }
    clone() {
        return new SongSetTL(this.op, this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + (this.op > 1 ? "B" : "A") + "," + (0, lib_1.byte)(this.value | (this.op & 1 ? 0x80 : 0)),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetTL && (item.value === this.value && item.op === this.op);
    }
    getRegister() {
        return 0x40 | (this.op * 4);
    }
}
exports.SongSetTL = SongSetTL;
class SongPan {
    constructor(value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Pan";
        this.isStop = false;
        this.value = value;
    }
    clone() {
        return new SongPan(this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongPan && (item.value === this.value);
    }
}
exports.SongPan = SongPan;
class SongQueue {
    constructor(name) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Queue";
        this.isStop = false;
        this.name = name;
    }
    clone() {
        return new SongQueue(this.name);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.w " + this.name,
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongQueue && (item.name === this.name);
    }
}
exports.SongQueue = SongQueue;
class SongPortaSpeed {
    constructor(value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_PortaSpeed";
        this.isStop = false;
        this.value = value;
    }
    clone() {
        return new SongPortaSpeed(this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.w " + (0, lib_1.word)(this.value),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongPortaSpeed && (item.value === this.value);
    }
}
exports.SongPortaSpeed = SongPortaSpeed;
class SongPortaTarget {
    constructor(fraction) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_PortaTarget";
        this.isStop = false;
        this.fraction = fraction;
    }
    clone() {
        return new SongPortaTarget(this.fraction);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.w " + (0, lib_1.word)(this.fraction),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongPortaTarget && (item.fraction === this.fraction);
    }
}
exports.SongPortaTarget = SongPortaTarget;
class SongTempo {
    constructor(tempo, pal) {
        this.tempo = tempo;
        this.pal = pal;
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_Tempo";
        this.isStop = false;
    }
    clone() {
        return new SongTempo(this.tempo, this.pal);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.w " + (0, lib_1.word)(this.tempo) + "," + (0, lib_1.word)(this.pal ? this.tempo : Math.round(this.tempo / 50 * 60)),
        ];
    }
    getByteCount() {
        return 3;
    }
    equals(item) {
        return item instanceof SongTempo && (item.tempo === this.tempo);
    }
}
exports.SongTempo = SongTempo;
function parseLFOFrequency(data) {
    switch (data.toLowerCase()) {
        case "3.98hz": return 0x8;
        case "5.56hz": return 0x9;
        case "6.02hz": return 0xA;
        case "6.37hz": return 0xB;
        case "6.88hz": return 0xC;
        case "9.63hz": return 0xD;
        case "48.1hz": return 0xE;
        case "72.2hz": return 0xF;
        default:
            throw new Error("Invalid LFO frequency value " + data + "!");
    }
}
exports.parseLFOFrequency = parseLFOFrequency;
function parseAMS(data) {
    switch (data.toLowerCase()) {
        case "0db": return 0x00;
        case "1.4db": return 0x10;
        case "5.9db": return 0x20;
        case "11.8db": return 0x40;
        default:
            throw new Error("Invalid LFO AMS value " + data + "!");
    }
}
exports.parseAMS = parseAMS;
function parseFMS(data) {
    switch (data.toLowerCase()) {
        case "0%": return 0;
        case "3.4%": return 1;
        case "6.7%": return 2;
        case "10%": return 3;
        case "14%": return 4;
        case "20%": return 5;
        case "40%": return 6;
        case "80%": return 7;
        default:
            throw new Error("Invalid LFO FMS value " + data + "!");
    }
}
exports.parseFMS = parseFMS;
class SongSetLFO {
    constructor(value) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_LFO";
        this.isStop = false;
        this.value = value;
    }
    clone() {
        return new SongSetLFO(this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetLFO && (item.value === this.value);
    }
}
exports.SongSetLFO = SongSetLFO;
class SongSetAMSFMS {
    constructor(ams, fms) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_AMSFMS";
        this.isStop = false;
        this.value = ((ams << 4) & 0x30) | (fms & 7);
    }
    clone() {
        const ret = new SongSetAMSFMS(0, 0);
        ret.value = this.value;
        return ret;
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetAMSFMS && (item.value === this.value);
    }
}
exports.SongSetAMSFMS = SongSetAMSFMS;
class SongSetOperatorMask {
    constructor(operators) {
        this.subtype = SongCommandSubtype.NormalCommand;
        this.commandName = "com_OpMask";
        this.isStop = false;
        this.value = (+operators[0] << 4) | (+operators[1] << 5) | (+operators[2] << 6) | (+operators[3] << 7);
    }
    clone() {
        const ret = new SongSetOperatorMask([true, true, true, true,]);
        ret.value = this.value;
        return ret;
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.value),
        ];
    }
    getByteCount() {
        return 2;
    }
    equals(item) {
        return item instanceof SongSetOperatorMask && (item.value === this.value);
    }
}
exports.SongSetOperatorMask = SongSetOperatorMask;
class SongJump {
    constructor(target) {
        this.subtype = SongCommandSubtype.TargetCommand;
        this.commandName = "com_Jump";
        this.isStop = true;
        this.routine = target;
    }
    clone() {
        return new SongJump(this.routine);
    }
    getLines() {
        return [
            "\tdc.l (" + this.commandName + "<<24)+" + this.routine.label.name,
        ];
    }
    getByteCount() {
        return 4;
    }
    equals(item) {
        return item instanceof SongJump && (item.routine === this.routine);
    }
}
exports.SongJump = SongJump;
class SongCall {
    constructor(target, count) {
        this.subtype = SongCommandSubtype.TargetCommand;
        this.commandName = "com_Call";
        this.isStop = false;
        this.routine = target;
        this.count = count;
    }
    clone() {
        return new SongCall(this.routine, this.count);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.l (" + (0, lib_1.byte)(this.count & 0xFF) + "<<24)+" + this.routine.label.name,
        ];
    }
    getByteCount() {
        return 5;
    }
    equals(item) {
        return item instanceof SongCall && (item.routine === this.routine && item.count === this.count);
    }
}
exports.SongCall = SongCall;
class SongCont {
    constructor(target) {
        this.subtype = SongCommandSubtype.TargetCommand;
        this.commandName = "com_Cont";
        this.isStop = false;
        this.routine = target;
    }
    clone() {
        return new SongCont(this.routine);
    }
    getLines() {
        return [
            "\tdc.l (" + this.commandName + "<<24)+" + this.routine.label.name,
        ];
    }
    getByteCount() {
        return 4;
    }
    equals(item) {
        return item instanceof SongCont && (item.routine === this.routine);
    }
}
exports.SongCont = SongCont;
class SongCondJump {
    constructor(target, byte, value) {
        this.subtype = SongCommandSubtype.TargetCommand;
        this.commandName = "com_CondJump";
        this.isStop = false;
        this.routine = target;
        this.byte = byte;
        this.value = value;
    }
    clone() {
        return new SongCondJump(this.routine, this.byte, this.value);
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName + "," + (0, lib_1.byte)(this.byte),
            "\tdc.l (" + (0, lib_1.byte)(this.value) + "<<24)+" + this.routine.label.name,
        ];
    }
    getByteCount() {
        return 6;
    }
    equals(item) {
        return item instanceof SongCondJump && (item.routine === this.routine && item.value === this.value && item.byte === this.byte);
    }
}
exports.SongCondJump = SongCondJump;
class SongBitJump {
    constructor(target, bit, byte) {
        this.subtype = SongCommandSubtype.TargetCommand;
        this.commandName = "com_BitJump";
        this.isStop = false;
        this.routine = target;
        this.value = bit << 5 | (byte & 0x1F);
    }
    clone() {
        const ret = new SongCondJump(this.routine, 0, 0);
        ret.value = this.value;
        return ret;
    }
    getLines() {
        return [
            "\tdc.b " + this.commandName,
            "\tdc.l (" + (0, lib_1.byte)(this.value) + "<<24)+" + this.routine.label.name,
        ];
    }
    getByteCount() {
        return 5;
    }
    equals(item) {
        return item instanceof SongCondJump && (item.routine === this.routine && item.value === this.value);
    }
}
exports.SongBitJump = SongBitJump;
