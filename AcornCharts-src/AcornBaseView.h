//
//  AcornBaseView.h
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 Muh Hon Cheng. All rights reserved.
//

#import "chipmunk.h"
#import <CoreMotion/CoreMotion.h>

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
- (void)start;
- (void)stop;
- (void)insertBallAtPoint:(CGPoint)pt radius:(float)radius pointObject:(AcornPointObject*)pointObject;

@end
