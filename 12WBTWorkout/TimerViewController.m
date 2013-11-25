//
//  TimerViewController.m
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "TimerViewController.h"
#import "WorkOutModel.h"

@interface TimerViewController ()

@end

@implementation TimerViewController
@synthesize stageLabel;
@synthesize countdownLabel;
@synthesize aWorkout;
@synthesize sysSoundID;

int hours,minutes,seconds;
int secondremains;
int counts=4;

int LapCount=1;
NSString *StageName;

NSURL *sound_url_ping=nil;
NSURL *sound_url_glass=nil;

-(void)UpdateingCount:(NSTimer *)theTimer{
    if (counts>1) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_ping,&sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        
        counts--;
        
    }else if(counts==1){
        
    
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_glass,&sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        counts--;
        
    }else
    {
        
        if (secondremains>0) {
            secondremains--;
            [self PrintLablelWithTimeFormat:secondremains];

            
            if (secondremains<=6) {
                [self MakeAlert:secondremains];
                if (secondremains<=0) {
                    [self SWitchStage:StageName];
                }
               
            }
            
        }
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
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }}

-(IBAction)StopTimer:(id)sender{
    secondremains=0;
   
    countdownLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d", 0,0,0];
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
}

-(void)MakeAlert:(int)seconds{
    if (seconds>=6)  return;
    
    if (seconds>=1) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_ping,&sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        
        
    }else if(seconds<1){
        
        
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_glass,&sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        
    }
}

-(void)SWitchStage :(NSString *)stage {
    
    //if (LapCount>aWorkout.numberOfIntervals)
    
     //   return;
    WorkOutModel *objWorkout=[self aWorkout];
    if ([stage isEqualToString:kWorkInterval]) {
        stage=tRestLength;
        secondremains=objWorkout.restLength;
        
    }else
    {
        stage=kWorkInterval;
        secondremains=objWorkout.workoutInterval;
        LapCount++;
    }
    stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",LapCount,stage];
    
    
}

-(void)PrintLablelWithTimeFormat:(int)isecondremains{
    hours=isecondremains/3600;
    minutes=(isecondremains%3600)/60;
    seconds=(isecondremains%3600)%60;
    countdownLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];

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
    WorkOutModel *objWorkout=[self aWorkout];
    
    secondremains=objWorkout.workoutInterval;
    [self PrintLablelWithTimeFormat:secondremains];
    
    
    // Do any additional setup after loading the view from its nib.
    
    //NSString *path=[[NSBundle mainBundle] pathForResource:@"Tock" ofType:@"aiff"];
    sound_url_ping=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ping" ofType:@"aiff"]];
    sound_url_glass=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Glass" ofType:@"aiff"]];
    
    
    StageName=kWorkInterval;
    stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",1,StageName];
    
     [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
   // AudioServicesDisposeSystemSoundID(sysSound);
}

@end
