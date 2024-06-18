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
const promises_1 = __importDefault(require("fs/promises"));
const json5_1 = require("./shared/json5");
const includer_1 = require("./includer");
(() => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b, _c, _d, _e, _f;
    let assembler = includer_1.Assembler.ASM68K;
    const args = process.argv;
    args.shift();
    args.shift();
    if (args.length < 1) {
        usage();
    }
    let special = false;
    let songdir = process.cwd() + "/Songs";
    let incdir = process.cwd() + "/Includes";
    let resdir = process.cwd();
    let asmext = "asm";
    while (args.length >= 1 && args[0].startsWith("-")) {
        const flag = args[0].toLowerCase();
        args.shift();
        switch (flag) {
            case "-special":
                special = true;
                break;
            case "-as":
                assembler = includer_1.Assembler.AS;
                break;
            case "-gas":
                assembler = includer_1.Assembler.GAS;
                break;
            case "-base":
                resdir = (_a = args.shift()) !== null && _a !== void 0 ? _a : "<invalid>";
                songdir = resdir + "/Songs";
                incdir = resdir + "/Includes";
                break;
            case "-songbase":
                songdir = (_b = args.shift()) !== null && _b !== void 0 ? _b : "<invalid>";
                break;
            case "-resbase":
                resdir = (_c = args.shift()) !== null && _c !== void 0 ? _c : "<invalid>";
                break;
            case "-incbase":
                incdir = (_d = args.shift()) !== null && _d !== void 0 ? _d : "<invalid>";
                break;
            case "-asmext":
                asmext = (_e = args.shift()) !== null && _e !== void 0 ? _e : "asm";
                break;
            default:
                console.error("Unknown option \"" + flag + "\"! Ignoring...");
                break;
        }
    }
    if (args.length < 1) {
        usage();
    }
    songdir = songdir.replace(/\\/g, "/");
    incdir = incdir.replace(/\\/g, "/");
    resdir = resdir.replace(/\\/g, "/");
    if (!songdir.endsWith("/")) {
        songdir += "/";
    }
    if (!incdir.endsWith("/")) {
        incdir += "/";
    }
    if (!resdir.endsWith("/")) {
        resdir += "/";
    }
    (0, includer_1.setFolders)(incdir, resdir, songdir, asmext);
    const data = json5_1.json5.parse((yield promises_1.default.readFile((_f = args.shift()) !== null && _f !== void 0 ? _f : "")).toString());
    if (special) {
        yield (0, includer_1.generateSpecialIncludes)("include");
        return;
    }
    process.exit(yield (0, includer_1.processData)(data, "defaultpreset", assembler, true));
}))().catch((e) => {
    console.error(e);
    process.exit(1);
});
function usage() {
    console.log("You are missing some arguments!");
    console.log("");
    console.log("Usage:");
    console.log("node Fractal/Code/game.js [options] json5config");
    console.log("");
    console.log("options:");
    console.log("    -as               Changes the output to work with AS correctly.");
    console.log("    -base <directory> Set <directory> as the new base directory (driver directory). Otherwise, working directory is used.");
    console.log("    -special          Uses a special mode for generating file includes for all the special files. Some options will be ignored.");
    console.log("");
    console.log("arguments:");
    console.log("    json5config       File location of the json5-formatted configuration. By default, this should be Fractal/Code/Data.json5");
    console.log("");
    console.log("example:");
    console.log("node Fractal/Code/game.js -base Fractal Fractal/Code/Data.json5");
    process.exit(-1);
}
