"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.omitUnusedRoutines = exports.omitUnused = void 0;
const commands_1 = require("../shared/commands");
const items_1 = require("../shared/items");
const routines_1 = require("../shared/routines");
const main_1 = require("./main");
const routines_2 = require("./routines");
function omitUnused(info) {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o, _p, _q, _r, _s;
    const voices = [];
    const samples = [];
    const vibrato = [];
    const envelopes = [info.song.envelopes[0],];
    for (const routine of info.song.routines) {
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        for (const item of routine.items) {
            if (item instanceof commands_1.SongSetVoice) {
                if (!voices.includes(item.voice)) {
                    voices.push(item.voice);
                }
            }
            else if (item instanceof commands_1.SongSetSample) {
                if (!samples.includes(item.sample)) {
                    samples.push(item.sample);
                }
            }
            else if (item instanceof commands_1.SongSetTremolo || item instanceof commands_1.SongSetVibrato) {
                if (!vibrato.includes(item.vibrato)) {
                    vibrato.push(item.vibrato);
                }
            }
            else if (item instanceof commands_1.SongSetVolumeEnvelope || item instanceof commands_1.SongSetFractionEnvelope) {
                if (!envelopes.includes(item.envelope)) {
                    envelopes.push(item.envelope);
                }
            }
        }
    }
    if (((_a = info.opt.omitUnused) === null || _a === void 0 ? void 0 : _a.voices) === true) {
        for (let v = info.song.voices.length; v >= 0; --v) {
            if (!voices.includes(info.song.voices[v])) {
                for (let i = 0; i < ((_d = (_c = (_b = info.song.voiceRoutine) === null || _b === void 0 ? void 0 : _b.items) === null || _c === void 0 ? void 0 : _c.length) !== null && _d !== void 0 ? _d : 0); i++) {
                    if (info.song.voiceRoutine.items[i] === info.song.voices[v]) {
                        info.song.voiceRoutine.items.splice(i, 1);
                        break;
                    }
                }
                info.song.voices.splice(v, 1);
            }
        }
    }
    if (((_e = info.opt.omitUnused) === null || _e === void 0 ? void 0 : _e.samples) === true && info.song.samples.length > 0) {
        for (let v = info.song.samples.length; v >= 0; --v) {
            if (!samples.includes(info.song.samples[v])) {
                for (let i = 0; i < ((_h = (_g = (_f = info.song.sampleRoutine) === null || _f === void 0 ? void 0 : _f.items) === null || _g === void 0 ? void 0 : _g.length) !== null && _h !== void 0 ? _h : 0); i++) {
                    if (info.song.sampleRoutine.items[i] === info.song.samples[v]) {
                        info.song.sampleRoutine.items.splice(i, 1);
                        break;
                    }
                }
                info.song.samples.splice(v, 1);
            }
        }
        if (info.song.samples.length === 0) {
            const s = new items_1.Sample("null");
            s.frequency = 0;
            s.start = ["null", "null",];
            s.loop = ["null", "null",];
            s.rest = ["null", "null",];
            s.restloop = ["null", "null",];
            info.song.samples.push(s);
            (_j = info.song.sampleRoutine) === null || _j === void 0 ? void 0 : _j.items.push(s);
        }
    }
    if (((_k = info.opt.omitUnused) === null || _k === void 0 ? void 0 : _k.vibrato) === true) {
        for (let v = info.song.vibrato.length; v >= 0; --v) {
            if (!vibrato.includes(info.song.vibrato[v])) {
                for (let i = 0; i < ((_o = (_m = (_l = info.song.vibratoRoutine) === null || _l === void 0 ? void 0 : _l.items) === null || _m === void 0 ? void 0 : _m.length) !== null && _o !== void 0 ? _o : 0); i++) {
                    if (info.song.vibratoRoutine.items[i] === info.song.vibrato[v]) {
                        info.song.vibratoRoutine.items.splice(i, 1);
                        break;
                    }
                }
                info.song.vibrato.splice(v, 1);
            }
        }
    }
    if (((_p = info.opt.omitUnused) === null || _p === void 0 ? void 0 : _p.envelopes) === true) {
        for (let v = info.song.envelopes.length; v >= 0; --v) {
            if (!envelopes.includes(info.song.envelopes[v])) {
                for (let i = 0; i < ((_s = (_r = (_q = info.song.envelopeRoutine) === null || _q === void 0 ? void 0 : _q.items) === null || _r === void 0 ? void 0 : _r.length) !== null && _s !== void 0 ? _s : 0); i++) {
                    if (info.song.envelopeRoutine.items[i] === info.song.envelopes[v]) {
                        info.song.envelopeRoutine.items.splice(i, 1);
                        (0, routines_2.deleteRoutine)(info, info.song.envelopes[v].routine);
                        break;
                    }
                }
                info.song.envelopes.splice(v, 1);
            }
        }
    }
}
exports.omitUnused = omitUnused;
function omitUnusedRoutines(info) {
    for (let i = 0; i < info.song.routines.length; i++) {
        const routine = info.song.routines[i];
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        let found = false;
        for (const sub of Object.values(info.song.songs)) {
            for (const ch of sub.channels) {
                if (ch.routine === routine) {
                    found = true;
                    break;
                }
            }
        }
        if (!found && (0, main_1.countReferences)(info, routine).references === 0) {
            (0, routines_2.deleteRoutine)(info, info.song.routines[i]);
            --i;
        }
    }
}
exports.omitUnusedRoutines = omitUnusedRoutines;
