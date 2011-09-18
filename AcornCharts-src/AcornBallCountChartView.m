//
//  AcornBallCountChartView.m
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 BuUuK Pte Ltd. All rights reserved.
//

#import "AcornBallCountChartView.h"

@implementation AcornBallCountChartView
@synthesize points;
@synthesize current_index;

- (void)dealloc
{
    self.points = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)calculatePercentage
{
    float total = 0.0;
    for (AcornPointObject *point in self.points)
    {
        total += point.value;
    }
    
    for (AcornPointObject *point in self.points)
    {
        point.percentage = point.value/total;
    }
}

- (void)start
{
    [self calculatePercentage];
    [super start];
    
    float total_time = 5.0;
    float interval = total_time/TOTAL_BALLS;
    float current_interval = 0;
    for (int i=0; i<[self.points count]; i++)
    {
        AcornPointObject *pointObject = [self.points objectAtIndex:i];
        int n_ball_for_point = (int)(TOTAL_BALLS*pointObject.percentage);
        
        for (int n=0; n<n_ball_for_point; n++)
        {
            [self performSelector:@selector(insertBall:) withObject:pointObject afterDelay:current_interval];
            current_interval += interval;
        }
    }
}

- (void)insertBall:(AcornPointObject*)pointObject
{
    float space_area = self.frame.size.width*self.frame.size.height;
    float containing_square_area = space_area*0.8/TOTAL_BALLS;
    float containing_square_width = sqrt(containing_square_area);
    float radius = containing_square_width/2;
    
    CGPoint point = CGPointMake(radius + rand()%(int)(50), self.frame.size.height-radius);
    
    [self insertBallAtPoint:point radius:radius pointObject:pointObject];
}

@end
