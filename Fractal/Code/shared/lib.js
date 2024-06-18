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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.makeEquate = exports.mergeDeep = exports.isObject = exports.getAsmHexNum = exports.getAsmNum = exports.quickWriteStream = exports.sanitizeFilename = exports.generateID = exports.padTo = exports.hex = exports.word = exports.byte = exports.BinaryFileHelper = exports.BinaryFileType = exports.SyncFileReader = void 0;
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const includer_1 = require("../includer");
const READ_SIZE = 1024;
class SyncFileReader {
    constructor(stream) {
        this.end = this.read = this.closed = false;
        this.stream = stream;
        this.buffer = null;
        this.position = READ_SIZE;
        this.stream.on("readable", () => this.read = true);
        this.stream.on("end", () => this.end = true);
    }
    close() {
        if (this.closed) {
            return;
        }
        this.closed = true;
        this.stream.destroy(undefined);
    }
    lineByLine(line) {
        return __awaiter(this, void 0, void 0, function* () {
            let str = null;
            while ((str = yield this.readLine()) !== null) {
                if (yield line(str)) {
                    break;
                }
            }
            this.close();
        });
    }
    readLine() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.buffer || this.position >= this.buffer.length) {
                this.buffer = null;
                while (!this.end && this.buffer === null) {
                    while (!this.read && !this.end) {
                        yield sleep(5);
                    }
                    this.buffer = this.stream.read(READ_SIZE);
                    if (this.buffer === null) {
                        this.read = false;
                    }
                }
                if (this.buffer === null) {
                    return null;
                }
                this.position = 0;
            }
            let nl = this.position;
            for (; nl < this.buffer.length; nl++) {
                if (this.buffer[nl] === 0x0A) {
                    break;
                }
            }
            if (nl >= this.buffer.length) {
                const ret = this.buffer.toString("utf-8", this.position);
                this.position = 0;
                this.buffer = null;
                const next = yield this.readLine();
                return ret + (next ? next : "");
            }
            const ret = this.buffer.toString("utf-8", this.position, nl);
            this.position = nl + 1;
            return ret;
        });
    }
    getBuffer() {
        return __awaiter(this, void 0, void 0, function* () {
            const buf = [];
            do {
                while (!this.end && this.buffer === null) {
                    while (!this.read && !this.end) {
                        yield sleep(5);
                    }
                    this.buffer = this.stream.read(READ_SIZE);
                    if (this.buffer === null) {
                        this.read = false;
                    }
                }
                if (this.buffer === null) {
                    break;
                }
                buf.push(this.buffer);
                this.buffer = null;
            } while (true);
            return Buffer.concat(buf);
        });
    }
    loadBinaryFile(type) {
        return new Promise((res, rej) => {
            this.getBuffer().then((buf) => {
                switch (type) {
                    case BinaryFileType.Uncompressed:
                        return res(new BinaryFileHelper(buf));
                }
            }).catch(rej);
        });
    }
}
exports.SyncFileReader = SyncFileReader;
var BinaryFileType;
(function (BinaryFileType) {
    BinaryFileType[BinaryFileType["Uncompressed"] = 0] = "Uncompressed";
})(BinaryFileType = exports.BinaryFileType || (exports.BinaryFileType = {}));
class BinaryFileHelper {
    constructor(buffer) {
        this.buffer = buffer;
        this.buffer = buffer;
        this.position = 0;
    }
    skipBytes(offset) {
        this.position = this.getPosition(offset);
    }
    getPosition(offset) {
        let pos = this.position;
        if (offset) {
            if (pos + offset < 0 || pos + offset > this.buffer.byteLength) {
                throw new RangeError("Buffer position is out of range!");
            }
            pos += offset;
        }
        return pos;
    }
    setPosition(position) {
        if (position < 0 || position > this.buffer.byteLength) {
            throw new RangeError("Buffer position is out of range!");
        }
        this.position = position;
    }
    getASCII(length, position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (pos + length >= this.buffer.length) {
            throw new RangeError("String length is too large for buffer!");
        }
        this.setPosition(pos + length);
        return this.buffer.toString("ascii", pos, pos + length);
    }
    readString(encoding, position) {
        const end = this.findByte(0, position);
        const pos = position !== null && position !== void 0 ? position : this.position;
        this.setPosition(end + 1);
        return this.buffer.toString(encoding, pos, end);
    }
    findByte(byte, position) {
        let pos = position !== null && position !== void 0 ? position : this.position;
        while (pos < this.buffer.length) {
            if (this.buffer.readUInt8(pos) === byte) {
                return pos;
            }
            pos++;
        }
        throw new RangeError("Could not find the requested byte before end of buffer!");
    }
    readInt8(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 1);
        }
        return this.buffer.readInt8(pos);
    }
    readUInt8(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 1);
        }
        return this.buffer.readUInt8(pos);
    }
    readInt16LE(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 2);
        }
        return this.buffer.readInt16LE(pos);
    }
    readUInt16LE(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 2);
        }
        return this.buffer.readUInt16LE(pos);
    }
    readInt32LE(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 4);
        }
        return this.buffer.readInt32LE(pos);
    }
    readUInt32LE(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 4);
        }
        return this.buffer.readUInt32LE(pos);
    }
    readFloat32LE(position) {
        const pos = position !== null && position !== void 0 ? position : this.position;
        if (!position) {
            this.setPosition(this.position + 4);
        }
        return this.buffer.readFloatLE(pos);
    }
}
exports.BinaryFileHelper = BinaryFileHelper;
function byte(value) {
    if (value < 0) {
        return "-0x" + hex(2, -value);
    }
    return "0x" + hex(2, value);
}
exports.byte = byte;
function word(value) {
    if (value < 0) {
        return "-0x" + hex(4, -value);
    }
    return "0x" + hex(4, value);
}
exports.word = word;
function hex(digits, value) {
    return value.toString(16).toUpperCase().padStart(digits, "0");
}
exports.hex = hex;
function padTo(padding, text) {
    if (padding < text.length) {
        return text + " ";
    }
    let position = 0;
    for (let p = 0; p < text.length; p++) {
        if (text[p] === "\t") {
            position += (position & 7) === 0 ? 8 : 8 - (position & 7);
        }
        else {
            position++;
        }
    }
    if (padding <= position) {
        return text + " ";
    }
    let append = "\t";
    position += 8 - (position & 7);
    while (position < padding) {
        append += "\t";
        position += 8;
    }
    return text + append;
}
exports.padTo = padTo;
function generateID() {
    let id = "";
    for (let i = 0; i < 6; i++) {
        id += "ABCDEFGHIJKLMNOPQRSTUVWXYZ_"[Math.floor(Math.random() * 27)];
    }
    return id;
}
exports.generateID = generateID;
function sanitizeFilename(file) {
    return path_1.default.parse(file).name.replace(/[^0-9a-z]/gi, "_");
}
exports.sanitizeFilename = sanitizeFilename;
function quickWriteStream(file) {
    const stream = fs_1.default.createWriteStream(file, "ascii");
    let drain = false;
    stream.on("drain", () => drain = true);
    const write = (data) => __awaiter(this, void 0, void 0, function* () {
        if (!stream.write(data)) {
            drain = false;
            while (!drain) {
                yield sleep(2);
            }
        }
    });
    return { write, close: () => stream.close(), };
}
exports.quickWriteStream = quickWriteStream;
function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}
function getAsmNum(str) {
    let text = str;
    const neg = text.startsWith("-");
    if (neg) {
        text = text.substring(1);
    }
    if (text.startsWith("$") && /\$[0-9A-F]{1,8}/i.test(text)) {
        return getAsmHexNum(text.substring(1)) * (neg ? -1 : 1);
    }
    if (text.startsWith("0x") && /0x[0-9A-F]{1,8}/i.test(text)) {
        return getAsmHexNum(text.substring(2)) * (neg ? -1 : 1);
    }
    if (text.startsWith("%") && /%[01]{1,64}/i.test(text)) {
        return parseInt(text.substring(1), 2) * (neg ? -1 : 1);
    }
    if (text.startsWith("0b") && /0b[01]{1,64}/i.test(text)) {
        return parseInt(text.substring(2), 2) * (neg ? -1 : 1);
    }
    return Number(text) * (neg ? -1 : 1);
}
exports.getAsmNum = getAsmNum;
function getAsmHexNum(text) {
    const parts = text.split(".");
    switch (parts.length) {
        case 1: return parseInt(text, 16);
        case 2:
            if (parts[1].length > 4) {
                return NaN;
            }
            return parseInt(parts[0], 16) + (parseInt(parts[1].padEnd(8, "0"), 16) / 0x100000000);
        default: return NaN;
    }
}
exports.getAsmHexNum = getAsmHexNum;
function isObject(item) {
    return typeof item === "object" && !Array.isArray(item);
}
exports.isObject = isObject;
function mergeDeep(target, ...sources) {
    if (!sources.length || !isObject(target)) {
        return target;
    }
    for (const src of sources) {
        if (isObject(src)) {
            for (const key in src) {
                if (isObject(src[key])) {
                    if (!target[key]) {
                        Object.assign(target, { [key]: {}, });
                    }
                    mergeDeep(target[key], src[key]);
                }
                else {
                    Object.assign(target, { [key]: src[key], });
                }
            }
        }
    }
    return target;
}
exports.mergeDeep = mergeDeep;
function makeEquate(name, padding, value) {
    if (includer_1.assemblerSettings.specialEqu) {
        return "\t" + includer_1.assemblerSettings.equ + " " + name + ", " + value + "\n";
    }
    return padTo(padding, name) + includer_1.assemblerSettings.equ + " " + value + "\n";
}
exports.makeEquate = makeEquate;
