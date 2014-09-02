//
//  FormViewController.h
//  notches
//
//  Created by Elizar Pepino on 8/30/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FormViewDelegate <NSObject>

@required
- (void)formDidSubmitWithFields:(NSDictionary *)fields fromViewController:(UIViewController *)controller;

@end

@interface FormViewController : UIViewController
@property (nonatomic, retain) id <FormViewDelegate> delegate;
@end
