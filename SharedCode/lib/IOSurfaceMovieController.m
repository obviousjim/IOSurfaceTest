//
//  IOSurfaceMovieController.m
//  emptyExample
//
//  Created by James George on 7/26/12.
//  Copyright (c) 2012 FlightPhase. All rights reserved.
//

#import "IOSurfaceMovieController.h"

@implementation IOSurfaceMovieController

@synthesize moviePlaying;
@synthesize moviePlayer;

- (id) init
{
    self = [super init];
    if(self){
//        CGLContextObj   cgl_ctx			= CGLGetCurrentContext();
//        long			swapInterval	= 1;
//        
//        [[self openGLContext] setValues:(GLint*)(&swapInterval)
//                           forParameter: NSOpenGLCPSwapInterval];
        glEnable(GL_TEXTURE_RECTANGLE_ARB);
        glGenTextures(1, &_surfaceTexture);
        glDisable(GL_TEXTURE_RECTANGLE_ARB);    
    }
    return self;
}

- (void) play:(NSString*) moviePath
{
    
    if (moviePlaying) {
        [moviePlayer stopProcess];
        
    } else {
        
        NSString	*cliPath	= [[NSBundle mainBundle] pathForResource: @"ofQuicktimeCLI" 
//         NSString	*cliPath	= [[NSBundle mainBundle] pathForResource: @"IOSurfaceCLI" 
                                                            ofType: @""];
        NSArray		*args;
        //		if (self.moviePath && [self.moviePath length] > 1) {
        
        args		= [NSArray arrayWithObjects: cliPath, @"-g", moviePath, nil];
        //			args		= [NSArray arrayWithObjects: cliPath, @"-g", @"-d", @"1.0", self.moviePath, nil];
        //		} else {
        //			args		= [NSArray arrayWithObjects: cliPath, @"-g", @"-i", nil];
        //		}
        self.moviePlayer = [[TaskWrapper alloc] initWithController: self arguments: args userInfo: nil];
        if (self.moviePlayer != nil){
            NSLog(@"Starting process");
            [moviePlayer startProcess];
        }
        else {
            NSLog(@"Can't launch %@!", cliPath);
        }

        //		[sender setTitle: @"Stop"];
    }
}

- (void)appendOutput:(NSString *)output fromProcess: (TaskWrapper *)aTask
{
	if (!inputRemainder)
		inputRemainder	= [[NSString alloc] initWithString:@""];
	
	NSArray			*outComps	= [[inputRemainder stringByAppendingString: output] componentsSeparatedByString: @"\n"];
	NSEnumerator	*enumCmds	= [outComps objectEnumerator];
	NSString		*cmdStr;
	
	while ((cmdStr = [enumCmds nextObject]) != nil) {
		if (([cmdStr length] > 3) && [[cmdStr substringToIndex: 3] isEqualToString: @"ID#"]) {
			long			surfaceID	= 0;
			
			sscanf([cmdStr UTF8String], "ID#%ld#", &surfaceID);
			if (surfaceID) {
                [self setSurfaceID:surfaceID];
//				[view setSurfaceID: surfaceID];
//				[view setNeedsDisplay: YES];
				numFrames++;
			}
		}
	}
	
	cmdStr	= [outComps lastObject];
	if (([cmdStr length] > 0) && ([cmdStr characterAtIndex: [cmdStr length] - 1] != '#')) {
		NSLog(@"Storing %@ for later concat", cmdStr);
		[inputRemainder release];
		inputRemainder	= [cmdStr retain];
	}

}

- (void)processStarted: (TaskWrapper *)aTask
{
	moviePlaying	= YES;    
}

- (void)processFinished: (TaskWrapper *)aTask withStatus: (int)statusCode
{
    moviePlaying	= NO;
	
	self.moviePlayer		= nil;
}


- (void)setSurfaceID: (IOSurfaceID)anID
{
	if (anID) {
		[self _bindSurfaceToTexture: IOSurfaceLookup(anID)];
	}
}

