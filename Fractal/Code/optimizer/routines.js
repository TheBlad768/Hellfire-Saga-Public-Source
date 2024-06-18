"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.optimizeTailCalls = exports.removeJumpTos = exports.combineMatchingRoutines = exports.reorderRoutines = exports.combineRoutines = exports.deleteRoutine = exports.findRoutineReferences = void 0;
const commands_1 = require("../shared/commands");
const hints_1 = require("../shared/hints");
const routines_1 = require("../shared/routines");
const main_1 = require("./main");
function findRoutineReferences(info, check) {
    const ret = [];
    for (const rt of info.song.routines) {
        if (!(rt instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        for (const i of rt.items) {
            if (i.subtype !== commands_1.SongCommandSubtype.TargetCommand) {
                continue;
            }
            if (i.routine === check) {
                ret.push({ item: i, routine: rt, });
            }
        }
    }
    for (const sng of Object.values(info.song.songs)) {
        for (const ch of sng.channels) {
            if (ch.routine === check) {
                ret.push({ item: null, routine: null, });
            }
        }
    }
    return ret;
}
exports.findRoutineReferences = findRoutineReferences;
function deleteRoutine(info, routine) {
    let ix = info.song.routines.indexOf(routine);
    if (ix < 0) {
        throw new Error("Internal error: Invalid reference " + routine.label.name + " not found!");
    }
    info.song.routines.splice(ix, 1);
    ix = info.song.labels.indexOf(routine.label);
    if (ix >= 0) {
        info.song.labels.splice(ix, 1);
    }
}
exports.deleteRoutine = deleteRoutine;
function combineRoutines(info) {
    for (let i = 0; i < info.song.routines.length; i++) {
        const rt = info.song.routines[i];
        if (!(rt instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        const ref = findRoutineReferences(info, rt);
        if (ref.length === 0) {
            if (info.opt.removeUnused) {
                deleteRoutine(info, rt);
                --i;
            }
        }
        else if (ref.length === 1 && info.opt.combineRoutines) {
            const it = ref[0];
            if (it.item instanceof commands_1.SongJump && it.routine !== null && it.routine !== rt) {
                const ix = it.routine.items.indexOf(it.item);
                if (ix < 0) {
                    throw new Error("Internal error: Invalid reference " + it.item.routine.label.name + " in " + it.routine.label.name + " not found!");
                }
                it.routine.items.splice(ix, it.routine.items.length - ix);
                it.routine.items.push(...rt.items);
                deleteRoutine(info, rt);
                --i;
            }
        }
    }
}
exports.combineRoutines = combineRoutines;
function reorderRoutines(info) {
    if (!info.opt.routineOrder) {
        return;
    }
    const routines = info.song.routines;
    info.song.routines = [];
    const addRoutine = (rt) => {
        const ix = routines.indexOf(rt);
        if (ix >= 0) {
            routines.splice(ix, 1);
            info.song.routines.push(rt);
        }
        return ix;
    };
    if (info.song.vibratoRoutine) {
        addRoutine(info.song.vibratoRoutine);
    }
    if (info.song.sampleRoutine) {
        addRoutine(info.song.sampleRoutine);
    }
    if (info.song.vibratoRoutine) {
        addRoutine(info.song.vibratoRoutine);
    }
    if (info.song.envelopeRoutine) {
        addRoutine(info.song.envelopeRoutine);
        for (const i of info.song.envelopeRoutine.items) {
            const ix = addRoutine(i.routine);
            if (i.routine.endsInStop()) {
                continue;
            }
            while (routines[ix] instanceof routines_1.SongEnvelopeTrackRoutine) {
                addRoutine(routines[ix]);
            }
        }
    }
    const handleRoutine = (routine) => {
        var _a;
        let i = routine.items[routine.items.length - 1];
        if (i instanceof commands_1.SongReturn || i instanceof commands_1.SongStop) {
            i = routine.items[routine.items.length - 2];
            if (i instanceof commands_1.SongJump) {
                routine.items.pop();
            }
        }
        if (((_a = info.opt.omitUnused) === null || _a === void 0 ? void 0 : _a.jumps) === true) {
            i = routine.items[routine.items.length - 1];
            if (i instanceof commands_1.SongJump) {
                const rt = i.routine;
                if (addRoutine(rt) >= 0 && rt instanceof routines_1.SongTrackRoutine) {
                    routine.items.pop();
                    handleRoutine(rt);
                }
            }
        }
        for (let ix = 0; ix < routine.items.length; ix++) {
            i = routine.items[ix];
            if (i.subtype === commands_1.SongCommandSubtype.TargetCommand) {
                const rt = i.routine;
                if (addRoutine(rt) >= 0 && rt instanceof routines_1.SongTrackRoutine) {
                    handleRoutine(rt);
                }
            }
        }
    };
    for (const sub of Object.values(info.song.songs)) {
        for (const ch of sub.channels) {
            addRoutine(ch.routine);
            handleRoutine(ch.routine);
        }
    }
    while (routines.length > 0) {
        addRoutine(routines[0]);
    }
}
exports.reorderRoutines = reorderRoutines;
function combineMatchingRoutines(info) {
    if (!info.opt.combineMatchRoutines) {
        return;
    }
    for (let s = info.song.routines.length - 1; s > 0; --s) {
        if (!(info.song.routines[s] instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        for (let c = s - 1; c >= 0; --c) {
            if (!(info.song.routines[c] instanceof routines_1.SongTrackRoutine)) {
                continue;
            }
            if ((0, main_1.routinesMatch)(info.song.routines[s], info.song.routines[c])) {
                (0, main_1.changeReferences)(info, info.song.routines[c], info.song.routines[s]);
                deleteRoutine(info, info.song.routines[c]);
                --s;
            }
        }
    }
}
exports.combineMatchingRoutines = combineMatchingRoutines;
function removeJumpTos(info) {
    if (!info.opt.optimizeJumpTo) {
        return;
    }
    for (let s = info.song.routines.length - 1; s > 0; --s) {
        if (!(info.song.routines[s] instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        let optimize = true, jumpTarget = undefined;
        for (let pos = info.song.routines[s].items.length - 1; pos >= 0; --pos) {
            const item = info.song.routines[s].items[pos];
            if (item instanceof commands_1.SongJump) {
                jumpTarget = item;
            }
            else if (!(item instanceof hints_1.SongHintFracReset || item instanceof hints_1.SongHintPortamentoMode)) {
                optimize = false;
                break;
            }
        }
        if (jumpTarget && optimize) {
            const target = jumpTarget.routine;
            (0, main_1.changeReferences)(info, info.song.routines[s], target);
            deleteRoutine(info, info.song.routines[s]);
        }
    }
}
exports.removeJumpTos = removeJumpTos;
function optimizeTailCalls(info) {
    if (!info.opt.optimizeTailCall) {
        return;
    }
    for (const routine of info.song.routines) {
        if (routine.items[routine.items.length - 1] instanceof commands_1.SongReturn) {
            const item = routine.items[routine.items.length - 2];
            if (item instanceof commands_1.SongCall && item.count === 1) {
                routine.items.splice(routine.items.length - 2, 2, new commands_1.SongJump(item.routine));
            }
        }
    }
}
exports.optimizeTailCalls = optimizeTailCalls;
