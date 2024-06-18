using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S3KObjectDefinitions.FDZ {
	class PlatformGMZ : Platform {
		public override string Mappings { get { return "../Objects/Floating Platform/Object data/Map - Floating PlatformMGZ1.asm"; } }
	}

	class Platform : ObjectDefinition {
		public virtual string Mappings { get { return "../Objects/Floating Platform/Object data/Map - Floating PlatformFDZ.asm"; } }
		public virtual string MappingsStone { get { return "../Objects/Floating Platform/Object data/Map - Floating PlatformFDZ (Stone).asm"; } }
		private Sprite img;
		private Sprite imgStone;

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Note", typeof(string), "Extended", null, null, (o) => "Add 0x80 to subtype to make the platform stone", null)
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetAppearance(ObjectEntry obj)
		{
			return "Add 0x80 to subtype to make the platform stone";
		}

		private string[] SubtypeList = {
			"No movement",
			"Left to right, 64px",
			"Left to right, 128px",
			"Bottom to top, 64px",
			"Bottom to top, 128px",
			"Diagonally: left-bottom to right-top, 128х64px",
			"Diagonally: right-bottom to left-top, 128х64px",
			"Goes up after standing on it",
			"Up right down left, 64px",
			"Up right down left, 128px",
			"Up right down left, 192px",
			"Up right down left, 256px",
			"Left to right, 256px",
			"Static",
			"Oscillating up and down"
		};

		private int[] SubTypesData = {
		//  x           y           x1          y1          width       height      //ID
			0,          0,          0,          0,          0,          0,          //$0
			0,          0,          64,         0,          0,          0,          //$1
			0,          0,          128,        0,          0,          0,          //$2
			0,          0,          0,         -64,         0,          0,          //$3
			0,          0,          0,         -128,        0,          0,          //$4
			0,          0,          128,       -64,         0,          0,          //$5
			128,        0,          0,         -64,         0,          0,          //$6
			0,          0,          0,          0,          0,          0,          //$7
			0,          0,         -16,        -16,         32,         32,         //$8
			0,          0,         -48,        -48,         96,         96,         //$9
			0,          0,         -80,        -80,         160,        160,        //$A
			0,          0,         -112        -112,        224,        224,        //$B
			0,          0,          256,        0,          0,          0,          //$C
			0,          0,          0,          0,          0,          0,          //$D
			0,          0,          0,         -4,          0,          8,          //$E
			0,          0,          0,          0,          0,          0,          //$F
		};

		public override void Init(ObjectData data) {
			byte[] artfile = ObjectHelper.OpenArtFile("LevelArt", CompressionType.KosinskiM);
			img = ObjectHelper.MapASMToBmp(artfile, Mappings, 0, 2);
			imgStone = ObjectHelper.MapASMToBmp(artfile, MappingsStone, 0, 2);
		}

		public override ReadOnlyCollection<byte> Subtypes {
			get { return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }); }
		}

		public override string Name {
			get { return "Floating Platform"; }
		}

		public override string SubtypeName(byte subtype) {
			return SubtypeList[(int)subtype];
		}

		public override Sprite Image {
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype) {
			return img;
		}

		public override Sprite GetSprite(ObjectEntry obj) {
			/*int w = ((obj.SubType >> 4) + 1) * 16;
            int h = ((obj.SubType & 0xF) + 1) * 16;
            BitmapBits bmp = new BitmapBits(w, h);
            bmp.DrawRectangle(0xC, 0, 0, w - 1, h - 1);
               for (int i = 1; i < w/2; i++)
                    bmp.DrawLine(0xD, i*2, 0, i*2, h - 1);
               //14 17 14
            Sprite spr = new Sprite(bmp, new Point(-(w / 2), -(h / 2)));
            spr.Offset = new Point(spr.X + obj.X, spr.Y + obj.Y);*/

			List<Sprite> sprs = new List<Sprite>();
			int st = obj.SubType;
			Sprite currentImg = st < 0x80 ? img : imgStone;
			if (st > 0x80) 
				st -= 0x80;
			if (st > 15)
				st = 0;
			int xp = SubTypesData[st * 6];
			int yp = SubTypesData[st * 6 + 1];
			int x = SubTypesData[st * 6 + 2];
			int y = SubTypesData[st * 6 + 3];
			int w = SubTypesData[st * 6 + 4] + 64;
			int h = SubTypesData[st * 6 + 5] + 32;

			if (st >= 8 || st <= 11) {
				if (obj.XFlip) {
					x = SubTypesData[st * 6];
					y = SubTypesData[st * 6 + 1];
					xp = SubTypesData[st * 6 + 2];
					yp = SubTypesData[st * 6 + 3];
				}
			}

			BitmapBits bmp = new BitmapBits(w, h);
			bmp.DrawRectangle(0x10, 0, 0, w - 1, h - 1);
			bmp.DrawRectangle(0x17, 1, 1, w - 3, h - 3);
			bmp.DrawRectangle(0x10, 2, 2, w - 5, h - 5);

			sprs.Add(new Sprite(bmp, new Point(x - 64, y - 32)));

			sprs.Add(new Sprite(currentImg, new Point(currentImg.X + xp, currentImg.Y + yp)));

			Sprite spr = new Sprite(sprs.ToArray());
			spr.Offset(32, 16);
			return spr;
		}

		public override Rectangle GetBounds(ObjectEntry obj) {
			int st = obj.SubType;
			if (st > 15)
				st = 0;
			int w = 64;
			int h = 32;
			int xp = SubTypesData[st * 6];
			int yp = SubTypesData[st * 6 + 1];
			if (st >= 8 || st <= 11) {
				if (obj.XFlip) {
					xp = SubTypesData[st * 6 + 2];
					yp = SubTypesData[st * 6 + 3];
				}
			}
			return new Rectangle(obj.X - (w / 2) + xp, obj.Y - (h / 2) + yp, w, h);
		}

		public override bool Debug { get { return true; } }
	}
}
