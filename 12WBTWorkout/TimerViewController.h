//
//  TimerViewController.h
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController{
    NSTimer *timer;
}
@property(nonatomic,strong) IBOutlet UILabel *countdownLabel;
@property(nonatomic,strong) IBOutlet UIButton *btnStart;
@property(nonatomic,strong) IBOutlet UIButton *btnPause;
-(void)UpdateingCount:(NSTimer *)theTimer;
-(void)countdownTimer;
-(IBAction)StartTimer:(id)sender;
-(IBAction)PauseTimer:(id)sender;
-(IBAction)StopTimer:(id)sender;
@end
