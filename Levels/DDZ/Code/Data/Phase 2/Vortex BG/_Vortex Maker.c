// =============================================================================
// -----------------------------------------------------------------------------
// Vortex Maker - MarkeyJester
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include <gl/gl.h>
#include <gl/glu.h>
#include <math.h>
#include <direct.h>
#include "..\..\..\..\..\..\_Headers\_bitmapx.h"

#define rangeof(ENTRY) (0x01<<(0x08*sizeof(ENTRY)))

#define L 0x1000
char T [L];
int P;

const char ProgName [] = "Vortex Maker";
const char ProgWinClass [] = "Window Class";
RECT RectWindow = { 0, 0, 320, 224 }; // 600, 500 };
int WindowStyles = WS_THICKFRAME | WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;

#define HELD 0
#define PRESSED rangeof(u_char)
bool Keys [rangeof (u_char)*2];

HDC hdc;
HGLRC hrc;

// -----------------------------------------------------------------------------
// Structures
// -----------------------------------------------------------------------------

struct GLCOLOUR

{
	float R;
	float G;
	float B;
};

struct GLCOLSTRIP

{
	GLCOLOUR *C;
	float S;
};

struct GLSTRIPLIST

{
	GLCOLSTRIP *C;
	float S;
};

// =============================================================================
// -----------------------------------------------------------------------------
// Subroutine to enable Open GL
// -----------------------------------------------------------------------------

void EnableOpenGL (HWND hwnd)

{
	PIXELFORMATDESCRIPTOR pfd;
	int iFormat;

	/* get the device context (DC) */

	hdc = GetDC (hwnd);

	/* set the pixel format for the DC */

	ZeroMemory (&pfd, sizeof (pfd));

	pfd.nSize	= sizeof (pfd);
	pfd.nVersion	= 1;
	pfd.dwFlags	= PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;
	pfd.iPixelType	= PFD_TYPE_RGBA;
	pfd.cColorBits	= 32;
	pfd.cDepthBits	= 16;
	pfd.iLayerType	= PFD_MAIN_PLANE;

	iFormat = ChoosePixelFormat (hdc, &pfd);
	SetPixelFormat (hdc, iFormat, &pfd);

	/* create and enable the render context (RC) */

	hrc = wglCreateContext (hdc);
	wglMakeCurrent (hdc, hrc);

	/* Use depth buffering for hidden surface elimination. */

	glEnable (GL_DEPTH_TEST);
}

// =============================================================================
// -----------------------------------------------------------------------------
// Subroutine to disable Open GL
// -----------------------------------------------------------------------------

void DisableOpenGL (HWND hwnd)

{
	wglMakeCurrent (NULL, NULL);
	wglDeleteContext (hrc);
	ReleaseDC (hwnd, hdc);
}

// =============================================================================
// -----------------------------------------------------------------------------
// Storage versions of gl routines
// -----------------------------------------------------------------------------

void SglColor3f (float Red, float Green, float Blue)

{
	glColor3f (Red, Green, Blue);
}

void SglVertex3f (float X, float Y, float Z)

{
	glVertex3f (X, Y, Z);
}

void SglBegin (int MODE)

{
	glBegin (MODE);
}

// =============================================================================
// -----------------------------------------------------------------------------
// Subroutine to draw graphics using OpenGL
// -----------------------------------------------------------------------------

// IMG BG1, BG2;

const float SectThick [] = { 14.0, 45.0, 18.0, 17.0, -1 };
const float ArrowEdgeDiv = 6;

float CameraX = 0.0;
float CameraY = 0.0;
float CameraZ = -3.0;
float DestX = 0.0;
float DestY = 0.0;
float DestZ = -7.0;
float ScreenAspect;
int ScreenWidth, ScreenHeight;
float CameraAngle = 0.0;
float CameraPerspect = 22.5;
float Thickness = 10.0;
float Length = 2.0;
float Twist = 20.0;

int Frame = 0;
int Range = 0x10;			// Total number of frames (1 to 0x10)

float Speed = (8 / ((float) Range));	// 8 is the distance before the pattern loops


bool Wireframe = FALSE;

void DrawGraphics (HWND hwnd)

