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
- (void)addNewModelFromDictionary:(NSDictionary *)obj;
@end

@implementation Notes

@synthesize models = _models;

+ (Notes *)notes {
    
    if (_notesInstance == nil) {
        _notesInstance = [[Notes alloc] init];
    }
    
    return _notesInstance;
}

- (void)createDb
{
    NSURL *url = [NSURL URLWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // set http method to `PUT`
    [urlRequest setHTTPMethod:@"PUT"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        return [self displayErrorWithTitle:@"DB Error" andDescription:@"Could not create database. Please check your network connection and try again!"];
    }
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    
    if (!jsonData || [jsonData valueForKey:@"error"]) {
        return [self displayErrorWithTitle:@"Connection Error" andDescription:[jsonData valueForKey:@"error"]];
    } else {
        // re fetch data
        [self fetch];
    }
}

- (Notes *)fetch
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/_all_docs?include_docs=true", _url]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:nil];
    
    if (!data) {
        return nil;
    }
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    // if db does not exist
    if ([[jsonData valueForKey:@"error"] isEqualToString:@"not_found"]) {
        // create it
        [self createDb];
    } else {
        // set notes
        NSArray *results = [[NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil] valueForKey:@"rows"];
        
        // loop through each object in results and add it to our `_models` array
        for (NSDictionary *obj in results) {
            [self addNewModelFromDictionary:obj];
        }
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

- (Note *)createNoteFromDictionary:(NSDictionary *)note
{
    
    NSURL *url = [NSURL URLWithString:_url];
    // use nsmutableurlrequest for this one
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // let's create a mutable dictionary so we can add date attributes
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:note];
    // add `dare_created` and `date_updated` to our dictionary
    NSString *currentDate = [[NSDate date] description];
    [body setObject:currentDate forKey:@"date_created"];
    [body setObject:currentDate forKey:@"date_updated"];
    
    // let's create our http body from the dictionary `note`
    [urlRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:body
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil]];
    // set http method to "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    // set content-type to application/json
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        return nil;
    }
    
    // If data is available let's grab `em
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    // check if response does not have an `error`
    if (![jsonData valueForKey:@"error"]) {
        [jsonData setObject:body forKey:@"doc"];
        [self addNewModelFromDictionary:jsonData];
        
        // return the last added object
        return [_models firstObject];
    }
    
    // otherwise, return nil
    return nil;
}

- (void)setUrl:(NSString *)urlString
{
    _url = urlString;
}

- (void)addNewModelFromDictionary:(NSDictionary *)obj
{
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

- (void)displayErrorWithTitle:(NSString *)title andDescription:(NSString *)description
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:description
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
