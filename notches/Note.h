//
//  Note.h
//  notches
//
//  Created by Elizar Pepino on 8/29/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *rev;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSDate *dateUpdated;

- (BOOL)remove;
@end