{
	RECT RectClient;
	GetClientRect (hwnd, &RectClient);
	ScreenWidth = RectClient.right-RectClient.left;
	ScreenHeight = RectClient.bottom-RectClient.top;
	ScreenAspect = (float) ScreenWidth / (float) ScreenHeight;

//	if (ScreenWidth == 256)
//	{
//		ScreenAspect = (float) 320.0 / (float) ScreenHeight;
//	}

	// --- Setting Open GL screen/camera ---

	glViewport (0, 0, ScreenWidth, ScreenHeight);


	if (Keys [VK_INSERT+PRESSED] == TRUE)
	{
		if (Wireframe == FALSE)
		{
			Wireframe = TRUE;
		}
		else
		{
			Wireframe = FALSE;
		}
	}
	if (Keys [VK_UP] == TRUE)
	{
		CameraZ += Speed;
		DestZ += Speed;
		Frame++;
	}
	if (Keys [VK_DOWN] == TRUE)
	{
		CameraZ -= Speed;
		DestZ -= Speed;
		Frame--;
	}
	if (Keys [VK_LEFT] == TRUE)
	{
		CameraAngle += 4.0;
	}
	if (Keys [VK_RIGHT] == TRUE)
	{
		CameraAngle -= 4.0;
	}
	CameraX = DestX - sin ((CameraAngle*3.14159265)/180) * 5.0;
	CameraZ = DestZ - cos ((CameraAngle*3.14159265)/180) * 5.0;


	glMatrixMode (GL_MODELVIEW);						// set mode to GL_MODELVIEW
	glLoadIdentity ( );							// load GL_MODELVIEW's current setting
	glPushMatrix ( );							// store GL_MODELVIEW's current setting (just temporarily editing it)
	gluLookAt (		CameraX,CameraY,CameraZ,			// eye position
				DestX, DestY, DestZ,				// center position
				0.0, 1.0, 0.0);					// up is in positive Y direction

	if (Wireframe == FALSE)
	{
		glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
	}
	else
	{
		glPolygonMode (GL_FRONT_AND_BACK, GL_LINE);
	}

	// --- The polygon rendering itself ---

	glMatrixMode (GL_PROJECTION);					// set mode to GL_PROJECTION
	glLoadIdentity ( );						// load GL_PROJECTION's current setting
	glPushMatrix ( );						// store GL_PROJECTION's current setting (just temporarily editing it)
	gluPerspective (	CameraPerspect, //45.0,			// field of view in degree
				ScreenAspect,	// 4/3,			// aspect ratio (set to size of screen, ensures no stretching)
				1.0,		// 1.0			// Z near
				140.0);		// 256.0		// Z far

	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	SglBegin (GL_QUADS);
	int Odd = 0;
	int Col = 0;
	for (float Angle = 0; Angle < 360; Angle += Thickness, Col = ++Col & 1)
	{
		float Ang = Angle - (((CameraZ / 4) * Twist) / Length);
		int Row = 0;

	float ThickP = Thickness;
	//float ThickS = (0.02 * CameraZ) / 4;

	int SkipP = 0, SkipR = 0x8000;
		for (float Z = 0.0; Z < 1024.0*2; Z += Length, Ang += Twist, Row = ++Row & 1, Odd = ++Odd & 3)
		{
			float X1 = sin (((Ang+0.0)*3.14159265)/180) * ThickP;
			float X2 = sin (((Ang+ThickP)*3.14159265)/180) * ThickP;
			float Y1 = cos (((Ang+0.0)*3.14159265)/180) * ThickP;
			float Y2 = cos (((Ang+ThickP)*3.14159265)/180) * ThickP;

	/*	if (Z > 120.0)
		{
			ThickP += ThickS;
			ThickS -= 0.02;
		}	*/

			float X1T = sin (((Ang+Twist+0.0)*3.14159265)/180) * ThickP;
			float X2T = sin (((Ang+Twist+ThickP)*3.14159265)/180) * ThickP;
			float Y1T = cos (((Ang+Twist+0.0)*3.14159265)/180) * ThickP;
			float Y2T = cos (((Ang+Twist+ThickP)*3.14159265)/180) * ThickP;
	//Odd = 0;

			if (Row == 0 && (Col ^ (Odd >> 1)) == 0)
			{
				glColor3f (1.0, 1.0, 1.0);
			}
			else
			{
				glColor3f (0.0, 0.0, 0.0);
			}
			glVertex3f (X1, Y1, 0.0+Z);
			glVertex3f (X2, Y2, 0.0+Z);
			glVertex3f (X2T, Y2T, Length+Z);
			glVertex3f (X1T, Y1T, Length+Z);
		}
	}
	glEnd ( );

	glPopMatrix ( );

	if (Frame >= 0 && Frame <= (Range - 1))
	{
		IMG Image;
		Image.SizeX = ScreenWidth;
		Image.SizeY = ScreenHeight;
		Image.Size = Image.SizeX * Image.SizeY;
		Image.Data = (PIX_BGRA*) calloc (Image.Size, sizeof (PIX_BGRA));

		glReadPixels (0, 0, ScreenWidth, ScreenHeight, GL_BGRA_EXT, GL_UNSIGNED_BYTE, Image.Data);
		for (int Loc = 0; Loc < Image.Size; Loc++) { Image.Data [Loc].Alpha = 0xFF; }
	/*	for (int Loc = 0; Loc < BG1.Size; Loc++)
		{
			if (Image.Data [Loc].Blue == 0)
			{
				Image.Data [Loc] = BG1.Data [Loc];
			}
			else
			{
				Image.Data [Loc] = BG2.Data [Loc];
			}
		}	*/
		P = snprintf (T,L,"Frame/");
		mkdir (T);
		snprintf (&T[P],L-P,"%0.2d.png", Frame);

		int RetSave = ImageSave (Image, T, "png");
		if (RetSave != ERR_BX_SUCCESS)
		{
			free (Image.Data); Image.Data = NULL;
			switch (RetSave)
			{
				case ERR_BX_FILE: { printf ("Error, could not create the image file\n"); } break;
				case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
				case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
				case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
				case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
				case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
			}
			printf ("Save error...");
			fflush (stdin); getchar ( );;
		}
	}

	// --- Finish ---

	SwapBuffers (hdc);
	glPopMatrix ( );							// restore GL_MODELVIEW's current setting
}

