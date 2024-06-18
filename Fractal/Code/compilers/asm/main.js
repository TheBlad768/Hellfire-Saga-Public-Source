"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const includer_1 = require("../../includer");
const items_1 = require("../../shared/items");
const commands_1 = require("../../shared/commands");
const envelopes_1 = require("../../shared/envelopes");
const routines_1 = require("../../shared/routines");
const song_1 = require("../../shared/song");
const lib_1 = require("../../shared/lib");
const notes_1 = require("../../shared/notes");
const hints_1 = require("../../shared/hints");
module.exports = {
    version: 0.11,
    compile: (f, song, helper) => {
        return new Promise((res, rej) => {
            const c = {
                mode: CompilerMode.Info,
                status: CompilerStatus.Undefined,
                version: NaN,
                object: null,
                helper,
                song,
                index: 0,
                counter: 0,
                line: 0,
                routine: undefined,
                nextRoutine: undefined,
            };
            f.lineByLine((input) => {
                try {
                    switch (c.helper.canceled()) {
                        case includer_1.CancelReason.None:
                            procLine(input, c);
                            return false;
                        case includer_1.CancelReason.TooManyErrors:
                            throw new Error("Too many errors! Will cancel.");
                        default:
                            throw new Error("Unknown error occurred.");
                    }
                }
                catch (ex) {
                    rej(ex);
                    return true;
                }
            }).then(() => {
                if (helper.subsongs.length === 0) {
                    for (const i of Object.keys(song.songs)) {
                        helper.subsongs.push({
                            index: parseInt(i, 10),
                            id: (0, lib_1.sanitizeFilename)(helper.filename) + "_" + (0, lib_1.generateID)(),
                        });
                    }
                }
                else {
                    Object.keys(song.songs).forEach((k, ix) => {
                        const ki = parseInt(k, 10);
                        if (helper.subsongs.findIndex((s) => s.index === ki) < 0) {
                            delete song.songs[ix];
                        }
                    });
                    helper.subsongs.forEach((s) => {
                        if (!song.songs[s.index]) {
                            throw new Error("Subsong #" + (0, lib_1.hex)(2, s.index) + " does not exist in the file!");
                        }
                    });
                }
                res(c.song);
            }).catch(rej);
        });
    },
};
function procLine(input, c) {
    c.line++;
    if (input.trimStart().length === 0 || input.trimStart().startsWith(";")) {
        return;
    }
    switch (c.mode) {
        case CompilerMode.Info: return compilerModeInfo(input, c);
        case CompilerMode.Header: return compilerModeHeader(input, c);
        case CompilerMode.Channel: return compilerModeChannel(input, c);
        case CompilerMode.Body: return compilerModeBody(input, c);
    }
    c.helper.error(c.line.toString(), "Illegal compiler mode: " + c.mode);
}
var CompilerMode;
(function (CompilerMode) {
    CompilerMode[CompilerMode["Info"] = 0] = "Info";
    CompilerMode[CompilerMode["Header"] = 1] = "Header";
    CompilerMode[CompilerMode["Channel"] = 2] = "Channel";
    CompilerMode[CompilerMode["Body"] = 3] = "Body";
})(CompilerMode || (CompilerMode = {}));
function compilerModeInfo(input, c) {
    const match = /^\s*ASMCMP\s+v([0-9.]+)\s+style=(Fractal)\s*\r?$/i.exec(input);
    if (!match) {
        c.helper.error(c.line.toString(), "Identify line not in expected format!", input);
        return false;
    }
    c.version = parseFloat(match[1]);
    switch (c.version) {
        case module.exports.version:
            break;
        default:
            c.helper.error(c.line.toString(), "Invalid compiler version " + match[1] + "!", input);
            return false;
    }
    switch (match[2].toLowerCase()) {
        case "fractal":
            break;
        default:
            c.helper.error(c.line.toString(), "Invalid style " + match[2] + "!", input);
            return false;
    }
    c.mode = CompilerMode.Header;
    return true;
}
function compilerModeHeader(input, c) {
    const match = checkMacro.exec(input);
    if (!match) {
        return c.helper.error(c.line.toString(), "Expected a function at this point.", input);
    }
    return runFunction(headerMacros, match[1], match[3], c, input);
}
const headerMacros = {
    "sheadervoice": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.Voice);
            if (routine) {
                c.song.voiceRoutine = routine;
            }
        },
    },
    "sheadersamples": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.Sample);
            if (routine) {
                c.song.sampleRoutine = routine;
            }
        },
    },
    "sheadervibrato": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.Vibrato);
            if (routine) {
                c.song.vibratoRoutine = routine;
            }
        },
    },
    "sheaderenvelope": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.Envelope);
            if (routine) {
                c.song.envelopeRoutine = routine;
            }
        },
    },
    "sheaderend": {
        argCount: [0,],
        func: (c, input) => {
            c.mode = CompilerMode.Body;
            if (c.song.vibratoRoutine === null) {
                c.helper.error(c.line.toString(), "Expected sHeaderVoice before sHeaderEnd.", input);
            }
            if (c.song.vibratoRoutine === null) {
                c.helper.error(c.line.toString(), "Expected sHeaderVibrato before sHeaderEnd.", input);
            }
            if (c.song.envelopeRoutine === null) {
                c.helper.error(c.line.toString(), "Expected sHeaderEnvelope before sHeaderEnd.", input);
            }
            if (c.song.sampleRoutine === null) {
                c.helper.error(c.line.toString(), "Expected sHeaderSamples before sHeaderEnd.", input);
            }
        },
    },
};
function compilerModeChannel(input, c) {
    const match = checkMacro.exec(input);
    if (!match) {
        return c.helper.error(c.line.toString(), "Expected a function at this point.", input);
    }
    return runFunction(channelMacros, match[1], match[3], c, input);
}
const channelMacros = {
    "schannel": {
        argCount: [2,],
        func: (c, input, args) => {
            const ch = (c.song.songs[c.index].sfx ? channelTypeSFXLUT :
                c.song.songs[c.index].flags.FM3SM ? channelTypeMusic3LUT : channelTypeMusicLUT)[args[0].toLowerCase()];
            if (ch === undefined) {
                return c.helper.error(c.line.toString(), "Channel type " + args[0] + " is invalid or not supported in this mode!", input);
            }
            if (c.song.songs[c.index].channels.find((c) => c.type === ch) !== undefined) {
                return c.helper.error(c.line.toString(), "Channel type " + args[0] + " is already defined!", input);
            }
            const routine = createRoutine(c, args[1], input, routines_1.RoutineType.SongTrack);
            if (routine) {
                c.song.songs[c.index].channels.push(new song_1.Channel(ch, routine));
            }
        },
    },
    "schannelend": {
        argCount: [0,],
        func: (c) => {
            c.mode = CompilerMode.Body;
        },
    },
};
const channelTypeMusic3LUT = {
    fm1: song_1.ChannelType.FM1, fm2: song_1.ChannelType.FM2, fm3: song_1.ChannelType.FM3o1,
    fm4: song_1.ChannelType.FM4, fm5: song_1.ChannelType.FM5, fm6: song_1.ChannelType.FM6,
    dac1: song_1.ChannelType.DAC1, dac2: song_1.ChannelType.DAC2,
    fm3o1: song_1.ChannelType.FM3o1, fm3o2: song_1.ChannelType.FM3o2, fm3o3: song_1.ChannelType.FM3o3, fm3o4: song_1.ChannelType.FM3o4,
    psg1: song_1.ChannelType.PSG1, psg2: song_1.ChannelType.PSG2, psg3: song_1.ChannelType.PSG3, psg4: song_1.ChannelType.PSG4,
    ta: song_1.ChannelType.TA,
};
const channelTypeMusicLUT = {
    fm1: song_1.ChannelType.FM1, fm2: song_1.ChannelType.FM2, fm3: song_1.ChannelType.FM3o1,
    fm4: song_1.ChannelType.FM4, fm5: song_1.ChannelType.FM5, fm6: song_1.ChannelType.FM6,
    dac1: song_1.ChannelType.DAC1, dac2: song_1.ChannelType.DAC2,
    psg1: song_1.ChannelType.PSG1, psg2: song_1.ChannelType.PSG2, psg3: song_1.ChannelType.PSG3, psg4: song_1.ChannelType.PSG4,
};
const channelTypeSFXLUT = {
    fm1: song_1.ChannelType.FM1, fm2: song_1.ChannelType.FM2,
    fm4: song_1.ChannelType.FM4, fm5: song_1.ChannelType.FM5,
    dac2: song_1.ChannelType.DAC2,
    psg1: song_1.ChannelType.PSG1, psg2: song_1.ChannelType.PSG2, psg3: song_1.ChannelType.PSG3, psg4: song_1.ChannelType.PSG4,
};
function compilerModeBody(input, c) {
    var _a, _b, _c, _d, _e, _f, _g, _h;
    let ln = input;
    let match = checkLabel.exec(ln);
    if (match) {
        if (!match[1].startsWith(".")) {
            c.counter++;
        }
        resetStatus(c, input);
        createDelayedRoutine(undefined, c);
        const routine = getRoutine(c, match[1]);
        if (routine) {
            if (c.song.envelopeRoutine === routine) {
                c.status = CompilerStatus.Envelope;
                checkFallthrough(routine, c);
            }
            else if (c.song.voiceRoutine === routine) {
                c.status = CompilerStatus.Voice;
                checkFallthrough(routine, c);
            }
            else if (c.song.sampleRoutine === routine) {
                c.status = CompilerStatus.Sample;
                checkFallthrough(routine, c);
            }
            else if (c.song.vibratoRoutine === routine) {
                c.status = CompilerStatus.Vibrato;
                checkFallthrough(routine, c);
            }
            else if (routine.type === routines_1.RoutineType.EnvelopeTrack) {
                c.status = CompilerStatus.EnvelopeRoutine;
                checkFallthrough(routine, c);
                c.routine = routine;
            }
            else if (routine.type === routines_1.RoutineType.SongTrack) {
                c.status = CompilerStatus.SongRoutine;
                checkFallthrough(routine, c);
                c.routine = routine;
            }
            else {
                return c.helper.error(c.line.toString(), "Internal error: Unable to resolve compiler status based on routine type.", input);
            }
        }
        else {
            c.nextRoutine = { name: match[1], input, };
            c.status = CompilerStatus.Undefined;
        }
        ln = " " + ln.substring(match[0].length).trim();
    }
    if (ln.trim().length === 0) {
        return;
    }
    match = checkMacro.exec(input);
    if (!match) {
        return c.helper.error(c.line.toString(), "Expected a function at this point.", input);
    }
    if (anyMacros[(_b = (_a = match[1]) === null || _a === void 0 ? void 0 : _a.toLowerCase()) !== null && _b !== void 0 ? _b : ""]) {
        return runFunction(anyMacros, match[1], match[3], c, input);
    }
    if (c.status === CompilerStatus.Undefined) {
        const func = (_d = (_c = match[1]) === null || _c === void 0 ? void 0 : _c.toLowerCase()) !== null && _d !== void 0 ? _d : "";
        if (envelopeTrackMacros[func]) {
            c.status = CompilerStatus.EnvelopeRoutine;
            createDelayedRoutine(routines_1.RoutineType.EnvelopeTrack, c);
        }
        else if (songTrackMacros[func] || songYMMacros[func]) {
            c.status = CompilerStatus.SongRoutine;
            createDelayedRoutine(routines_1.RoutineType.SongTrack, c);
        }
        else {
            return c.helper.error(c.line.toString(), "Function \"" + match[1] + "\" was not recognized, or was unexpected at this point.", input);
        }
    }
    switch (c.status) {
        case CompilerStatus.Voice:
            return runFunction(voiceMacros, match[1], match[3], c, input);
        case CompilerStatus.Sample:
            return runFunction(sampleMacros, match[1], match[3], c, input);
        case CompilerStatus.Vibrato:
            return runFunction(vibratoMacros, match[1], match[3], c, input);
        case CompilerStatus.Envelope:
            return runFunction(envelopeMacros, match[1], match[3], c, input);
        case CompilerStatus.EnvelopeRoutine:
            if (!(c.routine instanceof routines_1.SongEnvelopeTrackRoutine)) {
                return c.helper.error(c.line.toString(), "Internal error: current routine is " + (c.routine ? routines_1.RoutineType[c.routine.type] : "null") + "!", input);
            }
            return runFunction(envelopeTrackMacros, match[1], match[3], c, input);
        case CompilerStatus.SongRoutine: {
            if (!(c.routine instanceof routines_1.SongTrackRoutine)) {
                return c.helper.error(c.line.toString(), "Internal error: current routine is " + (c.routine ? routines_1.RoutineType[c.routine.type] : "null") + "!", input);
            }
            const reg = songYMMacros[(_f = (_e = match[1]) === null || _e === void 0 ? void 0 : _e.toLowerCase()) !== null && _f !== void 0 ? _f : ""];
            if (typeof reg !== "number") {
                return runFunction(songTrackMacros, match[1], match[3], c, input);
            }
            const args = (_h = (_g = match[3]) === null || _g === void 0 ? void 0 : _g.split(",").map((a) => a.trim())) !== null && _h !== void 0 ? _h : [];
            if (args.length !== 1) {
                return c.helper.error(c.line.toString(), "Argument count " + args.length + " is not valid for \"" + match[1] + "\". Expected 1 argument!", input);
            }
            const val = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(val)) {
                return c.helper.error(c.line.toString(), match[1] + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongYMCommand(reg, val));
            return;
        }
    }
    return c.helper.error(c.line.toString(), "Internal error: Unable to resolve compiler status for macro processing.", input);
}
var CompilerStatus;
(function (CompilerStatus) {
    CompilerStatus[CompilerStatus["Undefined"] = 0] = "Undefined";
    CompilerStatus[CompilerStatus["SongRoutine"] = 1] = "SongRoutine";
    CompilerStatus[CompilerStatus["EnvelopeRoutine"] = 2] = "EnvelopeRoutine";
    CompilerStatus[CompilerStatus["Voice"] = 3] = "Voice";
    CompilerStatus[CompilerStatus["Sample"] = 4] = "Sample";
    CompilerStatus[CompilerStatus["Vibrato"] = 5] = "Vibrato";
    CompilerStatus[CompilerStatus["Envelope"] = 6] = "Envelope";
})(CompilerStatus || (CompilerStatus = {}));
function resetStatus(c, input) {
    if (c.object) {
        switch (c.status) {
            case CompilerStatus.Voice:
                return c.helper.error(c.line.toString(), "Expected sFinishVoice, but got a label!", input);
            case CompilerStatus.Sample:
                return c.helper.error(c.line.toString(), "Expected sFinishSample, but got a label!", input);
        }
    }
    c.status = CompilerStatus.Undefined;
}
const voiceMacros = {
    "snewvoice": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            if (c.object) {
                return c.helper.error(c.line.toString(), "Expected sFinishVoice, but got " + macro, input);
            }
            if (c.song.voices.find((e) => e.name.toLowerCase() === args[0].toLowerCase())) {
                return c.helper.error(c.line.toString(), "Voice " + args[0] + " already exists.", input);
            }
            c.object = new items_1.Voice(args[0]);
        },
    },
    "sfinishvoice": {
        argCount: [0,],
        func: (c, input, args, macro) => {
            var _a;
            if (!c.object) {
                return c.helper.error(c.line.toString(), "Did not expect " + macro + " before sNewVoice.", input);
            }
            c.song.voices.push(c.object);
            (_a = c.song.voiceRoutine) === null || _a === void 0 ? void 0 : _a.items.push(c.object);
            c.object = null;
        },
    },
    "samsfms": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            let ams = (0, lib_1.getAsmNum)(args[0]), fms = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(ams)) {
                try {
                    ams = (0, commands_1.parseAMS)(args[0]);
                }
                catch (ex) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
                }
            }
            if (isNaN(fms)) {
                try {
                    fms = (0, commands_1.parseFMS)(args[1]);
                }
                catch (ex) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[2] + " can not be converted to a number!", input);
                }
            }
            c.object.fms = fms;
            c.object.ams = ams;
        },
    },
    "salgorithm": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            var _a;
            c.object.algorithm = checkVoice1Arg(c, input, args, macro);
            c.object.slot = (_a = items_1.slotLUT[c.object.algorithm]) !== null && _a !== void 0 ? _a : [true, true, true, true,];
        },
    },
    "sfeedback": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            c.object.feedback = checkVoice1Arg(c, input, args, macro);
        },
    },
    "sdetune": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.detune = checkVoice4Arg(c, input, args, macro);
        },
    },
    "smultiple": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.multiple = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sratescale": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.ratescale = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sattackrate": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.attackrate = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sampmod": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.ampmod = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sdecay1rate": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.decay1rate = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sdecay1level": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.decay1level = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sdecay2rate": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.decay2rate = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sreleaserate": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.releaserate = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sssgeg": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.ssgeg = checkVoice4Arg(c, input, args, macro);
        },
    },
    "stotallevel": {
        argCount: [4,],
        func: (c, input, args, macro) => {
            c.object.totallevel = checkVoice4Arg(c, input, args, macro);
        },
    },
    "sslots": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            if (!c.object) {
                return c.helper.error(c.line.toString(), "Did not expect sSlots before sNewVoice.", input);
            }
            const num = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(num)) {
                return c.helper.error(c.line.toString(), "Can not convert " + macro + " argument " + args[0] + " to a number!", input);
            }
            c.object.slot = [!!(num & 8), !!(num & 4), !!(num & 2), !!(num & 1),];
        },
    },
};
function checkVoice1Arg(c, input, args, macro) {
    if (!c.object) {
        c.helper.error(c.line.toString(), "Did not expect " + macro + " before sNewVoice.", input);
        return 0;
    }
    const num = (0, lib_1.getAsmNum)(args[0]);
    if (isNaN(num)) {
        c.helper.error(c.line.toString(), "Can not convert " + macro + " argument " + args[0] + " to a number!", input);
        return 0;
    }
    return num;
}
function checkVoice4Arg(c, input, args, macro) {
    if (!c.object) {
        c.helper.error(c.line.toString(), "Did not expect " + macro + " before sNewVoice.", input);
        return [0, 0, 0, 0,];
    }
    const num = [(0, lib_1.getAsmNum)(args[0]), (0, lib_1.getAsmNum)(args[1]), (0, lib_1.getAsmNum)(args[2]), (0, lib_1.getAsmNum)(args[3]),];
    if (isNaN(num[0])) {
        c.helper.error(c.line.toString(), "Can not convert " + macro + " argument " + args[0] + " to a number!", input);
        return [0, 0, 0, 0,];
    }
    if (isNaN(num[1])) {
        c.helper.error(c.line.toString(), "Can not convert " + macro + " argument " + args[1] + " to a number!", input);
        return [0, 0, 0, 0,];
    }
    if (isNaN(num[2])) {
        c.helper.error(c.line.toString(), "Can not convert " + macro + " argument " + args[2] + " to a number!", input);
        return [0, 0, 0, 0,];
    }
    if (isNaN(num[3])) {
        c.helper.error(c.line.toString(), "Can not convert " + macro + " argument " + args[3] + " to a number!", input);
        return [0, 0, 0, 0,];
    }
    return num;
}
const sampleMacros = {
    "snewsample": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            if (c.object) {
                return c.helper.error(c.line.toString(), "Expected sFinishSample, but got " + macro, input);
            }
            if (c.song.samples.find((e) => e.name.toLowerCase() === args[0].toLowerCase())) {
                return c.helper.error(c.line.toString(), "Sample " + args[0] + " already exists.", input);
            }
            c.object = new items_1.Sample(args[0]);
        },
    },
    "sfinishsample": {
        argCount: [0,],
        func: (c, input, args, macro) => {
            var _a;
            if (!c.object) {
                return c.helper.error(c.line.toString(), "Did not expect " + macro + " before sNewSample.", input);
            }
            c.song.samples.push(c.object);
            (_a = c.song.sampleRoutine) === null || _a === void 0 ? void 0 : _a.items.push(c.object);
            c.object = null;
        },
    },
    "ssampfreq": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            if (!c.object) {
                return c.helper.error(c.line.toString(), "Did not expect " + macro + " before sNewSample.", input);
            }
            const fq = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(fq)) {
                return c.helper.error(c.line.toString(), "Argument " + args[0] + " can not be converted to a number!", input);
            }
            c.object.frequency = fq;
        },
    },
    "ssampstart": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            c.object.start = loadSampleArgs(c, input, args, macro);
        },
    },
    "ssamploop": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            c.object.loop = loadSampleArgs(c, input, args, macro);
        },
    },
    "ssamprest": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            c.object.rest = loadSampleArgs(c, input, args, macro);
        },
    },
    "ssamprestloop": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            c.object.restloop = loadSampleArgs(c, input, args, macro);
        },
    },
};
function loadSampleArgs(c, input, args, macro) {
    if (!c.object) {
        c.helper.error(c.line.toString(), "Did not expect " + macro + " before sNewSample.", input);
        return ["", "",];
    }
    return args;
}
const vibratoMacros = {
    "svibrato": {
        argCount: [6,],
        func: (c, input, args) => {
            var _a;
            if (c.song.vibrato.find((e) => e.name.toLowerCase() === args[0].toLowerCase())) {
                return c.helper.error(c.line.toString(), "Vibrato " + args[0] + " already exists.", input);
            }
            if (c.helper.shapes.find((c) => c.toLowerCase() === args[5].toLowerCase()) === undefined) {
                return c.helper.error(c.line.toString(), "Vibrato shape " + args[5] + " not found.", input);
            }
            const delay = (0, lib_1.getAsmNum)(args[1]), start = (0, lib_1.getAsmNum)(args[2]), speed = (0, lib_1.getAsmNum)(args[3]), depth = (0, lib_1.getAsmNum)(args[4]);
            if (isNaN(delay)) {
                return c.helper.error(c.line.toString(), "Vibrato delay " + args[1] + " can not be converted to a number!", input);
            }
            if (isNaN(start)) {
                return c.helper.error(c.line.toString(), "Vibrato start " + args[2] + " can not be converted to a number!", input);
            }
            if (isNaN(speed)) {
                return c.helper.error(c.line.toString(), "Vibrato speed " + args[3] + " can not be converted to a number!", input);
            }
            if (isNaN(depth)) {
                return c.helper.error(c.line.toString(), "Vibrato depth " + args[4] + " can not be converted to a number!", input);
            }
            const vb = new items_1.Vibrato(args[0]);
            vb.shape = args[5];
            vb.delay = delay;
            vb.depth = depth;
            vb.start = start;
            vb.speed = speed;
            c.song.vibrato.push(vb);
            (_a = c.song.vibratoRoutine) === null || _a === void 0 ? void 0 : _a.items.push(vb);
        },
    },
};
const envelopeMacros = {
    "senvelope": {
        argCount: [2,],
        func: (c, input, args) => {
            var _a;
            if (c.song.envelopes.find((e) => e.name.toLowerCase() === args[0].toLowerCase())) {
                return c.helper.error(c.line.toString(), "Envelope " + args[0] + " already exists.", input);
            }
            const routine = createRoutine(c, args[1], input, routines_1.RoutineType.EnvelopeTrack);
            if (routine) {
                const ev = new envelopes_1.Envelope(args[0], routine);
                c.song.envelopes.push(ev);
                (_a = c.song.envelopeRoutine) === null || _a === void 0 ? void 0 : _a.items.push(ev);
            }
        },
    },
};
const envelopeTrackMacros = {
    "senv": {
        argCount: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,],
        func: (c, input, args, macro) => {
            for (const a of args) {
                let delay = a.toLowerCase().startsWith("delay=");
                const val = (0, lib_1.getAsmNum)(!delay ? a : a.substring(6));
                if (isNaN(val)) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
                }
                c.routine.items.push(delay ? new envelopes_1.EnvelopeDelay(val) : new envelopes_1.EnvelopeValue(val));
                delay = false;
            }
        },
    },
    "sejump": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.EnvelopeTrack);
            if (routine) {
                c.routine.items.push(new envelopes_1.EnvelopeJump(routine));
            }
        },
    },
    "sehold": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            const val = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(val)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new envelopes_1.EnvelopeHold(), new envelopes_1.EnvelopeValue(val));
        },
    },
    "semute": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new envelopes_1.EnvelopeMute());
        },
    },
};
const songYMMacros = {
    "skey": 0x28,
    "sdt1": 0x30,
    "sdt2": 0x34,
    "sdt3": 0x38,
    "sdt4": 0x3C,
    "srsar1": 0x50,
    "srsar2": 0x54,
    "srsar3": 0x58,
    "srsar4": 0x5C,
    "sd1r1": 0x60,
    "sd1r2": 0x64,
    "sd1r3": 0x68,
    "sd1r4": 0x6C,
    "sd2r1": 0x70,
    "sd2r2": 0x74,
    "sd2r3": 0x78,
    "sd2r4": 0x7C,
    "sd1lrr1": 0x80,
    "sd1lrr2": 0x84,
    "sd1lrr3": 0x88,
    "sd1lrr4": 0x8C,
    "ssg1": 0x90,
    "ssg2": 0x94,
    "ssg3": 0x98,
    "ssg4": 0x9C,
    "sssgeg1": 0x90,
    "sssgeg2": 0x94,
    "sssgeg3": 0x98,
    "sssgeg4": 0x9C,
    "sfbal": 0xB0,
};
const anyMacros = {
    "ssong": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            c.mode = CompilerMode.Channel;
            const checkIndexFlags = (match, sfx) => {
                if (!match) {
                    c.helper.error(c.line.toString(), macro + " not in expected format!", input);
                    return false;
                }
                const index = (0, lib_1.getAsmNum)(match[1]);
                if (index < 0 || index > 0xFF) {
                    c.helper.error(c.line.toString(), macro + " has an invalid index!", input);
                    return false;
                }
                c.index = index;
                c.song.addSong(index, sfx, NaN, NaN);
                c.song.setFlags(match[2], c.index);
                return true;
            };
            if (args[0].trim().toLowerCase().startsWith("sfx")) {
                const match = /^sfx\s+index=([0-9A-Fx$]{1,3})\s+flags=([a-z0-9]*)\s+priority=([0-9A-Fx$]{1,3})\s*\r?$/i.exec(args[0].trim());
                if (!checkIndexFlags(match, true)) {
                    return false;
                }
                const prio = (0, lib_1.getAsmNum)(match[3]);
                c.song.songs[c.index].priority = prio;
                if (isNaN(prio)) {
                    return c.helper.error(c.line.toString(), "Priority " + match[3] + " can not be converted to a number!", input);
                }
            }
            else {
                const match = /^music\s+index=([0-9A-Fx$]{1,3})\s+flags=([a-z0-9]*)\s+tempo=([0-9A-Fx$]{1,5})\s*\r?$/i.exec(args[0].trim());
                if (!checkIndexFlags(match, false)) {
                    return false;
                }
                const tempo = (0, lib_1.getAsmNum)(match[3]);
                c.song.songs[c.index].tempo = tempo;
                if (isNaN(tempo)) {
                    return c.helper.error(c.line.toString(), "Tempo " + match[3] + " can not be converted to a number!", input);
                }
            }
        },
    },
};
const songTrackMacros = {
    "snote": {
        argCount: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,],
        func: (c, input, args, macro) => {
            let offs = 0;
            let cnote = null;
            const addNote = (nextNote) => {
                if (cnote !== null) {
                    const nobj = (0, notes_1.getNoteByName)(cnote);
                    if (!nobj && cnote.toLowerCase() !== "stie" && cnote.toLowerCase() !== "shold") {
                        return c.helper.error(c.line.toString(), macro + " argument " + cnote + " can not be converted to a note!", input);
                    }
                    c.routine.items.push(new notes_1.SongNote(nobj !== null && nobj !== void 0 ? nobj : null, null, !nobj));
                }
                cnote = nextNote;
            };
            for (const a of args) {
                switch (a[0]) {
                    case "s":
                    case "n":
                    case "S":
                    case "N": {
                        addNote(a);
                        break;
                    }
                    case "$":
                    case "%":
                    case "0":
                    case "1":
                    case "2":
                    case "3":
                    case "4":
                    case "5":
                    case "6":
                    case "7":
                    case "8":
                    case "9": {
                        const notie = !cnote;
                        const val = (0, lib_1.getAsmNum)(a);
                        if (isNaN(val)) {
                            return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
                        }
                        const nobj = cnote ? (0, notes_1.getNoteByName)(cnote) : null;
                        if (!nobj && cnote && cnote.toLowerCase() !== "stie" && cnote.toLowerCase() !== "shold") {
                            return c.helper.error(c.line.toString(), macro + " argument " + cnote + " can not be converted to a note!", input);
                        }
                        c.routine.items.push(new notes_1.SongNote(nobj !== null && nobj !== void 0 ? nobj : null, val === 0 ? 0x100 : val, !notie && !nobj));
                        cnote = null;
                        break;
                    }
                    default: {
                        addNote(null);
                        const { message, note, offset, } = checkNoteData(a);
                        if (!note) {
                            return c.helper.error(c.line.toString(), message !== null && message !== void 0 ? message : "Unexpected value " + a + "!", input);
                        }
                        if (offset - offs !== 0) {
                            c.routine.items.push(new commands_1.SongAddFraction(offset - offs));
                        }
                        offs = offset;
                        cnote = note.name;
                    }
                }
            }
            addNote(null);
            if (offs !== 0) {
                c.routine.items.push(new commands_1.SongAddFraction(-offs));
            }
        },
    },
    "svoice": {
        argCount: [1,],
        func: (c, input, args) => {
            const vc = c.song.voices.find((e) => e.name.toLowerCase() === args[0].toLowerCase());
            if (!vc) {
                return c.helper.error(c.line.toString(), "Voice " + args[0] + " does not exist.", input);
            }
            c.routine.items.push(new commands_1.SongSetVoice(vc));
        },
    },
    "ssample": {
        argCount: [1,],
        func: (c, input, args) => {
            const smp = c.song.samples.find((e) => e.name.toLowerCase() === args[0].toLowerCase());
            if (!smp) {
                return c.helper.error(c.line.toString(), "Sample " + args[0] + " does not exist.", input);
            }
            c.routine.items.push(new commands_1.SongSetSample(smp));
        },
    },
    "svibratoset": {
        argCount: [1,],
        func: (c, input, args) => {
            const vib = c.song.vibrato.find((e) => e.name.toLowerCase() === args[0].toLowerCase());
            if (!vib) {
                return c.helper.error(c.line.toString(), "Vibrato " + args[0] + " does not exist.", input);
            }
            c.routine.items.push(new commands_1.SongSetVibrato(vib));
        },
    },
    "stremoloset": {
        argCount: [1,],
        func: (c, input, args) => {
            const vib = c.song.vibrato.find((e) => e.name.toLowerCase() === args[0].toLowerCase());
            if (!vib) {
                return c.helper.error(c.line.toString(), "Vibrato " + args[0] + " does not exist.", input);
            }
            c.routine.items.push(new commands_1.SongSetTremolo(vib));
        },
    },
    "svibratoon": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongEnableVibrato());
        },
    },
    "svibratooff": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongDisableVibrato());
        },
    },
    "stremoloon": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongEnableTremolo());
        },
    },
    "stremolooff": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongDisableTremolo());
        },
    },
    "sfracenv": {
        argCount: [1,],
        func: (c, input, args) => {
            const ev = c.song.envelopes.find((e) => e.name.toLowerCase() === args[0].toLowerCase());
            if (!ev) {
                return c.helper.error(c.line.toString(), "Envelope " + args[0] + " does not exist.", input);
            }
            c.routine.items.push(new commands_1.SongSetFractionEnvelope(ev));
        },
    },
    "svolenv": {
        argCount: [1,],
        func: (c, input, args) => {
            const ev = c.song.envelopes.find((e) => e.name.toLowerCase() === args[0].toLowerCase());
            if (!ev) {
                return c.helper.error(c.line.toString(), "Envelope " + args[0] + " does not exist.", input);
            }
            c.routine.items.push(new commands_1.SongSetVolumeEnvelope(ev));
        },
    },
    "sflags": {
        argCount: [1,],
        func: (c, input, args) => {
            c.routine.items.push(new commands_1.SongFlags(args[0]));
        },
    },
    "sjump": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.SongTrack);
            if (routine) {
                c.routine.items.push(new commands_1.SongJump(routine));
            }
        },
    },
    "scall": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            const count = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(count)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            const routine = createRoutine(c, args[1], input, routines_1.RoutineType.SongTrack);
            if (routine) {
                c.routine.items.push(new commands_1.SongCall(routine, count));
            }
        },
    },
    "scont": {
        argCount: [1,],
        func: (c, input, args) => {
            const routine = createRoutine(c, args[0], input, routines_1.RoutineType.SongTrack);
            if (routine) {
                c.routine.items.push(new hints_1.SongHintNoOptimize(), new commands_1.SongCont(routine), new hints_1.SongHintNoOptimize());
            }
        },
    },
    "scondjump": {
        argCount: [3,],
        func: (c, input, args, macro) => {
            const byte = (0, lib_1.getAsmNum)(args[0]), value = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(byte)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            if (isNaN(value)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
            }
            const routine = createRoutine(c, args[2], input, routines_1.RoutineType.SongTrack);
            if (routine) {
                c.routine.items.push(new hints_1.SongHintNoOptimize(), new commands_1.SongCondJump(routine, byte, value), new hints_1.SongHintNoOptimize());
            }
        },
    },
    "sbitjump": {
        argCount: [3,],
        func: (c, input, args, macro) => {
            const byte = (0, lib_1.getAsmNum)(args[0]), bit = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(byte)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
            }
            if (isNaN(bit)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            const routine = createRoutine(c, args[2], input, routines_1.RoutineType.SongTrack);
            if (routine) {
                c.routine.items.push(new hints_1.SongHintNoOptimize(), new commands_1.SongBitJump(routine, bit, byte), new hints_1.SongHintNoOptimize());
            }
        },
    },
    "sfrac": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            const offs = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(offs)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongAddFraction(offs));
        },
    },
    "svol": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            const offs = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(offs)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongAddVolume(offs));
        },
    },
    "sstop": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongStop());
        },
    },
    "sret": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongReturn());
        },
    },
    "sbackup": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongBackup());
        },
    },
    "sspinrev": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongSpinRev());
        },
    },
    "sspinreset": {
        argCount: [0,],
        func: (c) => {
            c.routine.items.push(new commands_1.SongSpinReset());
        },
    },
    "stimset": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            const byte = (0, lib_1.getAsmNum)(args[0]), value = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(byte)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            if (isNaN(value)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongSetTiming(byte, value));
        },
    },
    "stimadd": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            const byte = (0, lib_1.getAsmNum)(args[0]), value = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(byte)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            if (isNaN(value)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongAddTiming(byte, value));
        },
    },
    "span": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            let pan = 0;
            switch (args[0].toLowerCase()) {
                case "left":
                    pan = -0x7F;
                    break;
                case "right":
                    pan = 0x7F;
                    break;
                case "center":
                    pan = 0;
                    break;
                default:
                    pan = (0, lib_1.getAsmNum)(args[0]);
                    break;
            }
            if (isNaN(pan)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongPan(pan));
        },
    },
    "squeue": {
        argCount: [1,],
        func: (c, input, args) => {
            c.routine.items.push(new commands_1.SongQueue(args[0]));
        },
    },
    "sportaspeed": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            const offs = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(offs)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongPortaSpeed(offs));
        },
    },
    "sportatarget": {
        argCount: [1, 2,],
        func: (c, input, args, macro) => {
            let value = 0;
            if (args.length === 2) {
                value = (0, lib_1.getAsmNum)(args[1]);
                if (isNaN(value)) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
                }
                const note = (0, notes_1.getNoteByName)(args[0].toLowerCase());
                if (!note) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a note!", input);
                }
                value += (note.id - notes_1.firstRealNote) << 8;
            }
            else {
                value = (0, lib_1.getAsmNum)(args[0]);
                if (isNaN(value)) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
                }
            }
            c.routine.items.push(new commands_1.SongPortaTarget(value));
        },
    },
    "stempo": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            const value = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(value)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongTempo(value, c.song.songs[c.index].flags.PAL));
        },
    },
    "sfastcut": {
        argCount: [0,],
        func: (c) => {
            return c.routine.items.push(new commands_1.SongFastCut());
        },
    },
    "slfo": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            if (args[0].toLowerCase() === "off") {
                return c.routine.items.push(new commands_1.SongSetLFO(0));
            }
            let val = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(val)) {
                try {
                    val = (0, commands_1.parseLFOFrequency)(args[0]);
                }
                catch (ex) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
                }
            }
            return c.routine.items.push(new commands_1.SongSetLFO(val));
        },
    },
    "samsfms": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            let ams = (0, lib_1.getAsmNum)(args[0]), fms = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(ams)) {
                try {
                    ams = (0, commands_1.parseAMS)(args[0]);
                }
                catch (ex) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
                }
            }
            if (isNaN(fms)) {
                try {
                    fms = (0, commands_1.parseFMS)(args[1]);
                }
                catch (ex) {
                    return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
                }
            }
            return c.routine.items.push(new commands_1.SongSetAMSFMS(ams, fms));
        },
    },
    "sopmask": {
        argCount: [1,],
        func: (c, input, args, macro) => {
            const mask = (0, lib_1.getAsmNum)(args[0]);
            if (isNaN(mask)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            return c.routine.items.push(new commands_1.SongSetOperatorMask([!!(mask & 0x1), !!(mask & 0x2), !!(mask & 0x4), !!(mask & 0x8),]));
        },
    },
    "stl": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            const op = (0, lib_1.getAsmNum)(args[0]), value = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(op)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            if (isNaN(value)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongSetTL(op, value));
        },
    },
    "sym": {
        argCount: [2,],
        func: (c, input, args, macro) => {
            const reg = (0, lib_1.getAsmNum)(args[0]), value = (0, lib_1.getAsmNum)(args[1]);
            if (isNaN(reg)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[0] + " can not be converted to a number!", input);
            }
            if (isNaN(value)) {
                return c.helper.error(c.line.toString(), macro + " argument " + args[1] + " can not be converted to a number!", input);
            }
            c.routine.items.push(new commands_1.SongYMCommand(reg, value));
        },
    },
};
const checkMacro = /^\s+([0-9A-Z_-]{3,})(\s+([\sA-Z0-9_.,$<>|&%"'/()=+*^~-]*)|)\s*(;.*)?\r?$/i;
const checkLabel = /^(\.?[A-Z_][0-9A-Z_-]*):?\r?/i;
function checkFallthrough(routine, c) {
    var _a;
    routine.external = false;
    if (((_a = c.routine) === null || _a === void 0 ? void 0 : _a.endsInStop()) === false) {
        if (routine instanceof routines_1.SongTrackRoutine) {
            c.routine.items.push(new commands_1.SongJump(routine));
        }
        else if (routine instanceof routines_1.SongEnvelopeTrackRoutine) {
            c.routine.items.push(new envelopes_1.EnvelopeJump(routine));
        }
    }
}
function createDelayedRoutine(type, c) {
    var _a, _b;
    if (!c.nextRoutine) {
        return;
    }
    const rt = getRoutine(c, c.nextRoutine.name);
    if (rt) {
        if (type && rt.type !== type) {
            c.helper.error(c.line.toString(), "Routine \"" + c.nextRoutine.name + "\" is not compatible!", c.nextRoutine.input);
            return;
        }
        if (((_a = c.routine) === null || _a === void 0 ? void 0 : _a.endsInStop()) === false) {
            if (rt instanceof routines_1.SongTrackRoutine) {
                c.routine.items.push(new commands_1.SongJump(rt));
            }
            else if (rt instanceof routines_1.SongEnvelopeTrackRoutine) {
                c.routine.items.push(new envelopes_1.EnvelopeJump(rt));
            }
        }
        c.routine = rt;
        c.nextRoutine = undefined;
        c.routine.external = false;
        return;
    }
    const newrt = createRoutine(c, c.nextRoutine.name, c.nextRoutine.input, type !== null && type !== void 0 ? type : routines_1.RoutineType.SongTrack);
    if (!newrt) {
        c.helper.error(c.line.toString(), "Routine \"" + c.nextRoutine.name + "\" is in invalid format!", c.nextRoutine.input);
        return;
    }
    if (((_b = c.routine) === null || _b === void 0 ? void 0 : _b.endsInStop()) === false) {
        if (newrt instanceof routines_1.SongTrackRoutine) {
            c.routine.items.push(new commands_1.SongJump(newrt));
        }
        else if (newrt instanceof routines_1.SongEnvelopeTrackRoutine) {
            c.routine.items.push(new envelopes_1.EnvelopeJump(newrt));
        }
    }
    c.routine = newrt;
    c.nextRoutine = undefined;
    newrt.external = false;
}
function createRoutine(c, label, input, type) {
    const match = checkLabel.exec(label);
    const ret = c.song.getOrMakeRoutine(getRealLabel(c, match ? match[1] : "?"), type, true, { unsafePan: true, });
    switch (ret.type) {
        case song_1.GetRoutineReturnType.Success:
            return ret.routine;
        case song_1.GetRoutineReturnType.InvalidLabel:
            c.helper.error(c.line.toString(), "Routine \"" + label + "\" is in invalid format!", input);
            return null;
        case song_1.GetRoutineReturnType.WrongType:
            c.helper.error(c.line.toString(), "Routine \"" + label + "\" is not compatible!", input);
            return null;
        case song_1.GetRoutineReturnType.UnknownType:
            c.helper.error(c.line.toString(), "Unknown error: Routine type " + type + " is invalid.", input);
            return null;
    }
    c.helper.error(c.line.toString(), "Unknown error: getOrMakeRoutine invalid return value " + ret.type, input);
    return null;
}
function getRoutine(c, label) {
    const match = checkLabel.exec(label);
    return c.song.getRoutine(getRealLabel(c, match ? match[1] : "?"));
}
function getRealLabel(c, label) {
    if (label.includes(".") || label.includes("@")) {
        return c.song.songs[c.index].id + "_" + c.counter.toString(16) + "_" + label.substring(1);
    }
    return label;
}
function runFunction(table, func, argstring, c, input) {
    var _a;
    const info = table[(_a = func === null || func === void 0 ? void 0 : func.toLowerCase()) !== null && _a !== void 0 ? _a : ""];
    if (!info) {
        return c.helper.error(c.line.toString(), "Function \"" + func + "\" was not recognized, or was unexpected at this point.", input);
    }
    const args = [];
    if (info.argCount) {
        if (argstring === null || argstring === void 0 ? void 0 : argstring.trim()) {
            args.push(...argstring.split(",").map((a) => a.trim()));
        }
        if (!info.argCount.includes(args.length)) {
            const countstr = info.argCount.length > 1 ? "Expected one of: " + info.argCount.join(", ") : "Expected " + info.argCount[0] + " arguments!";
            return c.helper.error(c.line.toString(), "Argument count " + args.length + " is not valid for \"" + func + "\". " + countstr, input);
        }
    }
    return info.func(c, input, args, func !== null && func !== void 0 ? func : "");
}
function checkNoteData(arg) {
    const { func, args, } = checkFunction(arg);
    switch (func) {
        case "freq": return getFreqFunc(args);
    }
    return { message: func === null ? "Invalid function name" : null, note: null, offset: NaN, };
}
function checkFunction(arg) {
    const r = /^\s*([A-Z]*)\((.*)\)\s*$/i.exec(arg);
    if (!r) {
        return { func: null, args: [], };
    }
    const args = r[2].split(".").map((a) => a.trim());
    return { func: r[1], args, };
}
function getFreqFunc(args) {
    if (args.length < 2) {
        return { message: "Missing arguments to freq(channel, frequency, fraction?)", note: null, offset: NaN, };
    }
    if (!(args[0] in song_1.ChannelType)) {
        return { message: "Invalid argument to freq(channel, frequency, fraction?): " + args[0] + " is not a channel type!", note: null, offset: NaN, };
    }
    const type = song_1.ChannelType[args[0]];
    if (type === song_1.ChannelType.PSG4) {
        return { message: "Can not use freq(channel, frequency, fraction?) in PSG4!", note: null, offset: NaN, };
    }
    const freq = (0, lib_1.getAsmNum)(args[1]);
    if (isNaN(freq)) {
        return { message: "Invalid argument to freq(channel, frequency, fraction?): Frequency is not a number!", note: null, offset: NaN, };
    }
    let frac = 0;
    if (args.length >= 3) {
        frac = (0, lib_1.getAsmNum)(args[2]);
        if (isNaN(frac)) {
            return { message: "Invalid argument to freq(channel, frequency, fraction?): Fraction is not a number!", note: null, offset: NaN, };
        }
    }
    let result = (0, notes_1.calcFracForFreq)(freq, type);
    if (result < 0) {
        result += 0x3F00;
        frac += 0x3F00;
    }
    const note = (0, notes_1.getNoteByID)((result >> 8) + notes_1.firstRealNote);
    if (isNaN(result) || !note) {
        return { message: "Unable to resolve a note for freq(" + args[0] + ", " + args[1] + (args.length >= 3 ? ", " + args[2] : "") + ")", note: null, offset: NaN, };
    }
    result -= (note.id - notes_1.firstRealNote) << 8;
    return { message: null, note, offset: result - frac, };
}
