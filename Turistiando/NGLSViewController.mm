/*
 *	NGLSViewController.m
 *	Augmented Reality
 *
 *	Created by Diney Bomfim on 2/7/12.
 *	Copyright 2012 DB-Interactive. All rights reserved.
 */

#import "NGLSViewController.h"
#import <NinevehGL/NGLGlobal.h>
#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Trackable.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ImageTracker.h>
#import <QCAR/DataSet.h>

#pragma mark -
#pragma mark Constants
#pragma mark -
//**********************************************************************************************************
//
//	Constants
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Private Interface
#pragma mark -
//**********************************************************************************************************
//
//	Private Interface
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Private Category
//**************************************************
//	Private Category
//**************************************************

@interface NGLSViewController()

- (void)updateApplicationStatus:(status)newStatus;
- (void)bumpAppStatus;
- (void)initApplication;
- (void)initQCAR;
- (void)initApplicationAR;
- (void)loadTracker;
- (void)startCamera;
- (void)stopCamera;
- (void)configureVideoBackground;

@end

#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**********************************************************************************************************
//
//	Public Interface
//
//**********************************************************************************************************

@implementation NGLSViewController

#pragma mark -
#pragma mark Properties
//**************************************************
//	Properties
//**************************************************

#pragma mark -
#pragma mark Constructors
//**************************************************
//	Constructors
//**************************************************

#pragma mark -
#pragma mark Private Methods
//**************************************************
//	Private Methods
//**************************************************

// Update the application status
- (void) updateApplicationStatus:(status)newStatus
{
    if (newStatus != ARData.appStatus && APPSTATUS_ERROR != ARData.appStatus)
	{
        ARData.appStatus = newStatus;
        
        switch (ARData.appStatus)
		{
            case APPSTATUS_INIT_APP:
                // Initialise the application
                [self initApplication];
                [self updateApplicationStatus:APPSTATUS_INIT_QCAR];
                break;
                
            case APPSTATUS_INIT_QCAR:
                // Initialise QCAR
                [self performSelectorInBackground:@selector(initQCAR) withObject:nil];
                break;
				
			case APPSTATUS_INIT_TRACKER:
                // Initialise the tracker
                if ([self initTracker] > 0)
				{
                    [self updateApplicationStatus: APPSTATUS_INIT_APP_AR];
                }
                break;
                
            case APPSTATUS_INIT_APP_AR:
                // AR-specific initialisation
                [self initApplicationAR];
                [self updateApplicationStatus:APPSTATUS_LOAD_TRACKER];
                break;
                
            case APPSTATUS_LOAD_TRACKER:
                // Load tracker data
                [self performSelectorInBackground:@selector(loadTracker) withObject:nil];
                break;
                
            case APPSTATUS_INITED:
                // These two calls to setHint tell QCAR to split work over multiple
                // frames.  Depending on your requirements you can opt to omit these.
                QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
                QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
                // Here we could also make a QCAR::setHint call to set the maximum
                // number of simultaneous targets
                // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
                [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
                break;
                
            case APPSTATUS_CAMERA_RUNNING:
                [self startCamera];
                break;
                
            case APPSTATUS_CAMERA_STOPPED:
                [self stopCamera];
                break;
                
            default:
                break;
        }
    }
    
    if (APPSTATUS_ERROR == ARData.appStatus)
	{
        // Application initialisation failed, display an alert view
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Application initialisation failed."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
}

// Bump the application status on one step
- (void) bumpAppStatus
{
    [self updateApplicationStatus:(status)(ARData.appStatus + 1)];
}

// Initialise the application
- (void) initApplication
{
    // Get the device screen dimensions
    ARData.screenRect = [[UIScreen mainScreen] bounds];
    
    // Inform QCAR that the drawing surface has been created
    QCAR::onSurfaceCreated();
    
    // Inform QCAR that the drawing surface size has changed
    QCAR::onSurfaceChanged(ARData.screenRect.size.height, ARData.screenRect.size.width);
}

// Initialise QCAR [performed on a background thread]
- (void) initQCAR
{
    // Background thread must have its own autorelease pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    QCAR::setInitParameters(ARData.QCARFlags);
    
    int nPercentComplete = 0;
    
    do {
        nPercentComplete = QCAR::init();
    } while (0 <= nPercentComplete && 100 > nPercentComplete);
    
    if (0 > nPercentComplete)
	{
        ARData.appStatus = APPSTATUS_ERROR;
    }
    
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
    [pool release];
}

// Initialise the tracker [performed on a background thread]
- (int) initTracker
{
    int res = 0;
    
    // Initialize the image or marker tracker.
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
	QCAR::Tracker* trackerBase = trackerManager.initTracker(QCAR::Tracker::IMAGE_TRACKER);
	
	res = (trackerBase != NULL);
    
    return res;
}

// Initialise the AR parts of the application
- (void) initApplicationAR
{
    glClearColor(0.0f, 0.0f, 0.0f, QCAR::requiresAlpha() ? 0.0f : 1.0f);
}

// Load the tracker data [performed on a background thread]
- (void) loadTracker
{
    // Background thread must have its own autorelease pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
	//
    //DataSetItem *dataSet;
	QCAR::DataSet *dataSet = nil;
	QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::Tracker::IMAGE_TRACKER));
    
	dataSet = imageTracker->createDataSet();
    dataSet->load([@"NGLAR.xml" cStringUsingEncoding:NSASCIIStringEncoding], QCAR::DataSet::STORAGE_APPRESOURCE);
	imageTracker->activateDataSet(dataSet);
	
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
    [pool release];
}

