//
//  TimerViewController.m
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "TimerViewController.h"
#import "WorkOutModel.h"
#import "TimerStage.h"

@interface TimerViewController ()

@end

@implementation TimerViewController
@synthesize stageLabel;
@synthesize countdownLabel;
@synthesize aWorkout;
@synthesize sysSoundID;
@synthesize btnPause;
@synthesize btnReset;
@synthesize btnStart;
@synthesize tableStages;

int hours,minutes,seconds;
int secondremains;
int counts=4;

int RecordCount=1;
NSString *StageName;

NSURL *sound_url_ping=nil;
NSURL *sound_url_glass=nil;
NSMutableArray *lstStages;

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
                    [self SWitchStage];
                }
               
            }
            
        }
    }
    countdownLabel.text=[self PrintLablelWithTimeFormat:secondremains];
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

-(IBAction)Reset:(id)sender
{
    
}

-(void)SWitchStage{
    
    TimerStage *astage=[lstStages objectAtIndex:RecordCount];
    secondremains=astage.length;
    
    stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",astage.lap,astage.stageName];
    RecordCount++;
    astage=nil;
    
    //remove first row from tableview
    [tableStages setEditing:!tableStages.editing animated:YES];
    [tableStages beginUpdates];
    NSArray *deletingIndexPaths=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
    [tableStages deleteRowsAtIndexPaths:deletingIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [tableStages endUpdates];
    
}

-(void)LoadStags:(WorkOutModel *)workout{
    
    if (workout.numberOfIntervals==0) {
        workout.numberOfIntervals=maxPlayLap;
    }
    lstStages=[[NSMutableArray alloc] initWithCapacity:workout.numberOfIntervals*2];
    
    int lengthforInteval=workout.workoutInterval;
    int lengthforRest=workout.restLength;
    int loops=workout.numberOfIntervals;
    
    workout=nil;
   
    for (int i=1; i<=loops; i++) {
        TimerStage *stage1=[[TimerStage alloc]init];
        stage1.lap=i;
        stage1.stageName=@"Interval";
        stage1.length=lengthforInteval;
        [lstStages addObject:stage1];
        
        
        TimerStage *stage2=[[TimerStage alloc]init];

        stage2.lap=i;
        stage2.stageName=@"Rest";
        stage2.length=lengthforRest;
        [lstStages addObject:stage2];
        stage1=nil;
        stage2=nil;
        
        

    }
    
    
    
}

-(NSString *)PrintLablelWithTimeFormat:(int)isecondremains{
    hours=isecondremains/3600;
    minutes=(isecondremains%3600)/60;
    seconds=(isecondremains%3600)%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];
   
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
   
    
    // Do any additional setup after loading the view from its nib.
    
    
    sound_url_ping=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ping" ofType:@"aiff"]];
    sound_url_glass=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Glass" ofType:@"aiff"]];
    
    
    WorkOutModel *objWorkout=[self aWorkout];
    
    
    secondremains=objWorkout.workoutInterval;
    countdownLabel.text=[self PrintLablelWithTimeFormat:secondremains];
    

    StageName=kWorkInterval;
    stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",1,StageName];
    [self LoadStags:objWorkout];
    
    
    tableStages.dataSource=self;
    tableStages.delegate=self;
    [self.view addSubview:self.tableStages];
    
    [super viewDidLoad];
}


-(void)DisplayListStages :(WorkOutModel *)workout{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
   // AudioServicesDisposeSystemSoundID(sysSound);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return lstStages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimerStageControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
        // Configure the cell...
        TimerStage *stage=[lstStages objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"Lap %d %@ %@",stage.lap,stage.stageName,[self PrintLablelWithTimeFormat:stage.length]];
    stage=nil;
    
   return cell;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}
-(void)viewDidAppear:(BOOL)animated{
}

@end
