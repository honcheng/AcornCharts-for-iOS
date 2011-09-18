//
//  AcornBaseView.m
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 Muh Hon Cheng. All rights reserved.
//


#import "AcornBaseView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AcornBaseViewRenderer

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
	CGColorRef color = (CGColorRef) [[layer valueForKey:BK_COLOR_KEY] CGColor];
	CGRect rect = [layer bounds];
	
	CGContextSetFillColorWithColor(ctx, color);
	CGContextFillEllipseInRect(ctx, rect);
}

@end

@implementation AcornPointObject
@synthesize identifier;
@synthesize value, percentage, color;

- (void)dealloc
{
    self.identifier = nil;
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ : %f (%f)", self.identifier, self.value, self.percentage];
}

@end

@interface AcornBaseView()
- (void)setupSpace;
- (void)step;
- (void)accelerometerDidAccelerate:(CMAcceleration)acceleration;
@end

@implementation AcornBaseView
@synthesize _motionManager, _timer, _renderer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        cpInitChipmunk();
        srand(time(NULL));
        [self setupSpace];
        
        self._renderer = [[[AcornBaseViewRenderer alloc] init] autorelease];
    }
    return self;
}

- (void)start
{
    
    self._timer = [NSTimer scheduledTimerWithTimeInterval:STEP_INTERVAL
                                     target:self
                                   selector:@selector(step)
                                   userInfo:nil
                                    repeats:YES];
    
    self._motionManager = [[[CMMotionManager alloc] init] autorelease];
    
    if ([self._motionManager isAccelerometerAvailable])
    {
        if (![self._motionManager isAccelerometerActive])
        {
            [self._motionManager setAccelerometerUpdateInterval:ACCEL_INTERVAL];
            [self._motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                
                [self accelerometerDidAccelerate:accelerometerData.acceleration];
                
            }];
        }
    }
}

- (void)stop
{
    [self._timer invalidate];
    self._timer = nil;
    [self._motionManager stopAccelerometerUpdates];
    self._motionManager = nil;
}

//  The base code for this file is based on ths sample code https://github.com/mattrajca/Physics-Demos.git
- (void)insertBallAtPoint:(CGPoint)pt radius:(float)radius pointObject:(AcornPointObject*)pointObject
{
    
	CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0.0f, 0.0f, radius * 2, radius * 2);
	layer.delegate = self._renderer;
	layer.position = pt;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,radius*2,radius*2)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [titleLabel setTextColor:[UIColor colorWithRed:231/255.0 green:227/255.0 blue:216/255.0 alpha:1]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:radius]];
    [titleLabel setText:pointObject.identifier];
    [layer addSublayer:titleLabel.layer];
    
	[layer setValue:pointObject.color forKey:BK_COLOR_KEY];
	
	[[self layer] addSublayer:layer];
	[layer setNeedsDisplay];
	
	cpBody *body = cpBodyNew(BALL_MASS, INFINITY);
	body->p = pt; // this dynamic body represents the ball at its center position
	cpSpaceAddBody(_space, body);
	
	cpShape *ball = cpCircleShapeNew(body, radius, cpvzero);
	ball->data = layer;
	ball->u = 0.0f;
	ball->e = 0.7f; // bounciness
	cpSpaceAddShape(_space, ball);
    
    
    //cpCircleShapeSetRadius(ball, radius);
}


//  The base code for this file is based on ths sample code https://github.com/mattrajca/Physics-Demos.git
- (void)setupSpace {
	_space = cpSpaceNew(); // setup the world in which the simulation takes place
	_space->elasticIterations = _space->iterations;
	_space->gravity = cpv(0.0f, GRAVITY); // initial gravity vector
	
	CGSize size = [self bounds].size;
	
	// setup the 'edges' of our world so the bouncing balls don't move offscreen
	cpBody *edge = cpBodyNewStatic();
	cpShape *shape = NULL;
	
	// left
	shape = cpSegmentShapeNew(edge, cpvzero, cpv(0.0f, size.height), 0.0f);
	shape->u = 0.1f; // minimal friction on the ground
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape); // a body can be represented by multiple shapes
	
	// top
	shape = cpSegmentShapeNew(edge, cpvzero, cpv(size.width, 0.0f), 0.0f);
	shape->u = 0.1f;
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape);
	
	// right
	shape = cpSegmentShapeNew(edge, cpv(size.width, 0.0f), cpv(size.width, size.height), 0.0f);
	shape->u = 0.1f;
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape);
	
	// bottom
	shape = cpSegmentShapeNew(edge, cpv(0.0f, size.height), cpv(size.width, size.height), 0.0f);
	shape->u = 0.1f;
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape);
}

static void updateSpace (void *obj, void *data) {
	cpShape *shape = (cpShape *) obj;
	CALayer *layer = shape->data;
	
	if (!layer)
		return;
	
	// sync the body's position with the on-screen representation
	layer.position = shape->body->p;
}

- (void)step {
	cpSpaceStep(_space, STEP_INTERVAL);
	
	[CATransaction setDisableActions:YES];
	cpSpaceHashEach(_space->activeShapes, &updateSpace, self); // update shape positions
	[CATransaction setDisableActions:NO];
}

- (void)accelerometerDidAccelerate:(CMAcceleration)acceleration
{
    static float prevX = 0.0f, prevY = 0.0f;
	
	prevX = (float) acceleration.x * FILTER_FACTOR + (1-FILTER_FACTOR) * prevX;
	prevY = (float) acceleration.y * FILTER_FACTOR + (1-FILTER_FACTOR) * prevY;
	
	_space->gravity = cpv(prevX * GRAVITY, -prevY * GRAVITY);
}

- (void)dealloc 
{
    //self._renderer = nil;
    [self._timer invalidate];
    self._timer = nil;
    [self._motionManager stopAccelerometerUpdates];
    self._motionManager = nil;
	cpSpaceFree(_space);
	[super dealloc];
}


@end