// Start capturing images from the camera
- (void) startCamera
{
    // Initialise the camera
    if (QCAR::CameraDevice::getInstance().init())
	{
        // Configure video background
        [self configureVideoBackground];
        
        // Select the default mode
        //if (QCAR::CameraDevice::getInstance().selectVideoMode(QCAR::CameraDevice::MODE_DEFAULT))
		
		// Start camera capturing
		if (QCAR::CameraDevice::getInstance().start())
		{
			// Start the tracker.
			QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
			QCAR::Tracker* imageTracker = trackerManager.getTracker(QCAR::Tracker::IMAGE_TRACKER);
			imageTracker->start();
			
			// Cache the projection matrix
			const QCAR::CameraCalibration &camera = QCAR::CameraDevice::getInstance().getCameraCalibration();
			projectionMatrix = QCAR::Tool::getProjectionGL(camera, 2.0f, 2000.0f);
		}
    }
	
	_isReady = YES;
}

// Stop capturing images from the camera
- (void) stopCamera
{
	QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
	QCAR::Tracker* imageTracker = trackerManager.getTracker(QCAR::Tracker::IMAGE_TRACKER);
	//imageTracker->stop();
	
    QCAR::CameraDevice::getInstance().deinit();
}

// Configure the video background
- (void) configureVideoBackground
{
	CGSize size = self.view.bounds.size;
	
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mSynchronous = true;
    
	// Defines the video frame.
	config.mSize.data[0] = size.width;
	config.mSize.data[1] = size.height;
    config.mPosition.data[0] = config.mSize.data[0] * 0.5f;
    config.mPosition.data[1] = config.mSize.data[1] * 0.5f;
	
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}

#pragma mark -
#pragma mark Self Public Methods
//**************************************************
//	Self Public Methods
//**************************************************

- (void) drawView
{
	static float angle = 0;
	
	if (_isReady)
	{
		_dragon.visible = NO;
		_mountain.visible = NO;
		
		// Render video background and retrieve tracking state
		QCAR::State state = QCAR::Renderer::getInstance().begin();
		QCAR::Renderer::getInstance().drawVideoBackground();
		
		for (int i = 0; i < state.getNumActiveTrackables(); ++i)
		{
			// Get the trackable
			const QCAR::Trackable *trackable = state.getActiveTrackable(i);
			QCAR::Matrix44F qMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
			
			if (!strcmp(trackable->getName(), "dragon"))
			{
				// Making the meshes visible again.
				_dragon.visible = YES;
				_mountain.visible = YES;
				
				// Moving the dragon into a circle above the mountain.
				_dragon.x = cosf(angle * .02);
				_dragon.z = sinf(angle * .02) - 1.0;
				[_dragon lookAtPointX:0.0 toY:0.0 toZ:-1.0];
				++angle;
				
				// Rebasing the meshes. The NinevehGL rebase is the key feature to work with AR engines and
				// keep your meshes responsiveness to NinevehGL transformations.
				// The scale property must be the same as that one defined in Qualcomm "config.xml" file,
				// the first value of the "size" property.
				// Remove a '/' from the following line to see the results when rebasing the camera.
				//*
				[_dragon rebaseWithMatrix:qMatrix.data scale:247.0f compatibility:NGLRebaseQualcommAR];
				[_mountain rebaseWithMatrix:qMatrix.data scale:247.0f compatibility:NGLRebaseQualcommAR];
				/*/
                 // Rebase the camera has the same effect as objects, however you can't rebase a mesh and
                 // a camera at the same time. Choose one of these ways.
                 [_camera rebaseWithMatrix:qMatrix.data size:247.0f compatibility:NGLRebaseQualcommAR];
                 //*/
			}
		}
		
		QCAR::Renderer::getInstance().end();
		
		// Qualcomm disables the depth test internally, so we must enable it again.
		glEnable(GL_DEPTH_TEST);
		
		[_camera drawCamera];
	}
}

