"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FurnacePattern = exports.loadPattern = void 0;
const lib_1 = require("../../shared/lib");
const song_1 = require("../../shared/song");
const library_1 = require("./library");
function loadPattern(c, position) {
    const linkch = c.channels.find((cx) => cx.type === song_1.ChannelType.FM6);
    c.file.setPosition(position);
    if (c.file.getASCII(4) !== "PATR") {
        c.helper.error(c.getLoc(), "Could not find the pattern block");
        return false;
    }
    c.file.skipBytes(4);
    const chid = c.file.readUInt16LE();
    const patix = c.file.readUInt16LE();
    c.file.skipBytes(4);
    const pat = new FurnacePattern((0, lib_1.hex)(4, patix));
    if (!c.channels[chid]) {
        c.helper.error(c.getLoc(), "Invalid channel ID " + (0, lib_1.word)(chid) + " encountered!");
        return false;
    }
    if (patix > 255) {
        c.helper.error(c.getLoc(), "Invalid pattern ID " + (0, lib_1.word)(patix) + " encountered!");
        return false;
    }
    for (let r = 0; r < c.patternRows; r++) {
        const note = c.file.readInt16LE();
        const octave = c.file.readInt8();
        c.file.skipBytes(1);
        let instrument = c.file.readUInt16LE();
        let volume = c.file.readUInt16LE();
        let nid = undefined;
        switch (note) {
            case 100:
                nid = 0x4001;
                break;
            case 101:
                nid = 0x4002;
                break;
            case 102:
                nid = 0x4000;
                break;
            case 0:
                nid = undefined;
                break;
            default:
                nid = (octave * 0xC) + note;
                break;
        }
        if (volume === 0xFFFF) {
            volume = undefined;
        }
        else {
            const type = c.channels[chid].type;
            if ((0, library_1.isPSG)(type) && volume !== 0) {
                volume = (0xF - volume) * 8;
            }
            else {
                volume = 0x7F - volume;
            }
        }
        if (instrument === 0xFFFF) {
            instrument = undefined;
        }
        const row = {
            row: r, note: nid, instrument, volume, effects: [],
        };
        for (let e = 0; e < c.channels[chid].effects; e++) {
            const id = c.file.readUInt16LE();
            const value = c.file.readUInt16LE();
            if (id !== 0xFFFF) {
                row.effects.push({ id, value: value === 0xFFFF ? undefined : value, });
            }
        }
        if (typeof nid === "number" || typeof instrument === "number" || typeof volume === "number" || row.effects.length > 0) {
            pat.rows.push(row);
        }
    }
    c.channels[chid].patterns[patix] = pat;
    const name = c.file.readString("utf-8");
    if (name.trim().length > 0) {
        pat.name = name;
    }
    if (linkch && c.channels[chid].type === c.linkFM6) {
        linkch.patterns[patix] = pat;
    }
    return true;
}
exports.loadPattern = loadPattern;
class FurnacePattern {
    constructor(name) {
        this.rows = [];
        this.name = name;
    }
}
exports.FurnacePattern = FurnacePattern;
