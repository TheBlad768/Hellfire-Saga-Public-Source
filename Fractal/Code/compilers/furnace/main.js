"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.VERSION = void 0;
const items_1 = require("../../shared/items");
const instruments_1 = require("./instruments");
const patternConvert_1 = require("./patternConvert");
const samples_1 = require("./samples");
const library_1 = require("./library");
const furnace_module_interface_1 = require("../../shared/furnace-module-interface");
const channels_1 = require("./channels");
const info_1 = require("./info");
const lib_1 = require("../../shared/lib");
module.exports = {
    version: 0.11,
    compile: (f, song, helper) => __awaiter(void 0, void 0, void 0, function* () {
        var _a;
        const file = yield (0, furnace_module_interface_1.loadFurnaceModule)(yield f.getBuffer());
        if (!(file instanceof furnace_module_interface_1.FurnaceSongModule)) {
            throw new Error("Input file is not a Furnace song module.");
        }
        const c = {
            helper,
            song,
            file,
            index: 0,
            targetSong: file.info.songs[0],
            version: 0,
            channels: [],
            instruments: [],
            samples: [],
            counter: 0,
            linkFM6: null,
            convert: {
                splitNextPattern: [],
                orderNumber: 0,
                breakPattern: NaN,
                jumpPattern: NaN,
                jumpMode: 0,
                timingIndex: 0,
                timingValue: 0,
            },
            getInfo: () => (0, furnace_module_interface_1.getVersionString)(c.file.getVersion()) + " :: " + (c.targetSong.name || c.file.info.metadata.songName || "subsong #" + (0, lib_1.hex)(2, (c.index + 1))),
        };
        if (!checkValidFile(c)) {
            return null;
        }
        if (c.file.info.A4Tuning !== 440) {
            c.helper.error(c.getInfo(), "A4 must be tuned to 440hz, but it was tuned to " + c.file.info.A4Tuning + "hz!");
            return null;
        }
        if (c.file.info.flags.pitchMacroIsLinear !== true) {
            c.helper.warn(c.getInfo(), "Only linear pitch macros are supported. All pitch macros will now be ignored...");
            c.file.info.flags.pitchMacroIsLinear = false;
        }
        if (helper.subsongs.length === 0) {
            for (let i = 0; i < c.file.info.songs.length; i++) {
                const song = c.file.info.songs[i];
                const name = song.name || c.file.info.metadata.songName || null;
                let nn = name === null ? "" : (0, library_1.sanitizeLabel)(c, name);
                if ("0123456789".includes(nn[0])) {
                    nn = "";
                }
                if (nn.length === 0) {
                    nn = (0, library_1.sanitizeLabel)(c, (0, lib_1.sanitizeFilename)(helper.filename));
                    if ("0123456789".includes(nn[0])) {
                        nn = (0, lib_1.generateID)();
                    }
                }
                helper.subsongs.push({
                    index: i + 1,
                    id: nn,
                });
            }
        }
        for (const sub of helper.subsongs) {
            if (!c.file.info.songs[sub.index - 1]) {
                c.helper.error(c.getInfo(), "Attempted to load subsong #" + (0, lib_1.hex)(2, sub.index) + ", but that index does not exist!");
                return null;
            }
            c.index = sub.index - 1;
            c.targetSong = c.file.info.songs[c.index];
            song.addSong(sub.index, false, NaN, NaN);
            if (!(0, info_1.parseComment)(c)) {
                return null;
            }
            if (!(0, info_1.initSongHeader)(c)) {
                return null;
            }
            if (!(0, channels_1.loadChannels)(c)) {
                return song;
            }
        }
        for (const s of c.file.info.samples) {
            if (!(0, samples_1.loadSample)(c, s)) {
                return null;
            }
        }
        for (const i of c.file.info.instruments) {
            if (!(0, instruments_1.loadInstrument)(c, i)) {
                return null;
            }
        }
        if (!c.channels.reduce((acc, song) => {
            return song.reduce((acc2, ch) => {
                if (!(0, channels_1.loadPatterns)(c, ch)) {
                    return false;
                }
                return acc2;
            }, true) ? acc : false;
        }, true)) {
            return null;
        }
        for (const sub of helper.subsongs) {
            c.index = sub.index - 1;
            c.targetSong = c.file.info.songs[c.index];
            if (!(yield (0, patternConvert_1.convertPatterns)(c))) {
                return null;
            }
        }
        if (c.song.samples.length === 0) {
            const s = new items_1.Sample("null");
            s.frequency = 0;
            s.start = ["null", "null",];
            s.loop = ["null", "null",];
            s.rest = ["null", "null",];
            s.restloop = ["null", "null",];
            c.song.samples.push(s);
            (_a = c.song.sampleRoutine) === null || _a === void 0 ? void 0 : _a.items.push(s);
        }
        return song;
    }),
};
exports.VERSION = "v" + module.exports.version.toFixed(2);
function checkValidFile(c) {
    return (c.version = (0, library_1.isValidVersion)(c, c.file.getVersion())) !== 0;
}
