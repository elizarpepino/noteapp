//
//  Notes.m
//  notches
//
//  Created by Elizar Pepino on 8/29/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "Notes.h"

Notes *_notesInstance = nil;

@interface Notes () {
    NSString *_url;
    
}

@end

@implementation Notes

@synthesize models = _models;

+ (Notes *)notes {
    
    if (_notesInstance == nil) {
        _notesInstance = [Notes alloc];
    }
    
    return _notesInstance;
}

- (Notes *)fetch
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/_all_docs?include_docs=true", _url]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:nil];
    if (data) {
        // set notes
        NSArray *results = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] valueForKey:@"rows"];
        
        for (NSDictionary *obj in results) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZ"];
            
            Note *note = [[Note alloc] init];
            note.id = (int) [obj valueForKey:@"id"];
            note.url = [NSString stringWithFormat:@"%@/%@", _url,[obj valueForKey:@"id"]];
            note.title = [obj valueForKeyPath:@"doc.title"];
            note.body = [obj valueForKeyPath:@"doc.body"];
            note.dateCreated = [formatter dateFromString:[obj valueForKeyPath:@"doc.date_created"]];
            note.dateUpdated = [formatter dateFromString:[obj valueForKeyPath:@"doc.date_updated"]];
            
            if (!_models) {
                _models = [[NSMutableArray alloc] init];
            }
            [_models insertObject:note atIndex:0];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data not fetched. Check your network connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self models];
    return self;
    
}

- (Notes *)fetchWithUrlString:(NSString *)urlString
{
    // TODO: do something awesome
    _url = urlString;
    return [self fetch];
    
}

- (void)setUrl:(NSString *)urlString
{
    _url = urlString;
}

@end
