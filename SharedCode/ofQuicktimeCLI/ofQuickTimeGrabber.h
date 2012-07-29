#pragma once

//#include "ofConstants.h"
#include <QuickTime/QuickTime.h>
#include <CoreVideo/CoreVideo.h>

#include <string>
#define TARGET_OSX
#define OF_VIDEO_CAPTURE_QUICKTIME

#ifndef TARGET_LINUX
	#include "ofQtUtils.h"
//	#include "ofTexture.h"
//	#include "ofBaseTypes.h"
//	#include "ofPixels.h"

// todo:
// 		QT - callback, via SGSetDataProc - couldn't get this to work yet
// 		image decompress options ala mung...

using namespace std;
class ofQuickTimeGrabber {

	public :

		ofQuickTimeGrabber();
		virtual ~ofQuickTimeGrabber();

		void					listDevices();
		bool					initGrabber(int w, int h);
		void					update();
		bool					isFrameNew();
	    IOSurfaceID 			getCurrentSurfaceID();

		unsigned char			* getPixels();
//		ofPixelsRef		 		getPixelsRef();
		void					close();
		void					clearMemory();

		void					videoSettings();
		
		float					getWidth();
		float					getHeight();

		void					setVerbose(bool bTalkToMe);
		void					setDeviceID(int _deviceID);
		void					setDesiredFrameRate(int framerate);

	protected:

		bool					bChooseDevice;
		int						deviceID;
		bool 					bVerbose;
		bool 					bGrabberInited;
	    CVPixelBufferRef		pixelBuf;

//	    ofPixels				pixels;
        unsigned char*			pixels;
		int						attemptFramerate;
		bool 					bIsFrameNew;	
		
		//int						width, height;

		unsigned char *			offscreenGWorldPixels;	// 32 bit: argb (qt k32ARGBPixelFormat)
		//int						w,h;
		bool					bHavePixelsChanged;
		GWorldPtr				videogworld;
		SeqGrabComponent		gSeqGrabber;
		SGChannel				gVideoChannel;
		Rect					videoRect;
		bool					bSgInited;
	    std::string				deviceName;
		SGGrabCompleteBottleUPP	myGrabCompleteProc;
		
		bool					qtInitSeqGrabber();
		bool					qtCloseSeqGrabber();
		bool					qtSelectDevice(int deviceNumber, bool didWeChooseADevice);

		bool					saveSettings();
		bool					loadSettings();
		

};


#endif
