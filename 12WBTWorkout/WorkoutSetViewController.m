//
//  WorkoutSetViewController.m
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "WorkoutSetViewController.h"
#import "WorkOutModel.h"
#import "AppDelegate.h"


@interface WorkoutSetViewController ()

@end

@implementation WorkoutSetViewController
@synthesize workOut;
@synthesize fieldName;
@synthesize tempValues;
@synthesize txtFieldEditing;
@synthesize datePicker;
@synthesize indexOfEditingTextField;

-(IBAction)cancel:(id)sender{
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    [delegate.navigationController popViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender{
    
    WorkOutModel *aWorkOut=[[WorkOutModel alloc] init];
    if (txtFieldEditing !=Nil) {
        NSNumber *tagNum=[[NSNumber alloc] initWithInt:txtFieldEditing.tag];
        [tempValues setObject:txtFieldEditing forKey:tagNum];
    }
    for (NSNumber *key in [tempValues allKeys]) {
        switch ([key intValue]) {
            case kWorkoutNameIndex:
                aWorkOut.workoutName=[tempValues objectForKey:key];
                break;
            case kWorkoutInterval:
                
                aWorkOut.workoutInterval=[self ConvertTimerToInt:[tempValues objectForKey:key]];
                
                
                break;
            case kRestLength:
                aWorkOut.restLength=[self ConvertTimerToInt:[tempValues objectForKey:key]];
                break;
            case kNumberOfIntervals:
                aWorkOut.numberOfIntervals=[[tempValues objectForKey:key] intValue];
                break;
                
                
            default:
                break;
        }
    }
    
    
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSManagedObject *newWorkOut;
    newWorkOut=[NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:context];
    
    [newWorkOut setValue: aWorkOut.workoutName forKey:@"name"];
    [newWorkOut setValue: [NSNumber numberWithInteger:aWorkOut.workoutInterval] forKey:@"intervals"];
    [newWorkOut setValue: [NSNumber numberWithInteger:aWorkOut.restLength] forKey:@"rest"];
    [newWorkOut setValue: [NSNumber numberWithInteger:aWorkOut.numberOfIntervals] forKey:@"laps"];
    
     NSError *error;
    [context save:&error];
    
    
  
     
     AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
     UINavigationController *navController=[delegate navigationController];
     [navController popViewControllerAnimated:YES];
     NSArray *allControllers=navController.viewControllers;
     UITableViewController *parent=[allControllers lastObject];
     
     [parent.tableView reloadData];
    
    
    
}

-(int)ConvertTimerToInt:(NSString *)timerInString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"HH:mm:ss";
    NSDate *timeDate=[formatter dateFromString:timerInString];
    formatter.dateFormat=@"HH";
    int hour=[[formatter stringFromDate:timeDate] intValue];
    formatter.dateFormat=@"mm";
    int minute=[[formatter stringFromDate:timeDate] intValue];
    formatter.dateFormat=@"ss";
    int second=[[formatter stringFromDate:timeDate] intValue];
    second +=hour*3600+minute*60;
    return second;
}

-(void)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
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
    self.title=@"Workout";
    
    
    
    NSArray *fieldNames=[[NSArray alloc] initWithObjects:@"Workout Name", @"Workout Intervals",@"Rest Length", @"Number Of Intervals", nil];
    self.fieldName=fieldNames;
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem=saveButton;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    self.tempValues=dictionary;
    

    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return kNunmberofRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        // Configure the cell...
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 25)];
        label.tag=kLabelTag;
        label.font=[UIFont boldSystemFontOfSize:10];
        
        [cell.contentView addSubview:label];
        
        UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(150, 12, 100, 25)];
        
        if (indexPath.row==3) {
            txtField=[[UITextField alloc] initWithFrame:CGRectMake(150, 12, 50, 25)];
            UISwitch *switchInfinite=[[UISwitch alloc] initWithFrame:CGRectMake(240, 12, 20, 10)];
            switchInfinite.on=FALSE;
            
            [cell.contentView addSubview:switchInfinite];
            UILabel *labelForSwitch=[[UILabel alloc] initWithFrame:CGRectMake(205, 12, 80, 25)];
            labelForSwitch.text=@"INFINITE";
            labelForSwitch.font=[UIFont systemFontOfSize:8];
            [cell.contentView addSubview:labelForSwitch];
            
            
        }
        
        
        txtField.textAlignment=NSTextAlignmentRight;
        
        txtField.clearsOnBeginEditing=NO;
        [txtField setBorderStyle:UITextBorderStyleRoundedRect];
        [txtField setDelegate:self];
        txtField.returnKeyType=UIReturnKeyDone;
        [txtField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:txtField];
    }
    
    NSUInteger row=[indexPath row];
    UILabel *label=(UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *txtField=nil;
    for (UIView *aView in cell.contentView.subviews) {
        
        if([aView isMemberOfClass:[UITextField class]])
            txtField=(UITextField *)aView;
    }
    label.text=[fieldName objectAtIndex:row];
    NSNumber *rowNum=[[NSNumber alloc] initWithInt:row];
    switch (row) {
        case kWorkoutNameIndex:
            
            if ([[tempValues allKeys] containsObject:rowNum]) {
                txtField.text=[tempValues objectForKey:rowNum];
            }else{
                txtField.text=self.workOut.workoutName;
            }
            break;
        case kWorkoutInterval:
            
            [self LoadDatePicker:txtField];
            if ([[tempValues allKeys] containsObject:rowNum]) {
                txtField.text=[tempValues objectForKey:rowNum];
            }else{
                txtField.text=[NSString stringWithFormat:@"%d",self.workOut.workoutInterval];
            }
            break;
        case kRestLength:
            
            [self LoadDatePicker:txtField];
            if ([[tempValues allKeys] containsObject:rowNum]) {
                txtField.text=[tempValues objectForKey:rowNum];
            }else{
                
                txtField.text=[NSString  stringWithFormat:@"%d",self.workOut.restLength];
            }
            break;
        case kNumberOfIntervals:
            
            txtField.keyboardType=UIKeyboardTypeDecimalPad;
            if ([[tempValues allKeys] containsObject:rowNum]) {
                txtField.text=[tempValues objectForKey:rowNum];
            }else{
                
                txtField.text=[NSString  stringWithFormat:@"%d",self.workOut.numberOfIntervals];
            }
            break;
            
            
            
    }
    if (txtFieldEditing==txtField) {
        txtFieldEditing=nil;
    }
    
    txtField.tag=row;
    
    
    
    return cell;
}

-(void)LoadDatePicker:(id)sender
{
    UITextField *txtField=nil;
    txtField=(UITextField *)sender;
    datePicker=[[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [txtField setInputView:datePicker];
}

-(void)updateTextField:(id)sender{
    UITextField *txtField=nil;
    
    UIDatePicker *picker=(UIDatePicker *)sender;
    txtField=(UITextField *)[self.view viewWithTag:indexOfEditingTextField];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    txtField.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:picker.date]];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    indexOfEditingTextField=textField.tag;
    //self.txtFieldEditing=textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSNumber *tagNum=[[NSNumber alloc] initWithInt:textField.tag];
    [tempValues setObject:textField.text forKey:tagNum];
    
    [self textFieldDone:self];
    
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