- (void)_bindSurfaceToTexture: (IOSurfaceRef)aSurface
{
    
	if (_surface && (_surface != aSurface)) {
		CFRelease(_surface);
	}
	
	if ((_surface = aSurface) != nil) {
		//CGLContextObj   cgl_ctx = [[self openGLContext]  CGLContextObj];
        CGLContextObj cgl_ctx = CGLGetCurrentContext();
		
		_texWidth	= IOSurfaceGetWidth(_surface);
		_texHeight	= IOSurfaceGetHeight(_surface);
		
		glEnable(GL_TEXTURE_RECTANGLE_ARB);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, _surfaceTexture);
//		CGLTexImageIOSurface2D(cgl_ctx, GL_TEXTURE_RECTANGLE_ARB, GL_RGB8,
//							   _texWidth, _texHeight,
//							   GL_YCBCR_422_APPLE, GL_UNSIGNED_SHORT_8_8_APPLE, _surface, 0);
		CGLTexImageIOSurface2D(cgl_ctx, GL_TEXTURE_RECTANGLE_ARB, GL_RGBA8,
							   _texWidth, _texHeight,
							   GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, _surface, 0);

		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, 0);
		glDisable(GL_TEXTURE_RECTANGLE_ARB);
	}
}

- (void) draw
{
 	CGLContextObj   cgl_ctx		= CGLGetCurrentContext();

	//Clear background
//	glClearColor(0.0, 0.0, 0.0, 0.0);
//	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	if (_surface) {
        /*
		GLfloat		texMatrix[16]	= {0};
		GLint		saveMatrixMode;
		
        NSLog(@"Surface Works %d x %d", _texWidth, _texHeight);
    
        
		// Reverses and normalizes the texture
		texMatrix[0]	= (GLfloat)_texWidth;
		texMatrix[5]	= -(GLfloat)_texHeight;
		texMatrix[10]	= 1.0;
		texMatrix[13]	= (GLfloat)_texHeight;
		texMatrix[15]	= 1.0;

		glGetIntegerv(GL_MATRIX_MODE, &saveMatrixMode);
		glMatrixMode(GL_TEXTURE);
		glPushMatrix();
		glLoadMatrixf(texMatrix);
		glMatrixMode(saveMatrixMode);
		*/
        
		glEnable(GL_TEXTURE_RECTANGLE_ARB);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, _surfaceTexture);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	} else {
		glColor4f(0.4, 0.4, 0.4, 0.4);
    
	}
	
	//Draw textured quad
//	glBegin(GL_QUADS);
//    glTexCoord2f(0.0, 0.0);
//    glVertex3f(-1.0, -1.0, 0.0);
//    glTexCoord2f(1.0, 0.0);
//    glVertex3f(1.0, -1.0, 0.0);
//    glTexCoord2f(1.0, 1.0);
//    glVertex3f(1.0, 1.0, 0.0);
//    glTexCoord2f(0.0, 1.0);
//    glVertex3f(-1.0, 1.0, 0.0);
//	glEnd();

	glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    
    glTexCoord2f(_texWidth, 0.0);
    //glTexCoord2f(1.0, 0.0);
    glVertex3f(_texWidth, 0.0, 0.0);
    
    glTexCoord2f(_texWidth, _texHeight);
    //glTexCoord2f(1.0, 1.0);
    glVertex3f(_texWidth, _texHeight, 0.0);
    
    glTexCoord2f(0.0, _texHeight);
    //glTexCoord2f(0.0, 1.0);
    glVertex3f(0.0, _texHeight, 0.0);
	glEnd();

	//Restore texturing settings
	if (_surface) {
//		GLint		saveMatrixMode;
		
		glDisable(GL_TEXTURE_RECTANGLE_ARB);
		
//		glGetIntegerv(GL_MATRIX_MODE, &saveMatrixMode);
//		glMatrixMode(GL_TEXTURE);
//		glPopMatrix();
//		glMatrixMode(saveMatrixMode);
	}
	//CGLFlushDrawable(CGLGetCurrentContext());
    
	//[[self openGLContext] flushBuffer];    
}

@end
