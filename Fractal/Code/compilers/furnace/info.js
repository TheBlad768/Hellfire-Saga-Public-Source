"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calcTempo = exports.initSongHeader = exports.parseComment = void 0;
const lib_1 = require("../../shared/lib");
const routines_1 = require("../../shared/routines");
const song_1 = require("../../shared/song");
const library_1 = require("./library");
const main_1 = require("./main");
const commentRegex = /FURCMP\s+(v[0-9a-z.]+)\s+(sfx|music)\s+(F6D([12])\s+)?flags=([a-z0-9]*)(\s+priority=([0-9A-Fx$]{1,3}))?/i;
function parseComment(c) {
    const checkComment = (comment) => {
        var _a;
        const match = commentRegex.exec(comment);
        if (!match) {
            return { match, sfx: false,
                message: "This file is not a compatible file. Expected FURCMP statement in song comments, but did not find it. " +
                    " Example line: \"FURCMP " + main_1.VERSION + " music flags=\"",
            };
        }
        let sfx = false;
        switch (match[2]) {
            case "sfx":
                sfx = true;
                break;
            case "music":
                sfx = false;
                break;
            default:
                return { match, sfx,
                    message: "This file is not a compatible file. Expected sound type to be MUSIC or SFX, it was " + match[2] + "." +
                        " Example line: \"FURCMP " + main_1.VERSION + " music flags=\"",
                };
        }
        c.song.setFlags(match[5], c.index + 1);
        const priority = (0, lib_1.getAsmNum)(match[7] || "NaN");
        if (!isNaN(priority)) {
            c.song.getSong(c.index + 1).priority = priority;
        }
        else if ((_a = c.song.getSong(c.index + 1)) === null || _a === void 0 ? void 0 : _a.sfx) {
            return { match, sfx, message: "Expected priority value, but " + (match[7] || "<empty>") + " can not be converted to a number." +
                    " Example line: \"FURCMP " + main_1.VERSION + " music flags= priority=$80\".",
            };
        }
        if (match[1] !== main_1.VERSION) {
            c.helper.warn(c.getInfo(), "The file version " + match[1] + " does not match the converter version " + main_1.VERSION + ". This may cause bugs.", comment);
        }
        return { message: undefined, match, sfx, };
    };
    let { message, match, sfx, } = checkComment(c.targetSong.comment);
    if (message) {
        const res = checkComment(c.file.info.comment);
        if (res.message) {
            c.helper.error(c.getInfo(), message, c.targetSong.comment);
            return false;
        }
        c.helper.warn(c.getInfo(), "Song comment not found, defaulting to module comment instead.", c.file.info.comment);
        match = res.match;
        sfx = res.sfx;
    }
    if (match[4]) {
        c.linkFM6 = match[4] === "1" ? song_1.ChannelType.DAC1 : song_1.ChannelType.DAC2;
    }
    c.song.getSong(c.index + 1).sfx = sfx;
    return true;
}
exports.parseComment = parseComment;
function initSongHeader(c) {
    c.song.voiceRoutine = (0, library_1.createRoutine)(c, "Voices", routines_1.RoutineType.Voice, {});
    c.song.sampleRoutine = (0, library_1.createRoutine)(c, "Samples", routines_1.RoutineType.Sample, {});
    c.song.vibratoRoutine = (0, library_1.createRoutine)(c, "Vibrato", routines_1.RoutineType.Vibrato, {});
    c.song.envelopeRoutine = (0, library_1.createRoutine)(c, "Envelopes", routines_1.RoutineType.Envelope, {});
    const res = calcTempo(c);
    if (isNaN(res)) {
        return false;
    }
    c.song.getSong(c.index + 1).tempo = res;
    return true;
}
exports.initSongHeader = initSongHeader;
function calcTempo(c) {
    const tempo = c.targetSong.ticksPerSecond / 60 * 0x100;
    const normal = Math.round(tempo);
    if (normal > 0x3FF) {
        c.helper.error(c.getInfo(), "Main tempo (" + (0, lib_1.word)(normal) + ") exceeded the maximum allowed tempo of $03FF!");
        return NaN;
    }
    return normal;
}
exports.calcTempo = calcTempo;
