

#include "ofxIOSurfaceTest.h"


ofxIOSurfaceTest::ofxIOSurfaceTest(){
	movieController = [[IOSurfaceMovieController alloc] init];
}

ofxIOSurfaceTest::~ofxIOSurfaceTest(){
    [movieController release];
}

void ofxIOSurfaceTest::playMovie(string path){
//    NSAutoreleasePool* p;
    NSString* moviePath = [NSString stringWithCString:ofToDataPath(path).c_str()
                                             encoding:NSUTF8StringEncoding];
	[movieController play:moviePath];
    
//    [p release];
}

void ofxIOSurfaceTest::draw(){
    [movieController draw];
}