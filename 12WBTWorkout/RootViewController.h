//
//  RootViewController.h
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerViewController;
@class WorkoutSetViewController;
@class WorkOutModel;


@interface RootViewController : UITableViewController

@property(nonatomic,strong) NSMutableArray *workOutList;
@property(nonatomic, strong) IBOutlet TimerViewController *timerViewController;
@property(nonatomic,strong) IBOutlet WorkoutSetViewController *workoutSetViewController;

-(IBAction)SwitchToWorkoutSetView:(id)sender;


@end
