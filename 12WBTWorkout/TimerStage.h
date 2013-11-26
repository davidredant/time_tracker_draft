//
//  TimerStage.h
//  12WBTWorkout
//
//  Created by david on 26/11/13.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerStage : NSObject
@property(nonatomic, strong)NSString *stageName;
@property int lap;
@property int length;

@end
