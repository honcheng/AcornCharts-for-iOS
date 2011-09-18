//
//  AcornBallSizeChartView.h
//  AcornChartsDemo
//
//  Created by Muh Hon Cheng on 18/9/11.
//  Copyright 2011 BuUuK Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcornBaseView.h"

@interface AcornBallSizeChartView : AcornBaseView
@property (nonatomic, retain) NSArray *points;
@property (nonatomic, assign) int current_index;
- (void)calculatePercentage;
@end
