//
//  Notes.h
//  notches
//
//  Created by Elizar Pepino on 8/29/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface Notes : NSObject

// Instance methods
- (Notes *)fetch;
- (Notes *)fetchWithUrlString:(NSString *)urlString;
- (void)setUrl:(NSString *)urlString;

// Static methods
+ (Notes *)notes;

@property (nonatomic, strong) NSMutableArray *models;
@end
