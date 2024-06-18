const fs = require("fs");

// ember constants
const TIME = 128;
const COUNT = 10;
const WIDTH = 0x200;
const XCELL = 0x10;
const XCT = WIDTH / XCELL;
const HEIGHT = 0x100;
const YCELL = 0x10;
const YCT = HEIGHT / YCELL;
const LAYERB = true;

// other constants
const XVAR = 2;

// generate header
let str = "";

for(let i = 0;i < TIME;i ++) {
	str += "\tdc.l MGZ_EmberFront_"+ i +"\n";

	if(LAYERB) {
		str += "\tdc.l MGZ_EmberBack_"+ i +"\n";
	}
}

const embers = [];
const embersStart = [];

{
	let yc = 0;
	let ypix = 0;
	let bits = 0;
	let xslot = 0;
	let xnum = 0;

	// init embers
	for(let i = 0;i < COUNT;i ++) {
		// find free x-slot
		do {
			xslot = Math.floor(Math.random() * XCELL);
		} while(bits & (1 << xslot));

		bits |= 1 << xslot;

		// initialize new ember object
		const e = {
			a: Math.random(),
			acc: TIME / Math.floor(1 + (Math.random() * 3)),
			x: (Math.floor(i / XCELL) * XCELL) + xslot + ((XCELL + (XVAR / 2) - Math.floor(Math.random() * XVAR)) % XCELL),
			y: ((yc * YCELL) + ypix + Math.floor(Math.random() * 4)) % HEIGHT,
			back: LAYERB && (i & 3) === 0,
			high: Math.random() > .5,
			speed: 1 + Math.floor(Math.random() * 2),
		};

		embers.push(e);
		embersStart.push({ ...e, });

		// handle y-pos
		if(++yc >= YCT) {
			yc = 0;
			++ypix;
		}

		// handle x-slot
		if(++xnum >= XCELL) {
			xnum = 0;
			bits = 0;
		}
	}
}

// process each ember each frame
for(let t = 0;t < TIME;t ++) {
	for(let e = 0;e < COUNT;e ++) {
		// process ember tick
		embers[e].y = (embers[e].y - embers[e].speed + HEIGHT) % HEIGHT;
	}

	const dataf = { d: [], px: 0, py: 0, lasty: 0, lastx: 0.0000001, first: true, name: "MGZ_EmberFront_", };
	const datab = { d: [], px: 0, py: 0, lasty: 0, lastx: 0.0000001, first: true, name: "MGZ_EmberBack_", };

	// load ember cell data
	for(let yc = 0;yc < YCT;yc ++) {
		dataf.d[yc] = [];
		datab.d[yc] = [];

		for(let xc = 0;xc < XCT;xc ++) {
			dataf.d[yc][xc] = [];
			datab.d[yc][xc] = [];

			for(let e = 0;e < COUNT;e ++) {
				// check if this ember is in this cell
				if(yc !== Math.floor(embers[e].y / YCELL)) {
					continue;
				}

				if(xc !== Math.floor(embers[e].x / XCELL)) {
					continue;
				}

				// add cell data
				if(embers[e].back) {
					datab.d[yc][xc].push(e);

				} else {
					dataf.d[yc][xc].push(e);
				}
			}
		}
	}

	// load final cell data
	for(const d of LAYERB ? [ dataf, datab ] : [ dataf ]) {
		str += "\n\n"+ d.name + t +":";
		d.px = d.py = 0;
		d.lastx = 0.0000001;
		d.lasty = 0;
		d.first = true;

		for(let yc = 0;yc < YCT;yc ++) {
			for(let xc = 0;xc < XCT;xc ++) {
				const celly = yc * YCELL;
				const cellx = xc * XCELL;

				// check if this cell has any data
				if(d.d[yc][xc].length === 0) {
					continue;
				}

				const hi = d.d[yc][xc].filter((e) => embers[e].high);
				const lo = d.d[yc][xc].filter((e) => !embers[e].high);

				// check if y-position mismatch
				if(d.lasty !== celly) {
					if(d.first) {
						d.first = false;

					} else {
						str += "\n\tdc.w -1";
					}

					str += "\n\tdc.w "+ Math.round(celly - d.lasty) +","+ d.name + t +"_PY"+ (d.py + 1) +"-"+ d.name + t +"_PY"+ d.py;
					d.lasty = celly;
					d.lastx = 0.0000001;
					str += "\n"+ d.name + t +"_PY"+ d.py +":";
					d.py++;
				}

				// check if x-position mismatch
				if(d.lastx !== cellx) {
					str += "\n\tdc.w "+ Math.round(cellx - d.lastx) +","+ d.name + t +"_PX"+ (d.px + 1) +"-"+ d.name + t +"_PX"+ d.px;
					d.lastx = cellx;
					str += "\n"+ d.name + t +"_PX"+ d.px +":";
					d.px++;
				}

				// add new cell data
				for(const arr of [ hi, lo ]) {
					str += "\n\tdc.w "+ arr.length;

					for(const e of arr) {
						const _x = embers[e].x % XCELL;
						const _y = embers[e].y % YCELL;
						str += "\n\tdc.b "+ _x +","+ _y;
					}
				}
			}
		}

		str += "\n"+ d.name + t +"_PY"+ d.py +":";
		str += "\n"+ d.name + t +"_PX"+ d.px +":";
		str += "\n\tdc.w -1,-1";
	}
}

// check embers
for(let i = 0;i < COUNT;i ++) {
	if(Math.floor(embers[i].y - embersStart[i].y) !== 0) {
		console.log("ember", i, "y-position mismatch", embers[i].y.toString(16), "vs", embersStart[i].y.toString(16));
	}

	if(Math.floor(embers[i].a - embersStart[i].a) !== 0) {
		console.log("ember", i, "angle mismatch", embers[i].a, "vs", embersStart[i].a);
	}
}

fs.writeFileSync(process.argv[2], str);
