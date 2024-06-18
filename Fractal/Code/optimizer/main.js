"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routinesMatch = exports.changeReferences = exports.unoptimizeCall = exports.countReferences = exports.removeItem = exports.optimize = exports.getOptimizerString = void 0;
const commands_1 = require("../shared/commands");
const routines_1 = require("../shared/routines");
const commands_2 = require("./commands");
const loops_1 = require("./loops");
const misc_1 = require("./misc");
const routines_2 = require("./routines");
function getOptimizerString(options) {
    if (options.disable) {
        return "-";
    }
    let str = "";
    const get = (data, base) => {
        for (const key of Object.keys(data)) {
            if (Array.isArray(data[key])) {
                if (data[key].length > 0) {
                    str += base + key + ":[" + data[key].join(",") + "],";
                }
            }
            else if (typeof data[key] === "object") {
                get(data[key], base + key + ".");
            }
            else if (typeof data[key] === "boolean") {
                if (data[key]) {
                    str += base + key + ",";
                }
            }
            else if (typeof data[key] === "number" || typeof data[key] === "string") {
                if (data[key]) {
                    str += base + key + ":" + data[key] + ",";
                }
            }
            else {
                str += "?" + base + key + ",";
            }
        }
    };
    get(options, "");
    return str;
}
exports.getOptimizerString = getOptimizerString;
function optimize(song, helper, options) {
    if (options.disable) {
        return song;
    }
    const info = { song, opt: options, loop: 0, jump: 0, };
    (0, routines_2.combineRoutines)(info);
    (0, commands_2.mergeCommands)(info);
    (0, commands_2.combineTies)(info);
    (0, misc_1.omitUnusedRoutines)(info);
    (0, loops_1.createLoops)(info);
    (0, loops_1.optimizeLongNotes)(info);
    (0, routines_2.combineRoutines)(info);
    (0, routines_2.combineMatchingRoutines)(info);
    (0, misc_1.omitUnusedRoutines)(info);
    (0, loops_1.createCalls)(info);
    (0, commands_2.mergeCommands)(info);
    (0, routines_2.optimizeTailCalls)(info);
    (0, routines_2.removeJumpTos)(info);
    (0, loops_1.limitStack)(info);
    (0, routines_2.combineRoutines)(info);
    (0, routines_2.combineMatchingRoutines)(info);
    (0, misc_1.omitUnusedRoutines)(info);
    (0, misc_1.omitUnused)(info);
    (0, misc_1.omitUnusedRoutines)(info);
    (0, commands_2.optimizeNotes)(info);
    (0, routines_2.combineMatchingRoutines)(info);
    (0, routines_2.reorderRoutines)(info);
    song.fixLabels();
    return song;
}
exports.optimize = optimize;
function removeItem(routine, item) {
    const ix = routine.items.indexOf(item);
    if (ix < 0) {
        return false;
    }
    routine.items.splice(ix, 1);
    return true;
}
exports.removeItem = removeItem;
function countReferences(info, target) {
    let references = 0, loops = 0;
    for (const routine of info.song.routines) {
        for (const item of routine.items) {
            if (item instanceof commands_1.SongCall) {
                if (item.routine === target) {
                    references++;
                    loops += item.count;
                }
            }
            else if (item instanceof commands_1.SongJump || item instanceof commands_1.SongBitJump || item instanceof commands_1.SongCondJump || item instanceof commands_1.SongCont) {
                if (item.routine === target) {
                    references++;
                    loops++;
                }
            }
        }
    }
    return { references, loops, };
}
exports.countReferences = countReferences;
function unoptimizeCall(info, source, target) {
    const items = [];
    for (const item of target.items) {
        if (item instanceof commands_1.SongJump) {
            items.push(new commands_1.SongCall(item.routine, 1));
        }
        else if (item instanceof commands_1.SongReturn) {
        }
        else {
            items.push(item);
        }
    }
    for (let i = source.items.length - 1; i >= 0; --i) {
        const item = source.items[i];
        if (item instanceof commands_1.SongCall && item.routine === target) {
            source.items.splice(i, 1);
            for (let c = 0; c < item.count; c++) {
                source.items.splice(i, 0, ...items.map((i) => i.clone(info.song)));
            }
        }
    }
}
exports.unoptimizeCall = unoptimizeCall;
function changeReferences(info, from, to) {
    for (const sub of Object.values(info.song.songs)) {
        for (const channel of sub.channels) {
            if (channel.routine === from) {
                channel.routine = to;
            }
        }
    }
    for (const routine of info.song.routines) {
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        for (const item of routine.items) {
            if (item.subtype !== commands_1.SongCommandSubtype.TargetCommand) {
                continue;
            }
            if (item.routine === from) {
                item.routine = to;
            }
        }
    }
}
exports.changeReferences = changeReferences;
function routinesMatch(r1, r2) {
    if (r1.items.length !== r2.items.length) {
        return false;
    }
    for (let i = 0; i < r1.items.length; i++) {
        if (!r1.items[i].equals(r2.items[i], {})) {
            return false;
        }
    }
    return true;
}
exports.routinesMatch = routinesMatch;
