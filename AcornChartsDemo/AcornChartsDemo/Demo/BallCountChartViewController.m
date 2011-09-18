//
//  BallCountChartViewController.m
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 BuUuK Pte Ltd. All rights reserved.
//

#import "BallCountChartViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BallCountChartViewController
@synthesize chartView;

- (void)dealloc
{
    [self.chartView stop];
    self.chartView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self.view setBackgroundColor:COLOR_LIGHT_BROWN];
        
        float width = [self.view bounds].size.width-150;
        float height = [self.view bounds].size.height-150;
        
        self.chartView = [[AcornBallCountChartView alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2, ([self.view bounds].size.height-height)/2, width, height)];
        [self.chartView setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:234/255.0 alpha:1]];
        [self.chartView.layer setCornerRadius:20];
        [self.view addSubview:self.chartView];
        [self.chartView release];
        //[self.chartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        NSMutableArray *points = [NSMutableArray array];
        
        for (int i=0; i<10; i++)
        {
            AcornPointObject *point1 = [[[AcornPointObject alloc] init] autorelease];
            [point1 setIdentifier:[NSString stringWithFormat:@"%i", i]];
            [point1 setValue:(10 + rand()%100)];
            [points addObject:point1];
            float base = 10 + rand()%100;
            if (i==0){
                [point1 setColor:COLOR_RED];
            }
            else if (i==1){
                [point1 setColor:COLOR_BLUE];
            }
            else if (i==2){
                [point1 setColor:COLOR_YELLOW];
            }
            else if (i==3){
                [point1 setColor:COLOR_ORANGE];
            }
            else if (i==4){
                [point1 setColor:COLOR_GREEN];
            }
            else if (i==5){
                [point1 setColor:COLOR_PINK];
            }
            else if (i==6){
                [point1 setColor:COLOR_PURPLE];
            }
            else if (i==7){
                [point1 setColor:COLOR_CYAN];
            }
            else [point1 setColor:[UIColor colorWithRed:base/255.0 green:base/255.0 blue:base/255.0 alpha:1]];
        }
        
        [self.chartView setPoints:points];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.chartView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.chartView stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationPortrait==interfaceOrientation;
}

@end
