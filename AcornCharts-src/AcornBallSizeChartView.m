//
//  AcornBallSizeChartView.m
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 BuUuK Pte Ltd. All rights reserved.
//

#import "AcornBallSizeChartView.h"

@implementation AcornBallSizeChartView

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
    [self performSelector:@selector(insertBall) withObject:nil afterDelay:0.2];
}

- (void)insertBall
{
    
    AcornPointObject *pointObject = [self.points objectAtIndex:self.current_index];
    
    float space_area = self.frame.size.width*self.frame.size.height;
    float containing_square_area = space_area*pointObject.percentage*0.6;
    float containing_square_width = sqrt(containing_square_area);
    float radius = containing_square_width/2;
    
    CGPoint point = CGPointMake(radius/2 + rand()%50, self.frame.size.height-radius/2+ rand()%10);
    [self insertBallAtPoint:point radius:radius pointObject:pointObject];
    
    self.current_index += 1;
    if (self.current_index < [self.points count])
    {
        [self performSelector:@selector(insertBall) withObject:nil afterDelay:0.2];
    }
}

@end
