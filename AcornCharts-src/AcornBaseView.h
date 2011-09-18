//
//  AcornBaseView.h
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 Muh Hon Cheng. All rights reserved.
//

#import "chipmunk.h"
#import <CoreMotion/CoreMotion.h>

@interface AcornBaseViewRenderer : NSObject
@end

@interface AcornPointObject : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) float value, percentage;
@property (nonatomic, retain) UIColor *color;
@end

@interface AcornBaseView : UIView
{
	cpSpace *_space;
}

@property (nonatomic, retain) CMMotionManager *_motionManager;
@property (nonatomic, retain) NSTimer *_timer;
@property (nonatomic, retain) AcornBaseViewRenderer *_renderer;
- (void)start;
- (void)stop;
- (void)insertBallAtPoint:(CGPoint)pt radius:(float)radius pointObject:(AcornPointObject*)pointObject;

#define GRAVITY 1400.0f
#define BALL_MASS 1.0f
#define MIN_R 6
#define MAX_R 32

#define STEP_INTERVAL 1/60.0f
#define ACCEL_INTERVAL 1/30.0f
#define FILTER_FACTOR 0.05f

#define BK_COLOR_KEY @"bk_color"

@end
