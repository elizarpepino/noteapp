//
//  FormViewController.m
//  notches
//
//  Created by Elizar Pepino on 8/30/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController () {
    IBOutlet UITextField *_titleField;
    IBOutlet UITextView *_bodyField;
}

@end

@implementation FormViewController
@synthesize delegate = _delegate;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    // If body and title fields are empty, then we alert the user.
    if ([_titleField.text isEqualToString:@""] || [_bodyField.text isEqualToString:@""]) {
        if ([_titleField isFirstResponder]) {
            [_titleField resignFirstResponder];
        } else if ([_bodyField isFirstResponder]) {
            [_bodyField resignFirstResponder];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Save!" message:@"Title, or Body cannot be empty" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    // otherwise, process data
    NSDictionary *fields = [NSDictionary dictionaryWithObjects:@[_titleField.text, _bodyField.text] forKeys:@[@"title", @"body" ]];
    [self.delegate formDidSubmitWithFields:fields fromViewController:self];
}

@end
