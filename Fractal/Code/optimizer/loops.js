"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.limitStack = exports.optimizeLongNotes = exports.createLoops = exports.createCalls = exports.collectRoutineHints = void 0;
const commands_1 = require("../shared/commands");
const hints_1 = require("../shared/hints");
const lib_1 = require("../shared/lib");
const notes_1 = require("../shared/notes");
const routines_1 = require("../shared/routines");
const main_1 = require("./main");
function collectRoutineHints(rt, start, end) {
    const hints = { portamento: false, };
    for (let i = start; i < end; i++) {
        const item = rt.items[i];
        if (item instanceof commands_1.SongPortaSpeed) {
            hints.portamento = item.value !== 0;
        }
        else if (item instanceof hints_1.SongHintPortamentoMode) {
            hints.portamento = item.value;
        }
    }
    const ret = [];
    if (hints.portamento) {
        ret.push(new hints_1.SongHintPortamentoMode(true));
    }
    return ret;
}
exports.collectRoutineHints = collectRoutineHints;
function createCalls(info) {
    var _a, _b, _c;
    if (((_a = info.opt.call) === null || _a === void 0 ? void 0 : _a.enabled) !== true || ((_c = (_b = info.opt.call.entries) === null || _b === void 0 ? void 0 : _b.length) !== null && _c !== void 0 ? _c : 0) === 0) {
        return;
    }
    for (const entry of info.opt.call.entries) {
        for (let s = 0; s < info.song.routines.length - 1; s++) {
            if (!(info.song.routines[s] instanceof routines_1.SongTrackRoutine)) {
                continue;
            }
            for (let c = s; c < info.song.routines.length - 1; c++) {
                if (!(info.song.routines[c] instanceof routines_1.SongTrackRoutine)) {
                    continue;
                }
                if (checkCallOpt(info, info.song.routines[s], info.song.routines[c], entry[0], entry[1])) {
                    c--;
                }
            }
        }
    }
}
exports.createCalls = createCalls;
function checkCallOpt(info, r1, r2, num, shift) {
    const same = r1 === r2;
    for (let p1 = 0; p1 < r1.items.length - num; p1++) {
        for (let p2 = same ? p1 + num : 0; p2 < r2.items.length - num; p2++) {
            for (let plen = 0; !same || p1 + plen < p2; plen++) {
                const end = (plen + p1 >= r1.items.length) || (plen + p2 >= r2.items.length);
                if (end || !r1.items[p1 + plen].equals(r2.items[p2 + plen], { noteShift: shift, })) {
                    plen -= +end;
                    if (plen < num) {
                        break;
                    }
                    const rt = info.song.getOrMakeRoutine(info.song.moduleId + "_J" + (0, lib_1.hex)(4, info.jump++), routines_1.RoutineType.SongTrack, false, r1.flags);
                    if (!rt.routine) {
                        console.log("Call optimization failed for unknown reason.");
                        return;
                    }
                    rt.routine.items.push(...collectRoutineHints(r1, 0, p1));
                    rt.routine.items.push(...collectRoutineHints(r2, 0, p2));
                    rt.routine.items.push(...r1.items.slice(p1, p1 + plen));
                    rt.routine.items.push(new commands_1.SongReturn());
                    const _items = shift !== 0 ?
                        [new commands_1.SongAddFraction(shift * 0x100), new commands_1.SongCall(rt.routine, 1), new commands_1.SongAddFraction(shift * -0x100),]
                        : [new commands_1.SongCall(rt.routine, 1),];
                    r2.items.splice(p2, plen, ..._items);
                    r1.items.splice(p1, plen, ..._items.map((i) => i.clone()));
                    return true;
                }
            }
        }
    }
    return false;
}
function createLoops(info) {
    var _a, _b;
    if (((_a = info.opt.loop) === null || _a === void 0 ? void 0 : _a.enabled) !== true) {
        return;
    }
    for (let i = 0; i < info.song.routines.length; i++) {
        const routine = info.song.routines[i];
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        if (routine.items.length < 4) {
            continue;
        }
        let done = false;
        for (let len = 2; !done && len < Math.floor(routine.items.length / 2); len++) {
            for (let pos = 0; !done && pos + len < routine.items.length - len; pos++) {
                let loops = 1, bytes = 0, failed = false, lastSuccess = false;
                for (; !failed && pos + (len * (loops + 1)) < routine.items.length; loops++) {
                    for (let pp = len - 1; pp >= 0; --pp) {
                        if (!routine.items[pos + pp].equals(routine.items[pos + pp + (len * loops)], {})) {
                            failed = true;
                            loops--;
                            break;
                        }
                        bytes += routine.items[pos + pp].getByteCount();
                    }
                    lastSuccess = lastSuccess || !failed;
                }
                if (lastSuccess && loops > 1 && bytes >= ((_b = info.opt.loop) === null || _b === void 0 ? void 0 : _b.minBytes)) {
                    const rt = info.song.getOrMakeRoutine(info.song.moduleId + "_L" + (0, lib_1.hex)(4, info.loop++), routines_1.RoutineType.SongTrack, false, routine.flags);
                    if (!rt.routine) {
                        console.log("Loop optimization failed for unknown reason.");
                        return;
                    }
                    const items = [new commands_1.SongCall(rt.routine, loops % 0x100),];
                    while (loops > 0x100) {
                        items.push(new commands_1.SongCall(rt.routine, 0x100));
                        loops -= 0x100;
                    }
                    rt.routine.items.push(...collectRoutineHints(routine, 0, pos));
                    rt.routine.items.push(...routine.items.slice(pos, pos + len));
                    routine.items.splice(pos, len * loops, ...items);
                    rt.routine.items.push(new commands_1.SongReturn());
                    --i;
                    done = true;
                    break;
                }
            }
        }
    }
}
exports.createLoops = createLoops;
function optimizeLongNotes(info) {
    var _a;
    if (((_a = info.opt.longNotes) === null || _a === void 0 ? void 0 : _a.enabled) !== true || typeof info.opt.longNotes.minBytes !== "number") {
        return;
    }
    for (let i = 0; i < info.song.routines.length; i++) {
        const routine = info.song.routines[i];
        if (!(routine instanceof routines_1.SongTrackRoutine)) {
            continue;
        }
        for (let i = 0; i < routine.items.length; i++) {
            const item = routine.items[i];
            if (!(item instanceof notes_1.SongNote)) {
                continue;
            }
            if (!item.delay || item.getByteCount() < info.opt.longNotes.minBytes) {
                continue;
            }
            let loops = Math.floor(item.delay / 0x100);
            item.delay %= 0x100;
            if (item.delay === 0) {
                item.delay = 0x100;
                loops--;
            }
            const rt = info.song.getOrMakeRoutine(info.song.moduleId + "_L" + (0, lib_1.hex)(4, info.loop++), routines_1.RoutineType.SongTrack, false, routine.flags);
            if (!rt.routine) {
                console.log("Long note optimization failed for unknown reason.");
                return;
            }
            const note = item.getConnector();
            rt.routine.items.push(new notes_1.SongNote(note, 0x100, note === null));
            rt.routine.items.push(new commands_1.SongReturn());
            const items = [new commands_1.SongCall(rt.routine, loops % 0x100),];
            while (loops > 0x100) {
                items.push(new commands_1.SongCall(rt.routine, 0x100));
                loops -= 0x100;
            }
            routine.items.splice(i + 1, 0, ...items);
        }
    }
}
exports.optimizeLongNotes = optimizeLongNotes;
function limitStack(info) {
    var _a, _b;
    if (((_b = (_a = info.opt) === null || _a === void 0 ? void 0 : _a.stackSize) !== null && _b !== void 0 ? _b : 0) < 1) {
        return;
    }
    for (const sub of Object.values(info.song.songs)) {
        for (let c = 0; c < sub.channels.length;) {
            const stack = [];
            const getRt = (rt, jumpStack) => {
                jumpStack.push(rt);
                for (const item of rt.items) {
                    if (item instanceof commands_1.SongJump) {
                        if (jumpStack.includes(item.routine)) {
                            return null;
                        }
                        return getRt(item.routine, [...jumpStack,]);
                    }
                    else if (item instanceof commands_1.SongCall) {
                        if (jumpStack.includes(item.routine)) {
                            return null;
                        }
                        stack.push([item, rt, 0,]);
                        const ret = getRt(item.routine, [...jumpStack,]);
                        stack.pop();
                        if (ret !== null) {
                            return ret;
                        }
                    }
                    else if (item instanceof commands_1.SongReturn || item instanceof commands_1.SongStop || item instanceof commands_1.SongBackup) {
                        if (stack.length > info.opt.stackSize) {
                            return processStackLimit(info, stack);
                        }
                    }
                }
                return null;
            };
            if (getRt(sub.channels[c].routine, []) === null) {
                c++;
            }
        }
    }
}
exports.limitStack = limitStack;
function processStackLimit(info, stack) {
    stack.forEach((c) => {
        const b = c[0].routine.getByteCount();
        const { loops, references, } = (0, main_1.countReferences)(info, c[0].routine);
        c[2] = b + (b * loops) - (4 * references);
    });
    const newStack = stack.sort((a, b) => a[2] - b[2]);
    while (newStack.length > info.opt.stackSize) {
        const call = newStack.shift();
        (0, main_1.unoptimizeCall)(info, call[1], call[0].routine);
    }
    return true;
}
