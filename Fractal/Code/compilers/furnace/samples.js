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
exports.SmokerSample = exports.loadSample = void 0;
const items_1 = require("../../shared/items");
const samples_1 = require("../../shared/samples");
const library_1 = require("./library");
function loadSample(c, sample) {
    const name = sample.name;
    c.samples.push(new SmokerSample(name, sample));
    return true;
}
exports.loadSample = loadSample;
class SmokerSample {
    constructor(name, base) {
        this.name = name;
        this.base = base;
        this.sample = null;
        this.samplePitched = null;
    }
    getSampleReal(c, rate) {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            const id = (0, library_1.sanitizeLabel)(c, this.name);
            const name = this.name.replace(/\.[^/.]+$/, "").split(' ').join('_');
            const start = "ds" + c.song.moduleId + "_" + id, end = "de" + c.song.moduleId + "_" + id;
            const format = new samples_1.SamplePCMFormat(rate, this.base.data.formatId, 1, this.base.data.formatId === 8);
            if (!(yield c.song.addSample(start, end, this.base.data.rawBuffer, 0, this.base.data.rawBuffer.byteLength, c.helper.sampleRate, format, name))) {
                return null;
            }
            const sample = new items_1.Sample(id);
            sample.frequency = Math.round(0x100 * 1);
            if (typeof this.base.loopStart !== "number") {
                sample.start = [start, end,];
                sample.loop = ["null", "null",];
            }
            else {
                sample.start = [start, end,];
                sample.loop = [start + "+" + this.base.loopStart, end,];
            }
            sample.rest = ["null", "null",];
            sample.restloop = ["null", "null",];
            c.song.samples.push(sample);
            (_a = c.song.sampleRoutine) === null || _a === void 0 ? void 0 : _a.items.push(sample);
            return sample;
        });
    }
    getSample(c) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.sample) {
                return this.sample;
            }
            return this.sample = yield this.getSampleReal(c, this.base.compatRate);
        });
    }
    getPitchedSample(c) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.samplePitched) {
                return this.samplePitched;
            }
            return this.samplePitched = yield this.getSampleReal(c, this.base.c4Rate);
        });
    }
}
exports.SmokerSample = SmokerSample;