#pragma mark -
#pragma mark NGLMeshDelegate
- (void) meshLoadingWillStart:(NGLParsing)parsing
{
	CGSize size = self.view.bounds.size;
	
	// Placing the load bar on the screen.
	nglRelease(_progress);
	_progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	_progress.frame = CGRectMake(20, size.height * 0.5f, size.width - 40, 20);
	
	[self.view addSubview:_progress];
}

- (void) meshLoadingProgress:(NGLParsing)parsing
{
	// Updates the load bar.
	_progress.progress = parsing.progress;
}

- (void) meshLoadingDidFinish:(NGLParsing)parsing
{
	// Removes the load bar from the screen.
	_progress.progress = parsing.progress;
	[_progress removeFromSuperview];
}

#pragma mark -
#pragma mark Override Public Methods
//**************************************************
//	Override Public Methods
//**************************************************

- (void) loadView
{
	// Following the UIKit specifications, this method should not call the super.
	
	//*************************
	//	NinevehGL Stuff
	//*************************
	// Removes the light effects.
	//nglGlobalLightEffects(NGLLightEffects);
	
	// Creates the NGLView manually (without XIB), with the screen's size and sets its delegate.
	NGLView *nglView = [[NGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	nglView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	nglView.delegate = self;
	
	// Sets the NGLView as the root view of this View Controller hierarchy.
	self.view = nglView;
	
	[nglView release];
	
	//*************************
	//	Qualcomm Stuff
	//*************************
	// Starts Qualcomm AR.
	ARData.QCARFlags = QCAR::GL_20;
    ARData.appStatus = APPSTATUS_UNINITED;
	[self updateApplicationStatus:APPSTATUS_INIT_APP];
}

- (void) viewDidLoad
{
	// Must call super to agree with the UIKit rules.
	[super viewDidLoad];
	
	// Loading the dragon.
	NSDictionary *settings;
	settings = [NSDictionary dictionaryWithObjectsAndKeys:
				kNGLMeshCentralizeYes, kNGLMeshKeyCentralize,
				@"1.0", kNGLMeshKeyNormalize,
				nil];
	_dragon = [[NGLMesh alloc] initWithFile:@"Red Dragon.dae" settings:settings delegate:nil];
	
	// Loading the mountain.
	settings = [NSDictionary dictionaryWithObjectsAndKeys:
				kNGLMeshCentralizeYes, kNGLMeshKeyCentralize,
				@"3.0", kNGLMeshKeyNormalize,
				nil];
	_mountain = [[NGLMesh alloc] initWithFile:@"majestic mountain.obj" settings:settings delegate:self];
	_mountain.y = -0.5f;
	_mountain.z = -1.0f;
	
	// Initializing the camera.
	_camera = [[NGLCamera alloc] initWithMeshes:_dragon, _mountain, nil];
	
	// Starts the debug monitor.
	//[[NGLDebug debugMonitor] startWithView:(NGLView *)self.view];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	_instructions = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Instructions.png"]];
	[self.view addSubview:_instructions];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Super call, must be called if we have no plans to override all touch methods, it's an UIKit rule.
	[super touchesBegan:touches withEvent:event];
	
	if (_instructions)
	{
		[_instructions removeFromSuperview];
		[_instructions release];
		_instructions = nil;
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	// Allows the application to start only in landscape right orientation
	if (UIInterfaceOrientationLandscapeRight == toInterfaceOrientation)
	{
		[_camera adjustAspectRatioAnimated:NO];
		return YES;
	}
	
	return NO;
}

- (void) dealloc
{
	// Deinitialise QCAR SDK
	[self updateApplicationStatus:APPSTATUS_CAMERA_STOPPED];
    QCAR::deinit();
	
	[_dragon release];
	[_mountain release];
	[_camera release];
	
	[super dealloc];
}

@end