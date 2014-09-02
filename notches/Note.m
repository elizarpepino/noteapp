//
//  Note.m
//  notches
//
//  Created by Elizar Pepino on 8/29/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "Note.h"

@implementation Note
@synthesize id;
@synthesize rev;
@synthesize url;
@synthesize title;
@synthesize body;
@synthesize dateCreated;
@synthesize dateUpdated;

- (BOOL)remove
{
    NSURL *_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?rev=%@", [self url], [self rev]]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:_url];
    
    // set http method to `PUT`
    [urlRequest setHTTPMethod:@"DELETE"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        return NO;
    }
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    if ([jsonData valueForKey:@"error"]) {
        return NO;
    }
    
    return YES;
}
@end
