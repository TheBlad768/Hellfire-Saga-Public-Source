"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SmokerPanMacro = exports.SmokerOperatorMacro = exports.SmokerVolumeMacro = exports.SmokerArpeggioMacro = exports.SmokerPitchMacro = exports.SmokerPhaseResetMacro = exports.SmokerDutyMacro = exports.SmokerInstrument = exports.wtfDetune = exports.loadInstrument = void 0;
const furnace_module_interface_1 = require("../../shared/furnace-module-interface");
const commands_1 = require("../../shared/commands");
const envelopes_1 = require("../../shared/envelopes");
const items_1 = require("../../shared/items");
const lib_1 = require("../../shared/lib");
const routines_1 = require("../../shared/routines");
const library_1 = require("./library");
function loadInstrument(c, instrument) {
    var _a;
    const version = (0, library_1.isValidVersion)(c, instrument.getVersion());
    if (version === 0) {
        return false;
    }
    const name = (0, library_1.sanitizeLabel)(c, instrument.name, (0, lib_1.hex)(2, c.instruments.length));
    const ins = new SmokerInstrument(name, instrument, version);
    c.instruments.push(ins);
    (_a = c.song.voiceRoutine) === null || _a === void 0 ? void 0 : _a.items.push(ins.voice);
    c.song.voices.push(ins.voice);
    return true;
}
exports.loadInstrument = loadInstrument;
exports.wtfDetune = [7, 6, 5, 0, 1, 2, 3, 4,];
class SmokerInstrument {
    constructor(name, base, version) {
        this.name = name;
        this.base = base;
        this.version = version;
        this.viewFM = this.base.getView(furnace_module_interface_1.FurnaceInstrumentTypeEnum.OPMOPN);
        const viewPSG = this.base.getView(furnace_module_interface_1.FurnaceInstrumentTypeEnum.Standard);
        const viewAmiga = this.base.getView(furnace_module_interface_1.FurnaceInstrumentTypeEnum.Amiga);
        this.sampleRef = viewAmiga.sampleId;
        this.voice = new items_1.Voice(name);
        this.createVoice();
        this.name = name;
        this.version = version;
        this.reg = {};
        switch (base.type) {
            case furnace_module_interface_1.FurnaceInstrumentTypeEnum.Standard:
            case furnace_module_interface_1.FurnaceInstrumentTypeEnum.OPMOPN:
            case furnace_module_interface_1.FurnaceInstrumentTypeEnum.Amiga:
                this.type = base.type;
                break;
            default:
                this.type = furnace_module_interface_1.FurnaceInstrumentTypeEnum.Standard;
                break;
        }
        this.macros = { ops: [], };
        if (this.viewFM.volumeMacro && this.viewFM.volumeMacro.data.length > 0) {
            this.macros.volume = new SmokerVolumeMacro(this.viewFM.volumeMacro);
        }
        if (this.viewFM.arpeggioMacro && this.viewFM.arpeggioMacro.data.length > 0) {
            this.macros.arpeggio = new SmokerArpeggioMacro(this.viewFM.arpeggioMacro);
        }
        if (this.viewFM.pitchMacro && this.viewFM.pitchMacro.data.length > 0) {
            this.macros.pitch = new SmokerPitchMacro(this.viewFM.pitchMacro);
        }
        if (this.viewFM.hardPanMacro && this.viewFM.hardPanMacro.data.length > 0) {
            this.macros.pan = new SmokerPanMacro(this.viewFM.hardPanMacro);
        }
        if (this.viewFM.phaseResetMacro && this.viewFM.phaseResetMacro.data.length > 0) {
            this.macros.phaseReset = new SmokerPhaseResetMacro(this.viewFM.phaseResetMacro);
        }
        if (viewPSG.noiseModeMacro && viewPSG.noiseModeMacro.data.length > 0) {
            this.macros.duty = new SmokerDutyMacro(viewPSG.noiseModeMacro);
        }
        for (const op of this.viewFM.operators) {
            for (const item of [
                { macro: "amplitudeModulationMacro", prop: "multiple", reg: 0x30, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "detune", reg: 0x30, func: (v) => { var _a; return (_a = exports.wtfDetune[v]) !== null && _a !== void 0 ? _a : 0; }, },
                { macro: "amplitudeModulationMacro", prop: "totallevel", reg: 0x40, func: (v) => 0x7F - v, },
                { macro: "amplitudeModulationMacro", prop: "attackrate", reg: 0x50, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "decay1rate", reg: 0x60, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "ampmod", reg: 0x60, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "decay2rate", reg: 0x70, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "releaserate", reg: 0x80, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "decay1level", reg: 0x80, func: (v) => v, },
                { macro: "amplitudeModulationMacro", prop: "ssgeg", reg: 0x90, func: (v) => v, },
            ]) {
                if (op[item.macro] && op[item.macro].data.length > 0) {
                    this.macros.ops.push(new SmokerOperatorMacro(op[item.macro], item.reg, item.prop, item.func));
                }
            }
        }
    }
    getVoice() {
        return new commands_1.SongSetVoice(this.voice);
    }
    makeDynamicVoice() {
        for (const o of this.macros.ops) {
            this.reg[o.reg] = this.voice.getRegister(o.reg);
        }
        return this.voice.clone();
    }
    getVolumeMacro(c, ch) {
        const mac = getInstrumentVolumeMacro(c, ch, this);
        return mac ? new commands_1.SongSetVolumeEnvelope(mac) : null;
    }
    getArpeggioMacro(c, ch) {
        const mac = getInstrumentArpeggioMacro(c, ch, this);
        return mac ? new commands_1.SongSetFractionEnvelope(mac) : null;
    }
    getArpeggioMacroPSG4(c) {
        const mac = getInstrumentArpeggioMacroPSG4(c);
        return mac ? new commands_1.SongSetFractionEnvelope(mac) : null;
    }
    createVoice() {
        var _a;
        this.voice.slot = (_a = items_1.slotLUT[this.viewFM.algorithm]) !== null && _a !== void 0 ? _a : [true, true, true, true,];
        this.voice.algorithm = this.viewFM.algorithm;
        this.voice.feedback = this.viewFM.feedback;
        this.voice.ams = this.viewFM.ams;
        this.voice.fms = this.viewFM.fms;
        const ops = [this.viewFM.operators[0], this.viewFM.operators[1], this.viewFM.operators[2], this.viewFM.operators[3],];
        this.voice.ampmod = ops.map((o) => o.amplitudeModulation);
        this.voice.attackrate = ops.map((o) => o.attackRate);
        this.voice.decay1level = ops.map((o) => o.decay1Level);
        this.voice.decay1rate = ops.map((o) => o.decay1Rate);
        this.voice.decay2rate = ops.map((o) => o.decay2Rate);
        this.voice.detune = ops.map((o) => { var _a; return (_a = exports.wtfDetune[o.detune]) !== null && _a !== void 0 ? _a : 0; });
        this.voice.multiple = ops.map((o) => o.multiple);
        this.voice.ratescale = ops.map((o) => o.rateScale);
        this.voice.releaserate = ops.map((o) => o.releaseRate);
        this.voice.ssgeg = ops.map((o) => o.ssgeg);
        this.voice.totallevel = ops.map((o) => o.totalLevel);
        return this.voice;
    }
}
exports.SmokerInstrument = SmokerInstrument;
class SmokerDutyMacro {
    constructor(macro) {
        this.macro = macro;
        this.putInTracker = false;
        this.resetMacro();
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
    }
    nextValue() {
        return nextValueHelper(this, (v) => v);
    }
}
exports.SmokerDutyMacro = SmokerDutyMacro;
class SmokerPhaseResetMacro {
    constructor(macro) {
        this.macro = macro;
        this.putInTracker = false;
        this.resetMacro();
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
    }
    nextValue() {
        return nextValueHelper(this, (v) => v);
    }
}
exports.SmokerPhaseResetMacro = SmokerPhaseResetMacro;
class SmokerPitchMacro {
    constructor(macro) {
        this.macro = macro;
        this.resetMacro();
        this.setMode(false);
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    setMode(mode) {
        this.additive = mode;
        this.putInTracker = this.additive && typeof this.macro.loop === "number";
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
        this.lastFetch = 0;
    }
    nextValue() {
        const v = nextValueHelper(this, (v) => (v * 2) + this.lastFetch);
        this.lastFetch = this.additive ? v.value : 0;
        return v;
    }
}
exports.SmokerPitchMacro = SmokerPitchMacro;
class SmokerArpeggioMacro {
    constructor(macro) {
        this.macro = macro;
        this.rootNote = macro.isAbsolute ? 0 : NaN;
        this.putInTracker = false;
        this.resetMacro();
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
    }
    nextValue() {
        return nextValueHelper(this, (v) => v * 0x100);
    }
}
exports.SmokerArpeggioMacro = SmokerArpeggioMacro;
function getNullEnvelope(c) {
    const ev = c.song.envelopes.find((e) => e.name === "Null");
    if (!ev) {
        c.helper.error(c.getInfo(), "Internal error: Envelope Null was not found. This should be impossible!");
        return null;
    }
    return ev;
}
function createEnvelopeRoutines(c, name, loop) {
    const routine = (0, library_1.createRoutine)(c, name, routines_1.RoutineType.EnvelopeTrack, {});
    if (!routine) {
        c.helper.error(c.getInfo(), "Internal error: Unable to create envelope routine " + name);
        return null;
    }
    let loopRoutine = null;
    if (loop) {
        loopRoutine = (0, library_1.createRoutine)(c, name + "_Loop", routines_1.RoutineType.EnvelopeTrack, {});
        if (!loopRoutine) {
            c.helper.error(c.getInfo(), "Internal error: Unable to create envelope routine " + name + "_Loop");
            return null;
        }
    }
    return { routine, loopRoutine, };
}
function getInstrumentArpeggioMacro(c, ch, ins) {
    var _a, _b, _c, _d, _e, _f, _g;
    const macros = [];
    if (((_a = ins.macros.arpeggio) === null || _a === void 0 ? void 0 : _a.putInTracker) === false) {
        macros.push({ macro: ins.macros.arpeggio, });
    }
    if (((_b = ins.macros.pitch) === null || _b === void 0 ? void 0 : _b.putInTracker) === false) {
        macros.push({ macro: ins.macros.pitch, });
    }
    if (macros.length === 0) {
        return getNullEnvelope(c);
    }
    if (ins.macros.fracEnv) {
        return ins.macros.fracEnv;
    }
    const name = "Frac_" + ins.name;
    const ret = createEnvelopeRoutines(c, name, ((_d = (_c = ins.macros.arpeggio) === null || _c === void 0 ? void 0 : _c.hasLoop()) !== null && _d !== void 0 ? _d : false) || ((_f = (_e = ins.macros.pitch) === null || _e === void 0 ? void 0 : _e.hasLoop()) !== null && _f !== void 0 ? _f : false));
    if (!ret) {
        return false;
    }
    const ev = new envelopes_1.Envelope(name, ret.routine);
    (_g = c.song.envelopeRoutine) === null || _g === void 0 ? void 0 : _g.items.push(ev);
    c.song.envelopes.push(ev);
    ins.macros.fracEnv = ev;
    if (!loadInstrumentEnvelope(c, ch, ret.routine, ret.loopRoutine, macros)) {
        const convertIx = macros[0].macro.getSize() > macros[1].macro.getSize() ? 0 : 1;
        macros[convertIx ^ 1].macro.putInTracker = true;
        macros[convertIx ^ 1].macro.resetMacro();
        macros[convertIx].macro.resetMacro();
        if (!loadInstrumentEnvelope(c, ch, ret.routine, ret.loopRoutine, [macros[convertIx],])) {
            return getNullEnvelope(c);
        }
    }
    return ev;
}
function getInstrumentArpeggioMacroPSG4(c) {
    return getNullEnvelope(c);
}
class SmokerVolumeMacro {
    constructor(macro) {
        this.macro = macro;
        this.putInTracker = false;
        this.resetMacro();
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
    }
    nextValue(type) {
        return nextValueHelper(this, (0, library_1.isPSG)(type) ? ((v) => v === 0 ? 0x7F : (0xF - v) * 8) : (v) => 0x7F - v);
    }
}
exports.SmokerVolumeMacro = SmokerVolumeMacro;
function getInstrumentVolumeMacro(c, ch, ins) {
    var _a;
    if (!ins.macros.volume) {
        return getNullEnvelope(c);
    }
    const target = (0, library_1.isPSG)(ch.type) ? "volEnvPSG" : "volEnv";
    if (ins.macros[target]) {
        return ins.macros[target];
    }
    const name = "Vol" + ((0, library_1.isPSG)(ch.type) ? "PSG" : "") + "_" + ins.name;
    const ret = createEnvelopeRoutines(c, name, ins.macros.volume.hasLoop());
    if (!ret) {
        return false;
    }
    const ev = new envelopes_1.Envelope(name, ret.routine);
    (_a = c.song.envelopeRoutine) === null || _a === void 0 ? void 0 : _a.items.push(ev);
    c.song.envelopes.push(ev);
    ins.macros[target] = ev;
    loadInstrumentEnvelope(c, ch, ret.routine, ret.loopRoutine, [{ macro: ins.macros.volume, },]);
    return ev;
}
function loadInstrumentEnvelope(c, ch, routine, loop, macros) {
    var _a;
    if (macros.length === 0) {
        return false;
    }
    const macExtend = macros.map((m) => { return Object.assign(Object.assign({}, m), { loop: -1, loopStarted: false }); });
    let activeRoutine = routine;
    let len = 0, value = NaN, lastdelay = 1, items = 0;
    const updateValue = () => {
        if (!isNaN(value)) {
            if (lastdelay !== len) {
                lastdelay = len;
                activeRoutine.items.push(new envelopes_1.EnvelopeDelay(len));
            }
            activeRoutine.items.push(new envelopes_1.EnvelopeValue(value));
            len = 0;
        }
    };
    while (true) {
        const next = macExtend.map((m) => m.macro.nextValue(ch.type));
        const nextValue = next.map((n) => n.value).reduce((v, acc) => acc + v, 0);
        macExtend.forEach((m, i) => {
            m.loopStarted = m.loopStarted || next[i].loop || next[i].end;
            if (m.loopStarted && m.loop < 0) {
                m.loop = next[i].end ? NaN : next[i].position;
            }
        });
        const allLoops = !macExtend.map((m, i) => m.loopStarted && (isNaN(m.loop) || m.loop === next[i].position)).includes(false);
        if (allLoops) {
            if (activeRoutine === loop || !loop) {
                if (!loop) {
                    updateValue();
                    value = nextValue;
                    len = len || 1;
                }
                break;
            }
            updateValue();
            activeRoutine = loop;
            len = 0;
            lastdelay = NaN;
            value = NaN;
            items = 0;
        }
        if (++items > ((_a = c.helper.options.maxMacroLength) !== null && _a !== void 0 ? _a : 128)) {
            routine.items = [];
            loop && (loop.items = []);
            return false;
        }
        if (value !== nextValue) {
            updateValue();
            value = nextValue;
        }
        len++;
    }
    updateValue();
    if (loop) {
        activeRoutine.items.push(new envelopes_1.EnvelopeJump(loop));
    }
    else {
        activeRoutine.items.splice(activeRoutine.items.length - 1, 0, new envelopes_1.EnvelopeHold());
    }
    return true;
}
class SmokerOperatorMacro {
    constructor(macro, reg, prop, convert) {
        var _a;
        this.macro = macro;
        this.prop = prop;
        this.convert = convert;
        this.putInTracker = true;
        this.reg = reg | (((_a = macro["operator"]) !== null && _a !== void 0 ? _a : 0) << 2);
        this.resetMacro();
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
    }
    nextValue() {
        return nextValueHelper(this, this.convert);
    }
}
exports.SmokerOperatorMacro = SmokerOperatorMacro;
class SmokerPanMacro {
    constructor(macro) {
        this.macro = macro;
        this.putInTracker = true;
        this.resetMacro();
    }
    hasLoop() {
        return typeof this.macro.loop === "number" && this.macro.loop < this.macro.data.length;
    }
    getSize() {
        return this.macro.data.length + (this.hasLoop() ? 0x1000 : 0);
    }
    resetMacro() {
        this.position = -1;
        this.last = 0x1000;
    }
    nextValue() {
        return nextValueHelper(this, (v) => [0x80, 0x7F, -0x7F, 0x00,][v & 3]);
    }
}
exports.SmokerPanMacro = SmokerPanMacro;
function nextValueHelper(macro, valueConverter) {
    let actualVal = macro.macro.data[0];
    let position = macro.position;
    if (macro.position >= 0) {
        actualVal = macro.macro.data[macro.position++];
    }
    else {
        macro.position = 1;
        position = 0;
    }
    const retValue = valueConverter(actualVal);
    let end = false;
    if (macro.position >= macro.macro.data.length) {
        if (!macro.hasLoop()) {
            macro.position = macro.macro.data.length - 1;
            end = true;
        }
        else {
            macro.position = macro.macro.loop;
        }
    }
    const nextVal = valueConverter(macro.macro.data[macro.position]);
    const change = nextVal !== macro.last;
    macro.last = retValue;
    return { value: retValue, next: nextVal, position, change, loop: macro.macro.loop === position, end, };
}
