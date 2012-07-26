
#pragma once

#include "ofMain.h"

#ifdef __OBJC__
#import "IOSurfaceMovieController.h"
#endif

class ofxIOSurfaceTest {
  public:
    ofxIOSurfaceTest();
    ~ofxIOSurfaceTest();
    
    void playMovie(string path);
    void draw();
    
    
  protected:
	
	#ifdef __OBJC__
	IOSurfaceMovieController* movieController;	
	#else
    void* movieController;
	#endif
    
};