"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SongHintNoOptimize = exports.SongHintFracReset = exports.SongHintPortamentoMode = void 0;
const commands_1 = require("./commands");
class SongHintPortamentoMode {
    constructor(value) {
        this.subtype = commands_1.SongCommandSubtype.Hint;
        this.property = "portamento";
        this.isStop = false;
        this.value = value;
    }
    clone() {
        return new SongHintPortamentoMode(this.value);
    }
    getLines() {
        return [];
    }
    getByteCount() {
        return 0;
    }
    equals(item) {
        return item instanceof SongHintPortamentoMode && (item.value === this.value);
    }
}
exports.SongHintPortamentoMode = SongHintPortamentoMode;
class SongHintFracReset {
    constructor() {
        this.subtype = commands_1.SongCommandSubtype.Hint;
        this.property = "";
        this.isStop = false;
    }
    clone() {
        return new SongHintFracReset();
    }
    getLines() {
        return [];
    }
    getByteCount() {
        return 0;
    }
    equals(item) {
        return item instanceof SongHintFracReset;
    }
}
exports.SongHintFracReset = SongHintFracReset;
class SongHintNoOptimize {
    constructor() {
        this.subtype = commands_1.SongCommandSubtype.Hint;
        this.property = "";
        this.isStop = false;
    }
    clone() {
        return new SongHintNoOptimize();
    }
    getLines() {
        return [];
    }
    getByteCount() {
        return 0;
    }
    equals() {
        return false;
    }
}
exports.SongHintNoOptimize = SongHintNoOptimize;
