"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isValidVersion = exports.sanitizeLabel = exports.getRoutine = exports.createRoutine = exports.isExtFM = exports.isNormalFM = exports.isFM = exports.isDAC = exports.isNoise = exports.isPSG = exports.checkUnsafePan = void 0;
const song_1 = require("../../shared/song");
function checkUnsafePan(type, list) {
    return ((0, exports.isDAC)(type) && !!list.fm6) || (type === song_1.ChannelType.FM6 && (!!list.dac1 || !!list.dac2));
}
exports.checkUnsafePan = checkUnsafePan;
const isPSG = (type) => [song_1.ChannelType.PSG1, song_1.ChannelType.PSG2, song_1.ChannelType.PSG3, song_1.ChannelType.PSG4,].includes(type);
exports.isPSG = isPSG;
const isNoise = (type) => type === song_1.ChannelType.PSG4;
exports.isNoise = isNoise;
const isDAC = (type) => type === song_1.ChannelType.DAC1 || type === song_1.ChannelType.DAC2;
exports.isDAC = isDAC;
const isFM = (type) => (0, exports.isNormalFM)(type) || (0, exports.isExtFM)(type);
exports.isFM = isFM;
const isNormalFM = (type) => [song_1.ChannelType.FM1, song_1.ChannelType.FM2, song_1.ChannelType.FM4, song_1.ChannelType.FM5, song_1.ChannelType.FM6,].includes(type);
exports.isNormalFM = isNormalFM;
const isExtFM = (type) => [song_1.ChannelType.FM3o1, song_1.ChannelType.FM3o2, song_1.ChannelType.FM3o3, song_1.ChannelType.FM3o4,].includes(type);
exports.isExtFM = isExtFM;
function createRoutine(c, label, type, flags) {
    var _a, _b, _c;
    const ret = c.song.getOrMakeRoutine(((_a = c.song.getSong(c.index + 1)) === null || _a === void 0 ? void 0 : _a.id) + "_" + label, type, true, flags);
    switch (ret.type) {
        case song_1.GetRoutineReturnType.Success:
            ret.routine.external = false;
            return ret.routine;
        case song_1.GetRoutineReturnType.InvalidLabel:
            c.helper.error(c.getInfo(), "Unknown error: Routine \"" + ((_b = c.song.getSong(c.index + 1)) === null || _b === void 0 ? void 0 : _b.id) + "_" + label + "\" is in invalid format!");
            return null;
        case song_1.GetRoutineReturnType.WrongType:
            c.helper.error(c.getInfo(), "Unknown error: Routine \"" + ((_c = c.song.getSong(c.index + 1)) === null || _c === void 0 ? void 0 : _c.id) + "_" + label + "\" is not compatible!");
            return null;
        case song_1.GetRoutineReturnType.UnknownType:
            c.helper.error(c.getInfo(), "Unknown error: Routine type " + type + " is invalid.");
            return null;
    }
    c.helper.error(c.getInfo(), "Unknown error: getOrMakeRoutine invalid return value " + ret.type);
    return null;
}
exports.createRoutine = createRoutine;
function getRoutine(c, label) {
    var _a;
    return c.song.getRoutine(((_a = c.song.getSong(c.index + 1)) === null || _a === void 0 ? void 0 : _a.id) + "_" + label);
}
exports.getRoutine = getRoutine;
function sanitizeLabel(c, input, ext) {
    c.counter++;
    return input.replace(/[^0-9a-z]/gi, "") + (ext ? ext : chartab[c.counter % chartab.length] + chartab[Math.floor(c.counter / chartab.length) % chartab.length]);
}
exports.sanitizeLabel = sanitizeLabel;
const chartab = "_0123456789abcdefghijklmnopqrstuvwxyz";
function isValidVersion(c, version) {
    if (version < 53 || version === 75) {
        c.helper.error(c.getInfo(), "Unsupported module version " + version + "!");
        return 0;
    }
    return version;
}
exports.isValidVersion = isValidVersion;
