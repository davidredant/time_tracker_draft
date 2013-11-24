//
//  TimerViewController.m
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()

@end

@implementation TimerViewController
@synthesize countdownLabel;


int hours,minutes,seconds;
int secondremains;

-(void)UpdateingCount:(NSTimer *)theTimer{
    if (secondremains>0) {
        secondremains--;
        hours=secondremains/3600;
        minutes=(secondremains%3600)/60;
        seconds=(secondremains%3600)%60;
        countdownLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];
        
    }
}

-(void)countdownTimer{
   
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(UpdateingCount:) userInfo:nil repeats:YES];
    
}

-(IBAction)StartTimer:(id)sender{
    if (timer==nil) {
        [self countdownTimer];
    }
}

-(IBAction)PauseTimer:(id)sender{
    
}

-(IBAction)StopTimer:(id)sender{
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    secondremains=20000;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
