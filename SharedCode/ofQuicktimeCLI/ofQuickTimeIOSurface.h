#pragma once

#include <string>
#include <iostream>
#include <vector>
#include <cstring>

using namespace std;
#import <IOSurface/IOSurface.h>

class ofQuickTimeGrabber;
//class ofQuickTimePlayer;

class ofQuicktimeIOSurface {
  public:
    ofQuicktimeIOSurface();
    ~ofQuicktimeIOSurface();
    
    void showSettingsTest();
    void setupMoviePlayer(std::string path);
    bool setupVideoGrabber(int deviceId);
    void update();
    bool isFrameNew();
    
    IOSurfaceRef getCurrentSurface();
    IOSurfaceID getCurrentSurfaceID();
    
  protected:
	bool useGrabber;
//    ofQuickTimePlayer* player;
    ofQuickTimeGrabber* grabber;
    
};