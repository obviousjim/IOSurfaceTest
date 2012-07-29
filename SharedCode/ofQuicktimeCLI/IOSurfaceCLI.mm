/*
 *  IOSurfaceCLI.m
 *  IOSurfaceCLI
 *
 *  Created by Paolo on 21/09/2009.
 *
 * Copyright (c) 2009 Paolo Manna
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, this list of
 *   conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list of
 *   conditions and the following disclaimer in the documentation and/or other materials
 *   provided with the distribution.
 * - Neither the name of the Author nor the names of its contributors may be used to
 *   endorse or promote products derived from this software without specific prior written
 *   permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


#import <Foundation/Foundation.h>

//#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreVideo/CoreVideo.h>

// For OSAtomic operations
#import <libkern/OSAtomic.h>

//#import "MovieRenderer.h"
#import <mach/mach.h>

#include "ofQuickTimeIOSurface.h"


@interface RenderTimerDelegate : NSObject {
	NSFileHandle	*standardOut;
	id				currentFrame;
	NSTimeInterval	timing;
    ofQuicktimeIOSurface* surfaceHandler;
    BOOL openedDialog;
}

- (void)update: (NSTimer *)aTimer;

@property(nonatomic, retain) NSFileHandle* standardOut;
@property(nonatomic, readwrite) ofQuicktimeIOSurface* surfaceHandler;

@end

@implementation RenderTimerDelegate

@synthesize standardOut;
@synthesize surfaceHandler;

- (id)init
{
	if (self = [super init]) {
		self.standardOut = [NSFileHandle fileHandleWithStandardOutput];
		timing		= 0.0;
        surfaceHandler = new ofQuicktimeIOSurface(); 
        openedDialog = NO;
        //usePlayer = false;
        //        player = NULL;
        //        grabber = NULL;
	}
	return self;
}



/*
 - (void)setPlayer: (ofQuickTimePlayer*) aPlayer
 {
 player = aPlayer;
 usePlayer = true;
 
 }
 
 - (void)setGrabber: (ofQuickTimeGrabber*) aGrabber
 {
 grabber = aGrabber;
 usePlayer = false;
 }
 */

//- (void)dealloc
//{
//    self.standardOut = nil;
//	//[super dealloc];
//    
//}

- (void)update: (NSTimer *)aTimer
{
    surfaceHandler->update();
    if(surfaceHandler->isFrameNew()){
        char		cmdStr[256];
        
//#if COREVIDEO_SUPPORTS_IOSURFACE
        sprintf(cmdStr, "ID#%lu#\n", (unsigned long)surfaceHandler->getCurrentSurfaceID());
//#else
//        sprintf(cmdStr, "F#%lu#\n", (unsigned long)[theMovie currentFrame]);
//#endif
        [standardOut writeData: [NSData dataWithBytesNoCopy: cmdStr
                                                     length: strlen(cmdStr)
                                               freeWhenDone: NO]];
        
//        currentFrame	= newFrame;
//        NSLog(@"new frame 
    }
    
    timing	+= [aTimer timeInterval];
    if(!openedDialog && timing > 2){
//        NSLog(@"showing settings fool");
        surfaceHandler->showSettingsTest();
        openedDialog = YES;
    }
    /*
     MovieRenderer	*theMovie	= [aTimer userInfo];
     id				newFrame	= [theMovie getFrameAtTime: timing];
     
     if (newFrame) {
     if (newFrame != currentFrame) {
     char		cmdStr[256];
     
     #if COREVIDEO_SUPPORTS_IOSURFACE
     sprintf(cmdStr, "ID#%lu#\n", (unsigned long)[theMovie currentSurfaceID]);
     #else
     sprintf(cmdStr, "F#%lu#\n", (unsigned long)[theMovie currentFrame]);
     #endif
     [standardOut writeData: [NSData dataWithBytesNoCopy: cmdStr
     length: strlen(cmdStr)
     freeWhenDone: NO]];
     
     currentFrame	= newFrame;
     }
     
     timing	+= [aTimer timeInterval];
     }\*/
}

@end

int main (int argc, const char * argv[])
{
    
    NSAutoreleasePool	*pool			= [[NSAutoreleasePool alloc] init];
	int					ch;
	BOOL				globalFlag		= NO;
	BOOL				useInputDevice	= NO;
	NSTimeInterval		timerStep		= -1.0;
	
    NSLog(@"------------ CLI RUNNING");
	while ((ch = getopt(argc, (char * const *)argv, "gliad:r:")) != -1) {
        
		switch (ch) {
			case 'g':
				globalFlag	= YES;	// IOSurfaces will be global, unused for now
				break;
//			case 'l':				// Lists input devices
//				{
//					NSArray			*inputDevices	= [QTCaptureDevice inputDevicesWithMediaType: QTMediaTypeVideo];
//					NSEnumerator	*enumDevs		= [inputDevices objectEnumerator];
//					QTCaptureDevice	*aDevice;
//					
//					while ((aDevice = [enumDevs nextObject]) != nil) {
//						NSString		*deviceName	= [NSString stringWithFormat: @"\"%@\" ID: <%@>\n",
//																				[aDevice localizedDisplayName],
//																				[aDevice uniqueID]];
//						NSFileHandle	*sOut	= (NSFileHandle *)[NSFileHandle fileHandleWithStandardOutput];
//						
//						[sOut writeData: [deviceName dataUsingEncoding: NSUTF8StringEncoding]];
//					}
//				}
//				break;
//			case 'd':				// Sets audio delay
//				[MovieRenderer setAudioDelay: atof(optarg)];
//				break;
//			case 'r':				// Sets video frame rate
//				timerStep	= 1.0 / atof(optarg);
//				break;
//			case 'a':				// Sets alpha usage
//				[MovieRenderer setAlphaSurface: YES];
//				break;
			case 'p':				// Use input devices in place of a file
				useInputDevice	= YES;
				break;    			
		}
	}
	
	argc -= optind;
	argv += optind;
	
	if (useInputDevice || (argc >= 1)) {
//		NSString *moviePath	= nil;
		RenderTimerDelegate	*timerDelegate	= [[RenderTimerDelegate alloc] init];
		//MovieRenderer	*theMovie	= nil;
//		if (argv[0]){
//			moviePath	= [NSString stringWithUTF8String: argv[0]];
        bool loaded = true;
		if (true || useInputDevice) {
            loaded = timerDelegate.surfaceHandler->setupVideoGrabber(0);
            //TODO: find a way to change device id
            
//			theMovie	= [(MovieRenderer *)[MovieRenderer alloc] initWithDevice: moviePath];
//		} else if ([[NSFileManager defaultManager] fileExistsAtPath: moviePath]) {
//			theMovie	= [(MovieRenderer *)[MovieRenderer alloc] initWithPath: moviePath];
//		}
        }
//        ofQuickTimePlayer player;
//        bool loaded = argv[0] && player.loadMovie(argv[0]);
        timerStep = 1/60.;
         

		if (loaded) {
//            [movieTest setPlayer: &player];

//			if (timerStep < 0.0)
//				timerStep	= [theMovie timerStep];
            
			[NSTimer scheduledTimerWithTimeInterval: timerStep
											 target: timerDelegate
										   selector: @selector(update:)
										   userInfo: nil
											repeats: YES];
			
			// Ensures play will start at next runloop turn
			//[theMovie performSelector: @selector(startPlay) withObject: nil afterDelay: 0];
            //player.play();
			
			[[NSRunLoop currentRunLoop] run];
		}

	}
	
    [pool drain];

    return 0;
}
