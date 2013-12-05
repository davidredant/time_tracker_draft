//
//  RootViewController.m
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "RootViewController.h"
#import "WorkoutSetViewController.h"
#import "TimerViewController.h"
#import "AppDelegate.h"
#import "WorkOutModel.h"


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize timerViewController;
@synthesize workoutSetViewController;
@synthesize workOutList;
@synthesize IsEditing;

BOOL IFShowLabel=YES;

-(IBAction)SwitchToWorkoutSetView:(id)sender{
    
    UIViewController *workoutViewController=[[WorkoutSetViewController alloc] initWithNibName:@"WorkoutSetViewController" bundle:Nil];
    
    [[self navigationController] pushViewController:workoutViewController animated:YES];
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
       [super viewDidLoad];

    self.title=@"Timer";
    
     self.navigationItem.leftBarButtonItem=self.editButtonItem;
    
    //add customer button at right top
    UIBarButtonItem *newButton;
    newButton=[[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(SwitchToWorkoutSetView:)];
    self.navigationItem.rightBarButtonItem=newButton;
    
    
}

-(void)UpdateDataSource: (int)Index{
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSEntityDescription *WorkOut=[NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    
    
    [request setEntity:WorkOut];
    
    NSError *error;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    
    NSManagedObject *dworkout=[objects objectAtIndex:Index];
    [context deleteObject:dworkout];
    [context save:&error];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.workOutList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RootViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    WorkOutModel *aWorkout=[self.workOutList objectAtIndex:[indexPath row]];
    UILabel *label_name=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
    label_name.tag=kLabelTag;
    label_name.font=[UIFont boldSystemFontOfSize:16];
    label_name.text=aWorkout.workoutName;
    [cell.contentView addSubview:label_name];
    
    UILabel *label_Interval=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 25)];
    label_Interval.tag=kLabelTag;
    label_Interval.font=[UIFont boldSystemFontOfSize:10];
    label_Interval.text=[NSString stringWithFormat:@"%@%@",@"Intervals: ",[self ConvertIntToDateTime:aWorkout.workoutInterval]];
    [cell.contentView addSubview:label_Interval];
    
    UILabel *label_rest=[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 105, 25)];
    label_rest.tag=kLabelTag;
    label_rest.font=[UIFont boldSystemFontOfSize:10];
    label_rest.text=[NSString stringWithFormat:@"%@%@",@"Rest: ",[self ConvertIntToDateTime:aWorkout.restLength]];
    [cell.contentView addSubview:label_rest];
    
    UILabel *label_Laps=[[UILabel alloc] initWithFrame:CGRectMake(180, 10, 105,50)];
    label_Laps.tag=kLabelTag;
    label_Laps.font=[UIFont boldSystemFontOfSize:20];
    label_Laps.text=[NSString stringWithFormat:@"%@%d",@"X ",aWorkout.numberOfIntervals];
    [cell.contentView addSubview:label_Laps];

   
        UILabel *label_paly=[[UILabel alloc] initWithFrame:CGRectMake(220, 35, 40,15)];
        
        label_paly.tag=LabelPlayTag;
        label_paly.font=[UIFont boldSystemFontOfSize:12];
        label_paly.text=@"Start";
        label_paly.backgroundColor=[UIColor grayColor];
        label_paly.textColor=[UIColor whiteColor];
        label_paly.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:label_paly];
   
    
      
    
    
    
    
    return cell;
}

-(NSString *)ConvertIntToDateTime :(NSUInteger)inputSeconds{
    NSString *formatterDate=@"00:00:00";
    NSUInteger hours,minutes,seconds;
    hours=inputSeconds/3600;
    minutes=(inputSeconds%3600)/60;
    seconds=(inputSeconds%3600)%60;
    formatterDate=[NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];
    return formatterDate;
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        IsEditing=YES;
    }
    else
    {
        IsEditing=NO;
    }
}

#pragma -
#pragma mark table delegate datasource
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[self workOutList] removeObjectAtIndex:indexPath.row];
        [self UpdateDataSource:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        

    }   
}




// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     // Navigation logic may go here, for example:
     // Create the next view controller.
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     
     // Pass the selected object to the new view controller.
     */
    if ([self IsEditing]) {
        
        WorkoutSetViewController *workoutViewController=[[WorkoutSetViewController alloc] initWithNibName:@"WorkoutSetViewController" bundle:Nil];
        
      
        WorkOutModel *aWorkout=[self.workOutList objectAtIndex:[indexPath row]];
        workoutViewController.title=aWorkout.workoutName;
        workoutViewController.workOut=aWorkout;
       AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
        
        [delegate.navigationController pushViewController:workoutViewController animated:YES];

    }
    else{
    
        TimerViewController *atimerViewController=[[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
       WorkOutModel *aWorkout=[self.workOutList objectAtIndex:[indexPath row]];
        atimerViewController.title=aWorkout.workoutName;
        atimerViewController.aWorkout=aWorkout;
       [self.navigationController pushViewController:atimerViewController animated:YES];
    }
    
   
    
}

-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellAccessoryDisclosureIndicator;
}

-(void)viewWillAppear:(BOOL)animated{
 
   
    //begin loading list of workout from save file
     self.workOutList=[[NSMutableArray alloc] init];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];

    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSEntityDescription *WorkOut=[NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];

    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    
    
    [request setEntity:WorkOut];
    
    NSError *error;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    
    if ([objects count]>0) {
        for (NSManagedObject *obj in objects){
            
            WorkOutModel *aWorkOut=[[WorkOutModel alloc] init];
            aWorkOut.workoutName=[obj valueForKey:@"name"];
            aWorkOut.workoutInterval=[[obj valueForKey:@"intervals"] integerValue];
            aWorkOut.restLength=[[obj valueForKey:@"rest"] integerValue];
            aWorkOut.numberOfIntervals=[[obj valueForKey:@"laps"] integerValue];
            
            [self.workOutList addObject:aWorkOut];
        }
    }
    
    self.tableView.dataSource=self;
    
    self.tableView.rowHeight=60.0f;
    [self.tableView reloadData];
}
 

@end
