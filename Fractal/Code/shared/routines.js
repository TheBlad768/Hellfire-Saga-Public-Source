"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SongSampleRoutine = exports.SongVibratoRoutine = exports.SongVoiceRoutine = exports.SongEnvelopeRoutine = exports.SongEnvelopeTrackRoutine = exports.SongTrackRoutine = exports.RoutineType = void 0;
const includer_1 = require("../includer");
var RoutineType;
(function (RoutineType) {
    RoutineType[RoutineType["SongTrack"] = 0] = "SongTrack";
    RoutineType[RoutineType["EnvelopeTrack"] = 1] = "EnvelopeTrack";
    RoutineType[RoutineType["Envelope"] = 2] = "Envelope";
    RoutineType[RoutineType["Voice"] = 3] = "Voice";
    RoutineType[RoutineType["Vibrato"] = 4] = "Vibrato";
    RoutineType[RoutineType["Sample"] = 5] = "Sample";
})(RoutineType = exports.RoutineType || (exports.RoutineType = {}));
class SongTrackRoutine {
    constructor(label, external, flags) {
        this.type = RoutineType.SongTrack;
        this.label = label;
        this.items = [];
        this.external = external;
        this.flags = flags;
    }
    clone() {
        throw new Error("Can not clone routines!");
    }
    equals() {
        return false;
    }
    getLines(s, iscache) {
        if (this.external) {
            return [];
        }
        return [
            ...this.label.getLines(),
            ...this.items.flatMap((i) => i.getLines(s, iscache)),
        ];
    }
    getByteCount() {
        let ret = 0;
        for (const item of this.items) {
            ret += item.getByteCount();
        }
        return ret;
    }
    endsInStop() {
        if (this.items.length === 0) {
            return false;
        }
        return this.items[this.items.length - 1].isStop;
    }
}
exports.SongTrackRoutine = SongTrackRoutine;
class SongEnvelopeTrackRoutine {
    constructor(label, external, flags) {
        this.type = RoutineType.EnvelopeTrack;
        this.label = label;
        this.items = [];
        this.external = external;
        this.flags = flags;
    }
    clone() {
        throw new Error("Can not clone routines!");
    }
    equals() {
        return false;
    }
    getLines(s, iscache) {
        if (this.external) {
            return [];
        }
        return [
            ...this.label.getLines(),
            ...this.items.flatMap((i) => i.getLines(s, iscache)),
        ];
    }
    getByteCount() {
        let ret = 0;
        for (const item of this.items) {
            ret += item.getByteCount();
        }
        return ret;
    }
    endsInStop() {
        if (this.items.length === 0) {
            return false;
        }
        return this.items[this.items.length - 1].isStop;
    }
}
exports.SongEnvelopeTrackRoutine = SongEnvelopeTrackRoutine;
class SongEnvelopeRoutine {
    constructor(label, external, flags) {
        this.type = RoutineType.Envelope;
        this.label = label;
        this.items = [];
        this.external = external;
        this.flags = flags;
    }
    clone() {
        throw new Error("Can not clone routines!");
    }
    equals() {
        return false;
    }
    getLines() {
        if (this.external) {
            return [];
        }
        return [
            "\t" + includer_1.assemblerSettings.even,
            ...this.label.getLines(),
            ...this.items.flatMap((i) => i.getLines()),
        ];
    }
    getByteCount() {
        let ret = 0;
        for (const item of this.items) {
            ret += item.getByteCount();
        }
        return ret;
    }
    endsInStop() {
        return true;
    }
}
exports.SongEnvelopeRoutine = SongEnvelopeRoutine;
class SongVoiceRoutine {
    constructor(label, external, flags) {
        this.type = RoutineType.Voice;
        this.label = label;
        this.items = [];
        this.external = external;
        this.flags = flags;
    }
    clone() {
        throw new Error("Can not clone routines!");
    }
    equals() {
        return false;
    }
    getLines() {
        if (this.external) {
            return [];
        }
        return [
            "\t" + includer_1.assemblerSettings.even,
            ...this.label.getLines(),
            ...this.items.flatMap((i) => i.getLines()),
        ];
    }
    getByteCount() {
        let ret = 0;
        for (const item of this.items) {
            ret += item.getByteCount();
        }
        return ret;
    }
    endsInStop() {
        return true;
    }
}
exports.SongVoiceRoutine = SongVoiceRoutine;
class SongVibratoRoutine {
    constructor(label, external, flags) {
        this.type = RoutineType.Vibrato;
        this.label = label;
        this.items = [];
        this.external = external;
        this.flags = flags;
    }
    clone() {
        throw new Error("Can not clone routines!");
    }
    equals() {
        return false;
    }
    getLines() {
        if (this.external) {
            return [];
        }
        return [
            "\t" + includer_1.assemblerSettings.even,
            ...this.label.getLines(),
            ...this.items.flatMap((i) => i.getLines()),
        ];
    }
    getByteCount() {
        let ret = 0;
        for (const item of this.items) {
            ret += item.getByteCount();
        }
        return ret;
    }
    endsInStop() {
        return true;
    }
}
exports.SongVibratoRoutine = SongVibratoRoutine;
class SongSampleRoutine {
    constructor(label, external, flags) {
        this.type = RoutineType.Sample;
        this.label = label;
        this.items = [];
        this.external = external;
        this.flags = flags;
    }
    clone() {
        throw new Error("Can not clone routines!");
    }
    equals() {
        return false;
    }
    getLines() {
        if (this.external) {
            return [];
        }
        return [
            "\t" + includer_1.assemblerSettings.even,
            ...this.label.getLines(),
            ...this.items.flatMap((i) => i.getLines()),
        ];
    }
    getByteCount() {
        let ret = 0;
        for (const item of this.items) {
            ret += item.getByteCount();
        }
        return ret;
    }
    endsInStop() {
        return true;
    }
}
exports.SongSampleRoutine = SongSampleRoutine;
