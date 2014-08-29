//
//  DetailViewController.h
//  notches
//
//  Created by Elizar Pepino on 8/29/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface DetailViewController : UIViewController

@property (nonatomic, assign) IBOutlet UITextView *bodyText;

- (void)setDetailsForNote:(Note *)note;

@end
