//
//  WorkOutModel.h
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkOutModel : NSObject

@property(nonatomic, strong)NSString *workoutName;
@property int workoutInterval;
@property int restLength;
@property int numberOfIntervals;

@end
