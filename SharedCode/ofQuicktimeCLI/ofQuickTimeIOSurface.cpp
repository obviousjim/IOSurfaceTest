
#include "ofQuickTimeIOSurface.h"
#include "ofQuickTimeGrabber.h"
//#include "ofQuickTimePlayer.h"

ofQuicktimeIOSurface::ofQuicktimeIOSurface(){
	useGrabber = false;
//    player = NULL;
    grabber = NULL;
    
}

ofQuicktimeIOSurface::~ofQuicktimeIOSurface(){
    
}

void ofQuicktimeIOSurface::showSettingsTest(){
	grabber->videoSettings();    
}


void ofQuicktimeIOSurface::setupMoviePlayer(std::string path){
    useGrabber = false;
//    player = new ofQuickTimePlayer();
//    player->loadMovie(path);
}

bool ofQuicktimeIOSurface::setupVideoGrabber(int deviceId){
	useGrabber = true;
    grabber = new ofQuickTimeGrabber();
    grabber->setDeviceID(0);
    return grabber->initGrabber(640, 480);
}

void ofQuicktimeIOSurface::update(){
    if(useGrabber){
        grabber->update();
    }
}

IOSurfaceRef ofQuicktimeIOSurface::getCurrentSurface(){
    return 0;
}

IOSurfaceID ofQuicktimeIOSurface::getCurrentSurfaceID(){
    if(useGrabber){
        return grabber->getCurrentSurfaceID();
    }
    else return -2;
}

bool ofQuicktimeIOSurface::isFrameNew(){
    return useGrabber ? grabber->isFrameNew() : false;
}
