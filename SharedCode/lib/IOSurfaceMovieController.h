//
//  IOSurfaceMovieController.h
//  emptyExample
//
//  Created by James George on 7/26/12.
//  Copyright (c) 2012 FlightPhase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <IOSurface/IOSurface.h>

#import "TaskWrapper.h"

@interface IOSurfaceMovieController : NSObject<TaskWrapperController>
{
    TaskWrapper* moviePlayer;
    BOOL moviePlaying;

	NSString *inputRemainder;
    NSInteger			numFrames;
	NSTimer				*frameCounterTimer;

    GLuint			_surfaceTexture;
	IOSurfaceRef	_surface;
	GLsizei			_texWidth;
	GLsizei			_texHeight;
	uint32_t		_seed;

}

@property(nonatomic, readonly) BOOL moviePlaying;
@property(nonatomic, retain) TaskWrapper* moviePlayer;

- (void) play:(NSString*) moviePath;

- (void)appendOutput:(NSString *)output fromProcess: (TaskWrapper *)aTask;
- (void)processStarted: (TaskWrapper *)aTask;
- (void)processFinished: (TaskWrapper *)aTask withStatus: (int)statusCode;

- (void)setSurfaceID:(IOSurfaceID)anID;
- (void)_bindSurfaceToTexture: (IOSurfaceRef)aSurface;

- (void) draw;

@end
