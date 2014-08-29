//
//  TableViewController.m
//  notches
//
//  Created by Elizar Pepino on 8/29/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () {
    NSMutableArray *_notes;
}
@end

@implementation TableViewController

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
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *notes = [[[Notes notes] fetchWithUrlString:@"http://localhost:5984/notes"] models];
    if (!_notes) {
        _notes = [[NSMutableArray alloc] init];
    }
    [_notes setArray:notes];
    [self.tableView reloadData];
    
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
    return _notes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    Note *note = [_notes objectAtIndex:indexPath.row];
    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [formatter stringFromDate:note.dateCreated];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell setSelectedBackgroundView:bgView];
    [cell.selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:11 green:110 blue:0 alpha:1]];

    return cell;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailview"]) {
        // get the tableviews selected indexpat so we can get our object from the `_notes` array
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailsForNote:[_notes objectAtIndex:indexPath.row]];
    } else if ([segue.identifier isEqualToString:@"formview"]) {
        // let's make our self the formview controller's delegate
        // so we can implement the formdidSubmit... method
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - delegate methods
- (void)formDidSubmitWithFields:(NSDictionary *)fields fromViewController:(UIViewController *)controller
{
    // TODO: notes api call for creating new note
    [controller dismissViewControllerAnimated:YES completion:nil];
    Note *note = [[Notes notes] createNoteFromDictionary:fields];
    if (note) {
        [_notes insertObject:note atIndex:0];
        [self.tableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Save!" message:@"Error while processing your request." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
