//
//  TimerViewController.h
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#define kWorkInterval @"Interval"
#define tRestLength @"Rest"

@class WorkOutModel;

@interface TimerViewController : UIViewController{
    NSTimer *timer;
   
}

@property(nonatomic,strong) WorkOutModel *aWorkout;
@property(nonatomic,strong) IBOutlet UILabel *stageLabel;
@property(nonatomic,strong) IBOutlet UILabel *countdownLabel;
@property(nonatomic,strong) IBOutlet UIButton *btnStart;
@property(nonatomic,strong) IBOutlet UIButton *btnPause;
@property SystemSoundID sysSoundID;

-(void)UpdateingCount:(NSTimer *)theTimer;
-(void)countdownTimer;
-(IBAction)StartTimer:(id)sender;
-(IBAction)PauseTimer:(id)sender;
-(IBAction)StopTimer:(id)sender;
-(void)SWitchStage :(NSString *)stage;
-(void)PrintLablelWithTimeFormat:(int)isecondremains;


@end
