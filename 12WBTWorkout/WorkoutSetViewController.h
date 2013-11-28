//
//  WorkoutSetViewController.h
//  12WBTWorkout
//
//  Created by david on 24/11/2013.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNunmberofRows  4
#define kWorkoutNameIndex 0
#define kWorkoutInterval 1
#define kRestLength 2
#define kNumberOfIntervals 3

#define kPickerAnimationDuration 0.40
#define kDatePickerTag  99
#define kLabelTag   4096

#define kTitlle @"title"
#define kDateKey @"Date"


@class WorkOutModel;
@interface WorkoutSetViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic,strong) WorkOutModel *workOut;
@property (nonatomic,strong) NSArray *fieldName;
@property (nonatomic,strong) NSMutableDictionary *tempValues;
@property (nonatomic,strong) UITextField *txtFieldEditing;

@property (nonatomic,strong) UIDatePicker *datePicker;
//@property (nonatomic,strong) IBOutlet UIPickerView *datePicker;

@property NSUInteger indexOfEditingTextField;


-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
-(void)textFieldDone:(id)sender;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