// =============================================================================
// -----------------------------------------------------------------------------
// Window Procedure
// -----------------------------------------------------------------------------

LRESULT CALLBACK WndProc (HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)

{
	switch (msg)
	{
		case WM_CREATE:
		{
			EnableOpenGL (hwnd);
			if (SetTimer (hwnd, 1, ((10*100)/60), NULL) == 0x00)
			{
				MessageBox (hwnd, "Could not set the frame timer", "Error", MB_OK | MB_ICONEXCLAMATION);
			}
		}
		break;
		case WM_TIMER:
		{
			InvalidateRect (hwnd, NULL, TRUE);
		}
		break;
		case WM_KEYDOWN:
		{
			Keys [wParam] = TRUE;
			Keys [wParam+PRESSED] = TRUE;
		}
		break;
		case WM_KEYUP:
		{
			Keys [wParam] = FALSE;
			Keys [wParam+PRESSED] = FALSE;
		}
		break;
		case WM_PAINT:
		{
			DrawGraphics (hwnd);
			ValidateRect (hwnd, NULL);
			for (int Loc = PRESSED; Loc < PRESSED + rangeof (u_char); Loc++)
			{
				Keys [Loc] = FALSE;
			}
		}
		break;
		case WM_CLOSE:
		{
			DisableOpenGL (hwnd);
			DestroyWindow (hwnd);
		}
		break;
		case WM_DESTROY:
		{
			KillTimer (hwnd, 1);
			PostQuitMessage (0x00);
		}
		break;
		default:
		{
			return DefWindowProc (hwnd, msg, wParam, lParam);
		}
		break;
	}
	return 0;
}

// =============================================================================
// -----------------------------------------------------------------------------
// Main Routine
// -----------------------------------------------------------------------------

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)

{
/*	int RetLoad = ImageLoad (BG1, "BG1.png");
	if (RetLoad != ERR_BX_SUCCESS)
	{
		printf ("BG1.png\n");
		switch (RetLoad)
		{
			case ERR_BX_FILE: { printf ("Error, could not open the image file\n"); } break;
			case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
			case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
			case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
			case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
			case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
		}
		fflush (stdin); getchar ( ); return (0);
	}
	RetLoad = ImageLoad (BG2, "BG2.png");
	if (RetLoad != ERR_BX_SUCCESS)
	{
		free (BG1.Data);
		printf ("BG2.png\n");
		switch (RetLoad)
		{
			case ERR_BX_FILE: { printf ("Error, could not open the image file\n"); } break;
			case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
			case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
			case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
			case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
			case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
		}
		fflush (stdin); getchar ( ); return (0);
	}	*/

	WNDCLASSEX wc;
	HWND hwnd = NULL;
	MSG Msg;
	wc.cbSize		= sizeof (WNDCLASSEX);
	wc.style		= 0;
	wc.lpfnWndProc		= WndProc;
	wc.cbClsExtra		= 0;
	wc.cbWndExtra		= 0;
	wc.hInstance		= hInstance;
	wc.hIcon		= NULL;
	wc.hCursor		= LoadCursor (NULL, IDC_ARROW);
	wc.hbrBackground	= (HBRUSH) (COLOR_WINDOW+1);
	wc.lpszMenuName		= NULL;
	wc.lpszClassName	= ProgWinClass;
	wc.hIconSm		= NULL;

	if (!RegisterClassEx (&wc))
	{
		MessageBox (NULL, "Window Registration Failed", "Error", MB_ICONEXCLAMATION | MB_OK);
		return (0x00);
	}

	AdjustWindowRect (&RectWindow, WindowStyles, FALSE);
	hwnd = CreateWindow (ProgWinClass, ProgName, WindowStyles, CW_USEDEFAULT, CW_USEDEFAULT, RectWindow.right - RectWindow.left, RectWindow.bottom - RectWindow.top, NULL, NULL, hInstance, NULL);

	if (hwnd == NULL)
	{
		MessageBox (NULL, "Window Creation Failed", "Error", MB_ICONEXCLAMATION | MB_OK);
		return (0x00);
	}

	ShowWindow (hwnd, nCmdShow);
	UpdateWindow (hwnd);

	while (GetMessage (&Msg, NULL, 0, 0) > 0)
	{
		TranslateMessage (&Msg);
		DispatchMessage (&Msg);
	}

//	free (BG1.Data);
//	free (BG2.Data);
	return Msg.wParam;
}

// =============================================================================
