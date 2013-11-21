//
//  NGLSViewController.h
//  Turistiando
//
//  Created by Juan Camilo Ortiz Román on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#ifndef Turistiando_NGLSViewController_h
#define Turistiando_NGLSViewController_h



#endif

#import <UIKit/UIKit.h>
#import <QCAR/Tool.h>

#import <NinevehGL/NGLMesh.h>
#import <NinevehGL/NGLView.h>

// Application status
typedef enum _status {
    APPSTATUS_UNINITED,
    APPSTATUS_INIT_APP,
    APPSTATUS_INIT_QCAR,
	APPSTATUS_INIT_TRACKER,
    APPSTATUS_INIT_APP_AR,
    APPSTATUS_LOAD_TRACKER,
    APPSTATUS_INITED,
    APPSTATUS_CAMERA_STOPPED,
    APPSTATUS_CAMERA_RUNNING,
    APPSTATUS_ERROR
} status;

@interface NGLSViewController : UIViewController <NGLViewDelegate, NGLMeshDelegate>
{
@private
	NGLMesh *_dragon, *_mountain;
	NGLCamera *_camera;
	
	UIProgressView *_progress;
	UIImageView *_instructions;
	
	BOOL _isReady;
	
	// OpenGL projection matrix
    QCAR::Matrix44F projectionMatrix;
    
    struct tagARData {
        CGRect screenRect;
        int QCARFlags;              // QCAR initialisation flags
        status appStatus;           // Current app status
    } ARData;
}

@end
